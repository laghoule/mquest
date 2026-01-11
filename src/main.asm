;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

TITLE Mia's Herbal Quest
.MODEL SMALL
.8086
.STACK 100h

INCLUDE defs/macros.inc         ; Macros
INCLUDE defs/consts/consts.inc  ; Constants

.DATA

  INCLUDE defs/vars/music.inc        ; Music variables and songs
  INCLUDE assets/carac/mia.inc       ; Mia animations sprite data

  INCLUDE assets/tiles/grass.inc     ; Grass tiles data
  INCLUDE assets/tiles/flowers.inc   ; Items tiles data
  INCLUDE assets/tiles/tables.inc    ; Tiles table data
  INCLUDE assets/tiles/rocks.inc     ; Rocks tiles data
  INCLUDE assets/tiles/plants.inc    ; Plants tiles data
  INCLUDE assets/tiles/objects.inc   ; Objects tiles data

  INCLUDE assets/maps/map.inc        ; Map data
  INCLUDE assets/maps/map_o_0.inc    ; Map opaque
  INCLUDE assets/maps/map_t_0.inc    ; Map transparent

  ; Tiles info
  tile DW 0               ; Tile

  ; Generic sprite info
  curr_sprite DW 0        ; Current sprite to draw
  curr_sprite_table DW 0  ; Current sprite table
  curr_anim_state DB 0    ; Current animation state
  bg_sprite DB 272 DUP(0) ; Background sprite
  pos_x DW 0              ; Sprite x position
  pos_y DW 0              ; Sprite y position

  ; For smooth animation
  game_tick DB 0          ; Global metronome for smooth animation (TODO: name)
  pending_tick DB 0       ; Pending tick used for slow hardware

  ; Mia sprite info
  mia_pos_x         DW 150                ; Mia starting x position
  mia_pos_y         DW 90                 ; Mia starting y position
  mia_bg_sprite     DB 272 DUP(0)         ; Mia background sprite
  mia_curr_sprite   DW OFFSET mia_down_0  ; Front / down animation for starting point
  mia_r_anim_state  DB 0                  ; Mia right animation state (0, 1, 2 state)
  mia_l_anim_state  DB 0                  ; Mia left animation state (0, 1, 2 state)
  mia_u_anim_state  DB 0                  ; Mia up animation state (0, 1, 2 state)
  mia_d_anim_state  DB 0                  ; Mia down animation state (0, 1, 2 state)

.CODE
INCLUDE timer.asm         ; Timer functions
INCLUDE speaker.asm       ; Speaker functions
INCLUDE inputs.asm        ; Inputs functions
INCLUDE player.asm        ; Player functions
INCLUDE car_draw.asm      ; Caracters drawing functions
INCLUDE til_draw.asm      ; Tiles drawing functions
INCLUDE map_draw.asm      ; Maps drawing functions

MAIN PROC
  ; ---Initialize data segment---
  MOV AX, @DATA
  MOV DS, AX

  ; ---Initialize mode 13h with bios call / VGA---
  MOV AX, 13h
  INT 10h
  MOV AX, VGA_ADDR
  MOV ES, AX

  ; --- Draw background and caracter ---
  MOV curr_map, OFFSET map_opq_0
  CALL DRAW_OPAQUE_MAP                ; This is the base map layer

  MOV AX, OFFSET map_trns_0
  MOV curr_map, AX
  CALL DRAW_TRANSPARENT_MAP           ; This is the transparent items on the map

  PREPARE_MIA_DRAW
  CALL SAVE_CARACTER_BG               ; Save the background of the character
  CALL DRAW_CARACTER                  ; Initial position of the character

  CALL INIT_MUSIC_THEME               ; Initialize music theme

  ; --- Game loop ---
  CALL INIT_TICKS                     ; Initialise the game_tick & pending_tick
  CALL GAME_LOOP                      ; Start the game loop

  ; ---Return to text mode---
  MOV AX, TEXT_MODE
  INT 10h

  ; ---Return to dos---
  MOV AX, 4C00h
  INT 21h

MAIN ENDP

; --- Game loop ---
GAME_LOOP PROC
  SAVE_REGS

@gl_get_next_key:
  WAIT_VSYNC                  ; Wait for vertical syncronization to avoid flickering

  CALL SYNC_TICKS             ; Syncing timing
  ADD pending_tick, CL        ; Ticks count

  ; Mute / Unmute music theme
  CMP music_theme_active, 0
  JE @F
  CALL UPDATE_MUSIC_THEME     ; Update theme music
  @@:

  CALL HANDLE_KEYBOARD_INPUT  ; Input game_tick, Output AL = 0 (no key), AL = 1 (action), AL = 2 (quit game)

  CMP AL, 0                   ; Check if no key was pressed
  JE @gl_no_movement

  CMP AL, 2                   ; Check if quit game key was pressed
  JE @gl_exit_game

  CALL RENDER_CARACTER        ; Render the Mia character
  MOV pending_tick, 0         ; Reset pending ticks
  JMP @gl_get_next_key

@gl_no_movement:
  CMP pending_tick, 3         ; Less than 4 ticks?
  JL @gl_get_next_key         ; Yes, keep the debt and loop again
  MOV pending_tick, 0         ; Reset pending ticks
  JMP @gl_get_next_key

@gl_exit_game:
  CALL MUTE_SPEAKER           ; Stop background music
  RESTORE_REGS
  RET
GAME_LOOP ENDP

END MAIN
