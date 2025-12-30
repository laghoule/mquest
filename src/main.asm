;  Copyright (C) 2025 Pascal Gauthier
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

  INCLUDE assets/mia.inc ; Mia animations sprite data

  ; Generic sprite info
  curr_sprite DW ?        ; Current sprite to draw
  bg_sprite DB 272 DUP(0) ; Background sprite
  pos_x DW ?              ; Sprite x position
  pos_y DW ?              ; Sprite y position

  ; Mia sprite info
  mia_pos_x DW 150        ; Mia starting x position
  mia_pos_y DW 90         ; Mia starting y position

  mia_bg_sprite     DB 272 DUP(0)         ; Mia background sprite
  mia_curr_sprite   DW OFFSET mia_down_0  ; Front / down animation for starting point
  mia_r_anim_state  DB 0                  ; Main caracter right animation state (0, 1, 2 state)
  mia_l_anim_state  DB 0                  ; Main caracter left animation state (0, 1, 2 state)
  mia_u_anim_state  DB 0                  ; Main caracter up animation state (0, 1, 2 state)
  mia_d_anim_state  DB 0                  ; Main caracter down animation state (0, 1, 2 state)

.CODE
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
  CALL DRAW_TMP_BG
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

INCLUDE draw.asm        ; Draw functions
INCLUDE bground.asm  ; Background functions

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
  INC mia_r_anim_state      ; Increment the animation state

  CMP mia_r_anim_state, 3   ; If the animation state is 3, reset it to 0 (3 states)
  JNE @F
  MOV mia_r_anim_state, 0

@@:
  CMP mia_r_anim_state, 0
  JE mia_r_anim_state_0

  CMP mia_r_anim_state, 1
  JE mia_r_anim_state_1

  MOV mia_curr_sprite, OFFSET mia_right_2  ; If the animation state is 2, draw the third sprite
  JMP draw_r_caracter

mia_r_anim_state_0:
  MOV mia_curr_sprite, OFFSET mia_right_0  ; If the animation state is 0, draw the first sprite
  JMP draw_r_caracter

mia_r_anim_state_1:
  MOV mia_curr_sprite, OFFSET mia_right_1  ; If the animation state is 1, draw the second sprite
  JMP draw_r_caracter

draw_r_caracter:
  PREPARE_MIA_DRAW
  CALL SAVE_CARACTER_BG   ; Save the background of the caracter
  CALL DRAW_CARACTER      ; Draw the caracter on the screen
  JMP get_next_key        ; Wait for next key press

; --- Mia move to left ---
left_direction:
  ; Restore -> Move -> Save -> Draw
  CALL RESTORE_CARACTER_BG  ; Restore the background of the caracter

  DEC mia_pos_x             ; Move the caracter to the left
  INC mia_l_anim_state      ; Increment the animation state

  CMP mia_l_anim_state, 3   ; If the animation state is 3, reset it to 0 (3 states)
  JNE @F
  MOV mia_l_anim_state, 0

@@:
  CMP mia_l_anim_state, 0
  JE mia_l_anim_state_0

  CMP mia_l_anim_state, 1
  JE mia_l_anim_state_1

  MOV mia_curr_sprite, OFFSET mia_left_2  ; If the animation state is 2, draw the third sprite
  JMP draw_l_caracter

mia_l_anim_state_0:
  MOV mia_curr_sprite, OFFSET mia_left_0  ; If the animation state is 0, draw the first sprite
  JMP draw_l_caracter

mia_l_anim_state_1:
  MOV mia_curr_sprite, OFFSET mia_left_1  ; If the animation state is 1, draw the second sprite
  JMP draw_l_caracter

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
  INC mia_u_anim_state    ; Increment the animation state

  CMP mia_u_anim_state, 3 ; If the animation state is 3, reset it to 0
  JNE @F
  MOV mia_u_anim_state, 0

@@:
  CMP mia_u_anim_state, 0
  JE mia_u_anim_state_0

  CMP mia_u_anim_state, 1
  JE mia_u_anim_state_1

  MOV mia_curr_sprite, OFFSET mia_up_2  ; If the animation state is 2, draw the third sprite
  JMP draw_u_caracter

mia_u_anim_state_0:
  MOV mia_curr_sprite, OFFSET mia_up_0  ; If the animation state is 0, draw the first sprite
  JMP draw_u_caracter

mia_u_anim_state_1:
  MOV mia_curr_sprite, OFFSET mia_up_1  ; If the animation state is 1, draw the second sprite
  JMP draw_u_caracter

draw_u_caracter:
  PREPARE_MIA_DRAW
  CALL SAVE_CARACTER_BG    ; Save the background of the caracter
  CALL DRAW_CARACTER       ; Draw the caracter on the screen
  JMP get_next_key         ; Wait for next key press

; --- Mia move down ---
down_direction:
  CALL RESTORE_CARACTER_BG

  INC mia_pos_y            ; Move the caracter down
  INC mia_d_anim_state     ; Increment the animation state

  CMP mia_d_anim_state, 3  ; If the animation state is 3, reset it to 0
  JNE @F
  MOV mia_d_anim_state, 0

@@:
  CMP mia_d_anim_state, 0
  JE mia_d_anim_state_0

  CMP mia_d_anim_state, 1
  JE mia_d_anim_state_1

  MOV mia_curr_sprite, OFFSET mia_down_2  ; If the animation state is 2, draw the third sprite
  JMP draw_d_caracter

mia_d_anim_state_0:
  MOV mia_curr_sprite, OFFSET mia_down_0  ; If the animation state is 0, draw the first sprite
  JMP draw_d_caracter

mia_d_anim_state_1:
  MOV mia_curr_sprite, OFFSET mia_down_1  ; If the animation state is 1, draw the second sprite
  JMP draw_d_caracter

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
