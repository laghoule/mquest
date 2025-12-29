TITLE Mia's Herbal Quest
.MODEL SMALL
.8086
.STACK 100h

INCLUDE defs/macros.inc ; Macros
INCLUDE defs/consts.inc ; Constants

.DATA

  INCLUDE assets/mia.inc ; Mia animations sprite data

  m_pos_x DW 150 ; Main caracter initial X position
  m_pos_y DW 90  ; Main caracter initial Y position

  m_curr_sprite   DW OFFSET m_down_0    ; Front / down animation for starting point
  m_r_anim_state  DB 0                  ; Main caracter right animation state (0, 1, 2 state)
  m_l_anim_state  DB 0                  ; Main caracter left animation state (0, 1, 2 state)
  m_u_anim_state  DB 0                  ; Main caracter up animation state (0, 1, 2 state)
  m_d_anim_state  DB 0                  ; Main caracter down animation state (0, 1, 2 state)

.CODE
MAIN PROC
  ; Initialize data segment
  MOV AX, @DATA
  MOV DS, AX

  ; Initialize mode 13h with bios call / VGA
  MOV AX, 13h
  INT 10h
  MOV AX, VGA_ADDR
  MOV ES, AX

  CALL GAME_LOOP

  ; Return to text mode
  MOV AX, TEXT_MODE
  INT 10h

  ; Return to dos
  MOV AX, 4C00h
  INT 21h

MAIN ENDP

INCLUDE draw.asm    ; Draw functions

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
    CALL DRAW_CARACTER
    JMP get_next_key

; --- Main caracter move to right ---
right_direction:
  CALL ERASE_CARACTER       ; Erase the caracter from the screen

  INC m_pos_x               ; Move the caracter to the right
  INC m_r_anim_state        ; Increment the animation state

  CMP m_r_anim_state, 3     ; If the animation state is 3, reset it to 0 (3 states)
  JNE @F
  MOV m_r_anim_state, 0

@@:
  CMP m_r_anim_state, 0
  JE m_r_anim_state_0

  CMP m_r_anim_state, 1
  JE m_r_anim_state_1

  MOV m_curr_sprite, OFFSET m_right_2  ; If the animation state is 2, draw the third sprite
  JMP draw_r_caracter

m_r_anim_state_0:
  MOV m_curr_sprite, OFFSET m_right_0  ; If the animation state is 0, draw the first sprite
  JMP draw_r_caracter

m_r_anim_state_1:
  MOV m_curr_sprite, OFFSET m_right_1  ; If the animation state is 1, draw the second sprite
  JMP draw_r_caracter

draw_r_caracter:
  CALL DRAW_CARACTER     ; Draw the caracter on the screen
  JMP get_next_key           ; Wait for next key press

; --- Main caracter move to left ---
left_direction:
  CALL ERASE_CARACTER    ; Erase the caracter from the screen

  DEC m_pos_x            ; Move the caracter to the left
  INC m_l_anim_state     ; Increment the animation state

  CMP m_l_anim_state, 3  ; If the animation state is 3, reset it to 0 (3 states)
  JNE @F
  MOV m_l_anim_state, 0

@@:
  CMP m_l_anim_state, 0
  JE m_l_anim_state_0

  CMP m_l_anim_state, 1
  JE m_l_anim_state_1

  MOV m_curr_sprite, OFFSET m_left_2  ; If the animation state is 2, draw the third sprite
  JMP draw_l_caracter

m_l_anim_state_0:
  MOV m_curr_sprite, OFFSET m_left_0  ; If the animation state is 0, draw the first sprite
  JMP draw_l_caracter

m_l_anim_state_1:
  MOV m_curr_sprite, OFFSET m_left_1  ; If the animation state is 1, draw the second sprite
  JMP draw_l_caracter

draw_l_caracter:
  CALL DRAW_CARACTER     ; Draw the caracter on the screen
  JMP get_next_key           ; Wait for next key press

; --- Main caracter move up ---
up_direction:
  CALL ERASE_CARACTER    ; Erase the caracter from the screen

  DEC m_pos_y            ; Move the caracter up
  INC m_u_anim_state     ; Increment the animation state

  CMP m_u_anim_state, 3  ; If the animation state is 3, reset it to 0
  JNE @F
  MOV m_u_anim_state, 0

@@:
  CMP m_u_anim_state, 0
  JE m_u_anim_state_0

  CMP m_u_anim_state, 1
  JE m_u_anim_state_1

  MOV m_curr_sprite, OFFSET m_up_2  ; If the animation state is 2, draw the third sprite
  JMP draw_u_caracter

m_u_anim_state_0:
  MOV m_curr_sprite, OFFSET m_up_0  ; If the animation state is 0, draw the first sprite
  JMP draw_u_caracter

m_u_anim_state_1:
  MOV m_curr_sprite, OFFSET m_up_1  ; If the animation state is 1, draw the second sprite
  JMP draw_u_caracter

draw_u_caracter:
  CALL DRAW_CARACTER     ; Draw the caracter on the screen
  JMP get_next_key           ; Wait for next key press

; --- Main caracter move down ---
down_direction:
  CALL ERASE_CARACTER    ; Erase the caracter from the screen

  INC m_pos_y            ; Move the caracter down
  INC m_d_anim_state     ; Increment the animation state

  CMP m_d_anim_state, 3  ; If the animation state is 3, reset it to 0
  JNE @F
  MOV m_d_anim_state, 0

@@:
  CMP m_d_anim_state, 0
  JE m_d_anim_state_0

  CMP m_d_anim_state, 1
  JE m_d_anim_state_1

  MOV m_curr_sprite, OFFSET m_down_2  ; If the animation state is 2, draw the third sprite
  JMP draw_d_caracter

m_d_anim_state_0:
  MOV m_curr_sprite, OFFSET m_down_0  ; If the animation state is 0, draw the first sprite
  JMP draw_d_caracter

m_d_anim_state_1:
  MOV m_curr_sprite, OFFSET m_down_1  ; If the animation state is 1, draw the second sprite
  JMP draw_d_caracter

draw_d_caracter:
  CALL DRAW_CARACTER     ; Draw the sprite
  JMP get_next_key           ; Wait for next key press

exit_game:
  RESTORE_REGS
  RET
GAME_LOOP ENDP

END MAIN