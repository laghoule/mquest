;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

TITLE Mia's Herbal Quest
.MODEL SMALL
.8086
.STACK 100h

INCLUDE defs/macros.inc ; Macros
INCLUDE defs/consts.inc ; Constants

.DATA

  INCLUDE assets/carac/mia.inc       ; Mia animations sprite data

  INCLUDE assets/tiles/grass.inc     ; Grass tiles data
  INCLUDE assets/tiles/flowers.inc   ; Items tiles data
  INCLUDE assets/tiles/tables.inc    ; Tiles table data
  INCLUDE assets/tiles/rock.inc      ; Rock tiles data

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

  ; Mia sprite info
  mia_pos_x DW 150        ; Mia starting x position
  mia_pos_y DW 90         ; Mia starting y position

  ; For smooth animation
  mia_speed DB 128        ; Speed (128 = 0.5px/frame)
  game_tick DB 0          ; Global metronome for smooth animation (TODO: name)
  anim_time DB 0          ; Animation timer (TODO: name)

  mia_bg_sprite     DB 272 DUP(0)         ; Mia background sprite
  mia_curr_sprite   DW OFFSET mia_down_0  ; Front / down animation for starting point
  mia_r_anim_state  DB 0                  ; Mia right animation state (0, 1, 2 state)
  mia_l_anim_state  DB 0                  ; Mia left animation state (0, 1, 2 state)
  mia_u_anim_state  DB 0                  ; Mia up animation state (0, 1, 2 state)
  mia_d_anim_state  DB 0                  ; Mia down animation state (0, 1, 2 state)

.CODE
INCLUDE timer.asm         ; Timer functions
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
  CALL SAVE_CARACTER_BG
  CALL DRAW_CARACTER

  ; --- Game loop ---
  CALL GAME_LOOP

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

get_next_key:
  WAIT_VSYNC        ; Wait for vertical syncronization to avoid flickering

  MOV AH, 01h       ; Read keyboard input buffer
  INT 16h
  JZ no_key_pressed

  MOV AH, 00h       ; Read key pressed on keyboard
  INT 16h

  ; -- Key handling --
  CMP AH, KEY_ESC
  JE exit_game

  CMP AH, KEY_RIGHT
  JE right_direction

  CMP AH, KEY_LEFT
  JE left_direction

  CMP AH, KEY_UP
  JE up_direction

  CMP AH, KEY_DOWN
  JE down_direction

  ; Other key press, ignore
  JMP get_next_key

  no_key_pressed:
    ;CALL RENDER_CARACTER
    JMP get_next_key

; ---------------------------------------
; --- Restore -> Move -> Save -> Draw ---
; ---------------------------------------

right_direction:
  CALL MOVE_MIA_RIGHT
  CALL RENDER_CARACTER
  JMP no_key_pressed

left_direction:
  CALL MOVE_MIA_LEFT
  CALL RENDER_CARACTER
  JMP no_key_pressed

up_direction:
  CALL MOVE_MIA_UP
  CALL RENDER_CARACTER
  JMP no_key_pressed

down_direction:
  CALL MOVE_MIA_DOWN
  CALL RENDER_CARACTER
  JMP no_key_pressed

exit_game:
  RESTORE_REGS
  RET
GAME_LOOP ENDP

END MAIN
