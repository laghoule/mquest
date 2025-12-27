TITLE Animations of a pixel art caractere
.MODEL SMALL
.8086
.STACK 100h

; Useful macros
INCLUDE defs/macros.inc

.DATA
  INCLUDE defs/consts.inc ; constants
  INCLUDE assets/anim.inc ; animations sprite data

  m_pos_x DW 150 ; Main caracter initial X position
  m_pos_y DW 90  ; Main caracter initial Y position

  m_curr_sprite   DW OFFSET g_down_0    ; Front / down animation for starting point (TODO: will be used when unifying DRAW_GIRL)
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
  MOV AX, 0003h
  INT 10h

  ; Return to dos
  MOV AX, 4C00h
  INT 21h

MAIN ENDP

; --- Game loop ---
GAME_LOOP PROC
  SAVE_REGS

next_key:
  ; Get keyboard input
  ; Wait for a key press, this is a blocking call
  ; TODO: Implement the 01h interrupt (non-blocking)
  MOV AH, 00h
  INT 16h

  ; -- Key handling --
  ; https://www.fountainware.com/EXPL/bios_key_codes.htm
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
  JMP next_key

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
  MOV m_curr_sprite, OFFSET mright_0  ; If the animation state is 0, draw the first sprite
  JMP draw_r_caracter

m_r_anim_state_1:
  MOV m_curr_sprite, OFFSET m_right_1  ; If the animation state is 1, draw the second sprite
  JMP draw_r_caracter

draw_r_caracter:
  CALL DRAW_CARACTER     ; Draw the caracter on the screen
  JMP NEXT_KEY           ; Wait for next key press

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
  JMP NEXT_KEY           ; Wait for next key press

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
  JMP NEXT_KEY           ; Wait for next key press

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
  JMP NEXT_KEY           ; Wait for next key press

exit_game:
  RESTORE_REGS
  RET
GAME_LOOP ENDP

; --- Erase caracter ---
ERASE_CARACTER PROC
  SAVE_REGS
  CLD                     ; Clear direction flag

  MOV AX, m_pos_y         ; Calcul DI = (m_pos_y * 320) + m_pos_x
  MOV BX, SCREEN_WIDTH
  MUL BX                  ; TODO: This can be optimized (costly on 8086)
  ADD AX, m_pos_x
  MOV DI, AX              ; First pixel of the sprite to display on screen

  MOV AL, 00h             ; Black color (screen background)
  MOV DX, CARACTER_HEIGHT

e_erase_line:
  PUSH DI                 ; Save DI (begin of line)
  MOV  CX, CARACTER_WIDTH ; Width of the sprite
  REP  STOSB              ; Fill the line with black pixels (MOV ES:DI AL | INC DI | DEC CX)
  POP  DI                 ; Restore DI (begin of line)

  ADD DI, SCREEN_WIDTH    ; Move to next line
  DEC DX                  ; Decrement height

  JNZ e_erase_line        ; If height > 0, draw next line

  RESTORE_REGS
  RET
ERASE_CARACTER ENDP

; --- Draw caracter ---
DRAW_CARACTER PROC
  SAVE_REGS
  CLD                         ; Clear direction flag

  MOV SI, m_curr_sprite       ; Load main caracter current sprite

  MOV AX, m_pos_y             ; Calcul DI = (m_pos_y * 320) + m_pos_x
  MOV BX, SCREEN_WIDTH
  MUL BX
  ADD AX, m_pos_x
  MOV DI, AX                  ; Current line start

  MOV DX, CARACTER_HEIGHT

  ; --- draw the caracter loop
  c_draw_line:
    MOV CX, CARACTER_WIDTH
    PUSH DI                   ; Save current line start
    c_draw_pixel:
      LODSB                   ; Load pixel from SI in AL then SI++
      OR AL, AL               ; Check if pixel color is 0 (transparent)
      JZ c_skip_pixel         ; If pixel is transparent, skip pixel
      MOV ES:[DI], AL         ; Draw pixel
      c_skip_pixel:
        INC DI                ; Next pixel on sreen
        LOOP c_draw_pixel

      POP DI                  ; Restore line start
      ADD DI, SCREEN_WIDTH    ; Move DI to the next line
      DEC DX
      JNZ c_draw_line         ; Draw next line if caracter is not entirely draw

  RESTORE_REGS
  RET
DRAW_CARACTER ENDP

END MAIN
