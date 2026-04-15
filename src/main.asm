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

; --- Constants ---
INCLUDE defs/sys/consts.inc              ; System constants
INCLUDE defs/chars/consts.inc            ; Character constants
INCLUDE defs/game/consts.inc             ; Game constants
INCLUDE defs/musics/consts.inc           ; Musics constants

.DATA
  ; --- game ---
  INCLUDE defs/game/types.inc            ; Game types
  INCLUDE defs/game/assets.inc           ; Game assets
  INCLUDE defs/game/map-refs.inc         ; Map references
  INCLUDE defs/game/map-scne.inc        ; Map scene data

  ; --- Musics ---
  INCLUDE defs/musics/themes.inc         ; Music variables and songs

  ; --- Characters ---
  INCLUDE defs/chars/types.inc           ; Characters types definitions
  INCLUDE defs/chars/hitbox.inc          ; Characters hitbox data
  INCLUDE defs/chars/mia.inc             ; Mia animations sprite data
  INCLUDE defs/chars/grandma.inc         ; Grandma animations sprite data
  INCLUDE defs/chars/sprites.inc         ; Characters sprites tables and data

  ; --- Palettes ---
  INCLUDE defs/gfx/pals/pal.inc          ; Palette data

  ; --- Scenes ---
  INCLUDE defs/gfx/scene/scene.inc       ; Scene data

  ; --- System ---
  INCLUDE defs/sys/speaker.inc           ; Speaker vars
  INCLUDE defs/sys/tick.inc              ; Tick data
  INCLUDE defs/sys/errors.inc            ; Error messages

  TX DW 0                                ; Temporary software register

.CODE
  INCLUDE game/assets.asm                ; Assets functions
  INCLUDE game/player.asm                ; Player functions
  INCLUDE game/collis.asm                ; Collision functions
  INCLUDE game/transit.asm               ; Scene transition functions
  INCLUDE sys/args.asm                   ; Command-line functions
  INCLUDE sys/print.asm                  ; Print functions
  INCLUDE sys/file.asm                   ; File functions
  INCLUDE sys/error.asm                  ; Error functions
  INCLUDE sys/string.asm                 ; String functions
  INCLUDE sys/vga.asm                    ; VGA functions
  INCLUDE sys/timer.asm                  ; Timer functions
  INCLUDE sys/speaker.asm                ; Speaker functions
  INCLUDE sys/input.asm                  ; Inputs functions
  INCLUDE gfx/char.asm                   ; Caracters drawing functions
  INCLUDE gfx/tile.asm                   ; Tiles drawing functions
  INCLUDE gfx/scene.asm                  ; Scene drawing functions

MAIN PROC
  ; ---Initialize segments---
  MOV AX, @DATA
  MOV DS, AX                          ; Set DS to data segment

  CALL PARSE_CMDLINE_ARGS             ; Process command-line arguments

  MOV AX, OFFSET assets_table         ; Load address of assets table into AX
  MOV CX, assets_count                ; Load the count of assets in CX for loop counter
  CALL LOAD_ASSETS                    ; Load all assets
  JC @m_exit                          ; If error, exit

  ; ---Initialize mode 13h with bios call / VGA---
  MOV AX, 13h                         ; Mode 13h (320x200 256 colors)
  INT 10h                             ; Call BIOS interrupt to set video mode
  MOV AX, VGA_ADDR                    ; VGA address in AX
  MOV ES, AX                          ; Set ES to VGA address

  ; --- Loading custom VGA palette ---
  CALL LOAD_GAME_PALETTE

  ; --- Draw background and character ---
  MOV BX, OFFSET map_scene_0_0
  MOV AX, [BX].SCENE.sc_map_buffer_addr
  MOV map_buffer_addr, AX             ; map_buffer_addr is used to store the current scene buffer
  CALL DRAW_SCENE                     ; This is the background layer

  ; Grandma
  MOV AX, 1                           ; Charater index
  RENDER_CHARACTER                    ; Render character macro

  ; Mia
  XOR AX, AX                          ; Charater index
  RENDER_CHARACTER                    ; Render character macro

  CMP mute_flag, 1
  JE @m_no_music
  MOV SI, OFFSET greensleeves_data
  CALL INIT_MUSIC_THEME               ; Initialize music theme

@m_no_music:
  ; --- Game loop ---
  CALL INIT_TICKS                     ; Initialise the game_tick & pending_tick
  CALL GAME_LOOP                      ; Start the game loop

  ; ---Return to text mode---
  MOV AX, TEXT_MODE
  INT 10h

@m_exit:
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
  CMP mute_flag, 1
  JE @F
  CMP music_theme_active, 0
  JE @F
  CALL UPDATE_MUSIC_THEME     ; Update theme music
@@:

  CALL HANDLE_KEYBOARD_INPUT  ; Input game_tick, Output AL = 0 (no key), AL = 1 (action), AL = 2 (quit game)

  CMP AL, 0                   ; Check if no key was pressed
  JE @gl_no_movement

  CMP AL, 2                   ; Check if quit game key was pressed
  JE @gl_exit_game

  XOR AX, AX                  ; Mia character
  RENDER_CHARACTER            ; Render character macro

  CALL CHECK_SCENE_TRANSITION ; Check if scene transition is needed

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
