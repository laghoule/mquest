;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

TITLE Mia's Herbal Quest
.MODEL SMALL
.8086
.STACK 100h

; --- Macros ---
INCLUDE defs/macros/chars.inc            ; Character macros
INCLUDE defs/macros/sys.inc              ; System macros
INCLUDE defs/macros/vga.inc              ; VGA macros

; --- System ---
INCLUDE defs/sys/key.inc                 ; Keyboard
INCLUDE defs/sys/video.inc               ; Video

; --- Characters ---
INCLUDE defs/chars/chars.inc             ; Character

; --- Graphics ---
INCLUDE defs/gfx/maps.inc                ; Maps
INCLUDE defs/gfx/tiles.inc               ; Tiles

; --- Game ---
INCLUDE defs/game/collis.inc             ; Collision
INCLUDE defs/game/dir.inc                ; Directions

; --- Music ---
INCLUDE defs/musics/notes.inc            ; Frequencies (PIT Dividers)

.DATA
  ; --- Musics ---
  INCLUDE assets/musics/themes.inc       ; Music variables and songs

  ; --- Characters ---
  INCLUDE assets/gfx/chars/mia.inc       ; Mia animations sprite data

  ; --- Sprites ---
  INCLUDE assets/gfx/sprites.inc         ; Sprites data

  ; --- Palettes ---
  INCLUDE assets/gfx/pals/pal.inc        ; Palette data

  ; --- Tiles ---
  INCLUDE assets/gfx/tiles/tiles.inc     ; Tiles data and tables
  INCLUDE assets/gfx/tiles/grass.inc     ; Grass tiles data
  INCLUDE assets/gfx/tiles/flowers.inc   ; Items tiles data
  INCLUDE assets/gfx/tiles/rocks.inc     ; Rocks tiles data
  INCLUDE assets/gfx/tiles/plants.inc    ; Plants tiles data
  INCLUDE assets/gfx/tiles/objects.inc   ; Objects tiles data

  ; --- Maps ---
  INCLUDE assets/gfx/maps/map.inc        ; Map data
  INCLUDE assets/gfx/maps/map_o_0.inc    ; Map opaque
  INCLUDE assets/gfx/maps/map_t_0.inc    ; Map transparent

  ; --- System ---
  INCLUDE assets/sys/tick.inc            ; Tick data

  TX DW 0                                ; Temporary software register

.CODE
INCLUDE game/player.asm       ; Player functions
INCLUDE game/collis.asm       ; Collision functions
INCLUDE sys/vga.asm           ; VGA functions
INCLUDE sys/timer.asm         ; Timer functions
INCLUDE sys/speaker.asm       ; Speaker functions
INCLUDE sys/input.asm         ; Inputs functions
INCLUDE gfx/char.asm          ; Caracters drawing functions
INCLUDE gfx/tile.asm          ; Tiles drawing functions
INCLUDE gfx/map.asm           ; Maps drawing functions

MAIN PROC
  ; ---Initialize data segment---
  MOV AX, @DATA
  MOV DS, AX

  ; ---Initialize mode 13h with bios call / VGA---
  MOV AX, 13h
  INT 10h
  MOV AX, VGA_ADDR
  MOV ES, AX
  
  ;CALL LOAD_GAME_PALETTE

  ; --- Draw background and caracter ---
  MOV curr_map_opq, OFFSET map_opq_0
  CALL DRAW_OPAQUE_MAP                ; This is the base map layer

  MOV AX, OFFSET map_trns_0
  MOV curr_map_trns, AX
  CALL DRAW_TRANSPARENT_MAP           ; This is the transparent items on the map

  PREPARE_MIA_DRAW
  CALL SAVE_CARACTER_BG               ; Save the background of the character
  CALL DRAW_CARACTER                  ; Initial position of the character

  MOV SI, OFFSET greensleeves_data
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
