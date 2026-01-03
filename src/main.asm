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

  mia_bg_sprite     DB 272 DUP(0)         ; Mia background sprite
  mia_curr_sprite   DW OFFSET mia_down_0  ; Front / down animation for starting point
  mia_r_anim_state  DB 0                  ; Mia right animation state (0, 1, 2 state)
  mia_l_anim_state  DB 0                  ; Mia left animation state (0, 1, 2 state)
  mia_u_anim_state  DB 0                  ; Mia up animation state (0, 1, 2 state)
  mia_d_anim_state  DB 0                  ; Mia down animation state (0, 1, 2 state)

.CODE
INCLUDE car_draw.asm            ; Caracters drawing functions
INCLUDE til_draw.asm            ; Tiles drawing functions
INCLUDE map_draw.asm            ; Maps drawing functions

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

read_key_pressed:
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
    ; Place older for future use
    JMP get_next_key

; --- Mia move to right ---
right_direction:
  ; Restore -> Move -> Save -> Draw
  CALL RESTORE_CARACTER_BG  ; Restore the background of the caracter

  INC mia_pos_x             ; Move the caracter to the right

  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_right
  MOV AL, mia_r_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_r_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

draw_r_caracter:
  PREPARE_MIA_DRAW        ; TODO: comment
  CALL SAVE_CARACTER_BG   ; Save the background of the caracter
  CALL DRAW_CARACTER      ; Draw the caracter on the screen
  JMP get_next_key        ; Wait for next key press

; --- Mia move to left ---
left_direction:
  ; Restore -> Move -> Save -> Draw
  CALL RESTORE_CARACTER_BG  ; Restore the background of the caracter

  DEC mia_pos_x             ; Move the caracter to the left

  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_left
  MOV AL, mia_l_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_l_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

draw_l_caracter:
  PREPARE_MIA_DRAW
  CALL SAVE_CARACTER_BG   ; Save the background behind the caracter
  CALL DRAW_CARACTER      ; Draw the caracter on the screen
  JMP get_next_key        ; Wait for next key press

; --- Mia move up ---
up_direction:
  ; Restore -> Move -> Save -> Draw
  CALL RESTORE_CARACTER_BG ; Restore the background behind the caracter

  DEC mia_pos_y           ; Move the caracter up

  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_up
  MOV AL, mia_u_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_u_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

draw_u_caracter:
  PREPARE_MIA_DRAW
  CALL SAVE_CARACTER_BG    ; Save the background of the caracter
  CALL DRAW_CARACTER       ; Draw the caracter on the screen
  JMP get_next_key         ; Wait for next key press

; --- Mia move down ---
down_direction:
  CALL RESTORE_CARACTER_BG

  INC mia_pos_y            ; Move the caracter down

  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_down
  MOV AL, mia_d_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_d_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

draw_d_caracter:
  PREPARE_MIA_DRAW
  CALL SAVE_CARACTER_BG
  CALL DRAW_CARACTER     ; Draw the sprite
  JMP get_next_key       ; Wait for next key press

exit_game:
  RESTORE_REGS
  RET
GAME_LOOP ENDP

END MAIN
