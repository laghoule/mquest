TITLE Animations of a pixel art girl
.MODEL SMALL
.8086
.STACK 100h

; Useful macros
INCLUDE defs/macros.inc

.DATA
  INCLUDE defs/consts.inc ; constants
  INCLUDE assets/anim.inc ; animations sprite data

  g_pos_x DW 150
  g_pos_y DW 90

  curr_sprite     DW OFFSET g_down_0    ; Front / down animation for starting point (TODO: will be used when unifying DRAW_GIRL)
  g_r_anim_state  DB 0                  ; Girl right animation state (0, 1, 2 state)
  g_l_anim_state  DB 0                  ; Girl left animation state (0, 1, 2 state)
  g_u_anim_state  DB 0                  ; Girl up animation state (0, 1, 2 state)
  g_d_anim_state  DB 0                  ; Girl down animation state (0, 1, 2 state)

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

; --- Girl move to right ---
right_direction:
  CALL ERASE_GIRL        ; Erase the girl from the screen
  INC g_pos_x            ; Move the girl one pixel to the right
  INC g_r_anim_state     ; Increment animation state
  CMP g_r_anim_state, 3  ; If animation state is greater than 3, reset it to 0
  JNE @F                 ; FastForward if animation state is not 3
  MOV g_r_anim_state, 0
@@:
  CALL DRAW_GIRL_RIGHT   ; Draw the girl on the screen
  JMP NEXT_KEY           ; Wait for next key press

; --- Girl move to left ---
left_direction:
  CALL ERASE_GIRL        ; Erase the girl from the screen
  DEC g_pos_x            ; Move the girl one pixel to the left
  INC g_l_anim_state     ; Increment animation state
  CMP g_l_anim_state, 3  ; If animation state is greater than 3, reset it to 0
  JNE @F                 ; FastForward if animation state is not 3
  MOV g_l_anim_state, 0
@@:
  CALL DRAW_GIRL_LEFT    ; Draw the girl on the screen
  JMP next_key

up_direction:
  CALL ERASE_GIRL        ; Erase the girl from the screen
  DEC g_pos_y            ; Move the girl one pixel up
  INC g_u_anim_state     ; Increment animation state
  CMP g_u_anim_state, 3  ; If animation state is greater than 3, reset it to 0
  JNE @F
  MOV g_u_anim_state, 0
@@:
  CALL DRAW_GIRL_UP      ; Draw the girl on the screen
  JMP next_key

down_direction:
  CALL ERASE_GIRL        ; Erase the girl from the screen
  INC g_pos_y            ; Move the girl one pixel down
  INC g_d_anim_state     ; Increment animation state
  CMP g_d_anim_state, 3  ; If animation state is greater than 3, reset it to 0
  JNE @F
  MOV g_d_anim_state, 0
@@:
  CALL DRAW_GIRL_DOWN    ; Draw the girl on the screen
  JMP next_key

exit_game:
  RESTORE_REGS
  RET
GAME_LOOP ENDP

; --- Erase girl ---
ERASE_GIRL PROC
  SAVE_REGS
  CLD ; Clear direction flag, ensure right direction for STOBS operation

  MOV AX, g_pos_y       ; Calcul DI = (pos_y * 320) + pos_x
  MOV BX, SCREEN_WIDTH
  MUL BX                ; TODO: This can be optimized (costly on 8086)
  ADD AX, g_pos_x
  MOV DI, AX            ; First pixel of the sprite to display on screen

  MOV AL, 00h           ; Black color (screen background)
  MOV DX, GIRL_HEIGHT

e_erase_line:
  PUSH DI                ; Save DI (begin of line)
  MOV  CX, GIRL_WIDTH    ; Width of the sprite
  REP  STOSB             ; Fill the line with black pixels (MOV ES:DI AL | INC DI | DEC CX)
  POP  DI                ; Restore DI (begin of line)

  ADD DI, SCREEN_WIDTH   ; Move to next line
  DEC DX                 ; Decrement height

  JNZ e_erase_line       ; If height > 0, draw next line

  RESTORE_REGS
  RET
ERASE_GIRL ENDP

; --- Draw girl in right direction ---
DRAW_GIRL_RIGHT PROC
  SAVE_REGS
  CLD                           ; Clear direction flag

  CMP g_r_anim_state, 0         ; Check if animation state is 0
  JE r_load_state_0

  CMP g_r_anim_state, 1         ; Check if animation state is 1
  JE r_load_state_1

  MOV SI,OFFSET g_right_2
  JMP r_start_draw

r_load_state_0:                 ; Load animation state 0
  MOV SI, OFFSET g_right_0
  JMP r_start_draw

r_load_state_1:                 ; Load animation state 1
  MOV SI, OFFSET g_right_1

r_start_draw:           ; Start drawing the sprite
  MOV AX, g_pos_y       ; Calcul DI = (g_pos_y * 320) + g_pos_x
  MOV BX, SCREEN_WIDTH
  MUL BX                ; TODO: This can be optimized (costly on 8086)
  ADD AX, g_pos_x
  MOV DI, AX            ; First pixel of the sprite to display on screen

  MOV DX, GIRL_HEIGHT  ; For counting lines

r_draw_line:
  PUSH DI              ; Save the pixel address
  MOV CX, GIRL_WIDTH   ; Counter for lines looping

r_draw_pixel:
  LODSB                ; Load byte in AL, and SI++
  OR AL, AL            ; Check if pixel is transparent (black)
  JZ r_skip_pixel      ; If transparent, draw the next pixel
  MOV ES:[DI], AL      ; Draw pixel on screen

r_skip_pixel:
  INC DI               ; Increment the pixel address
  LOOP r_draw_pixel

  POP DI               ; Restore the pixel address
  ADD DI, SCREEN_WIDTH ; Move to next line
  DEC DX               ; Decrement line counter
  JNZ r_draw_line      ; If height > 0, draw next line

  RESTORE_REGS
  RET
DRAW_GIRL_RIGHT ENDP

; --- Draw girl in the left direction ---
DRAW_GIRL_LEFT PROC
  SAVE_REGS
  CLD ; Clear Direction Flag

  CMP g_l_anim_state, 0    ; Check if animation state is 0
  JE l_load_state_0

  CMP g_l_anim_state, 1    ; Check if animation state is 1
  JE l_load_state_1

  MOV SI, OFFSET g_left_2  ; Load animation state 2
  JMP l_start_draw

l_load_state_0:
  MOV SI, OFFSET g_left_0  ; Load animation state 0
  JMP l_start_draw

l_load_state_1:
  MOV SI, OFFSET g_left_1  ; Load animation state 1

l_start_draw:             ; Start drawing the sprite
  MOV AX, g_pos_y         ; Calcul DI = (g_pos_y * 320) + g_pos_x
  MOV BX, SCREEN_WIDTH
  MUL BX                  ; TODO: This can be optimized (costly on 8086)
  ADD AX, g_pos_x
  MOV DI, AX              ; First pixel of the sprite to display on screen

  MOV DX, GIRL_HEIGHT     ; For counting lines

l_draw_line:
  PUSH DI                 ; Save the pixel address
  MOV CX, GIRL_WIDTH      ; For counting pixels

  l_draw_pixel:
    LODSB                   ; Load byte in AL, and SI++
    OR AL, AL               ; Check if pixel is transparent
    JZ l_skip_pixel         ; If transparent, skip pixel
    MOV ES:[DI], AL         ; Else, draw pixel on screen

  l_skip_pixel:
    INC DI                  ; Increment the pixel address
    LOOP l_draw_pixel

    POP DI                  ; Restore the pixel address
    ADD DI, SCREEN_WIDTH    ; Move to next line
    DEC DX                  ; Decrement line counter
    JNZ l_draw_line         ; If height > 0, draw next line

  RESTORE_REGS
  RET
DRAW_GIRL_LEFT ENDP

; --- Draw girl in up direction ---
DRAW_GIRL_UP PROC
  SAVE_REGS
  CLD ; Clear Direction Flag

  CMP g_u_anim_state, 0   ; Check if animation state is 0
  JE u_load_state_0

  CMP g_u_anim_state, 1   ; Check if animation state is 1
  JE u_load_state_1

  MOV SI, OFFSET g_up_2   ; Load animation state 2
  JMP u_start_draw

u_load_state_0:
  MOV SI, OFFSET g_up_0   ; Load animation state 0
  JMP u_start_draw

u_load_state_1:
  MOV SI, OFFSET g_up_1   ; Load animation state 1

u_start_draw:
  MOV AX, g_pos_y         ; Calcul DI = (g_pos_y * 320) + g_pos_x
  MOV BX, SCREEN_WIDTH
  MUL BX                  ; TODO: This can be optimized (costly on 8086)
  ADD AX, g_pos_x
  MOV DI, AX              ; First pixel of the sprite to display on screen

  MOV DX, GIRL_HEIGHT     ; Lines counter

u_draw_line:
  PUSH DI                 ; Save the pixel address
  MOV CX, GIRL_WIDTH      ; For counting pixels

  u_draw_pixel:
    LODSB                 ; Load byte in AL and SI++
    OR AL, AL             ; Check if pixel is transparent
    JZ u_skip_pixel       ; If transparent, skip pixel
    MOV ES:[DI], AL       ; Else, draw pixel

  u_skip_pixel:
    INC DI                ; Inc the pixel address
    LOOP u_draw_pixel

    POP DI                ; Restore the pixel address
    ADD DI, SCREEN_WIDTH  ; Move to the next line
    DEC DX                ; Decrement lines counter
    JNZ u_draw_line       ; If height > 0, draw next line

  RESTORE_REGS
  RET
DRAW_GIRL_UP ENDP

; --- Draw girl in down direction ---
DRAW_GIRL_DOWN PROC
  SAVE_REGS
  CLD                       ; Clear direction flag

  CMP g_d_anim_state, 0     ; Check animation state is 0
  JE d_load_state_0

  CMP g_d_anim_state, 1     ; Check animation state is 1
  JE d_load_state_1

  MOV SI, OFFSET g_down_2   ; Load animation state 2
  JMP d_start_draw

d_load_state_0:
  MOV SI, OFFSET g_down_0   ; Load animation state 0
  JMP d_start_draw

d_load_state_1:
  MOV SI, OFFSET g_down_1   ; Load animation state 1
  JMP d_start_draw


d_start_draw:
  MOV AX, g_pos_y           ; Calcul DI = (g_pos_y * 320) + g_pos_x
  MOV BX, SCREEN_WIDTH
  MUL BX                    ; TODO: This can be optimized (costly on 8086)
  ADD AX, g_pos_x
  MOV DI, AX                ; First pixel of the sprite to display on screen

  MOV DX, GIRL_HEIGHT       ; Lines counter

d_draw_line:
  MOV CX, GIRL_WIDTH
  PUSH DI

  d_draw_pixel:
    LODSB                   ; Load byte in AL and SI++
    OR AL, AL               ; Check if pixel is transparent
    JZ d_skip_pixel         ; If transparent, skip pixel
    MOV ES:[DI], AL         ; Else, draw pixel

    d_skip_pixel:
      INC DI                ; Inc the pixel address
      LOOP d_draw_pixel

    POP DI                  ; Restore the pixel adress
    ADD DI, SCREEN_WIDTH    ; Move to the next line
    DEC DX                  ; Decrement the lines counter
    JNZ d_draw_line         ; If height > 0, draw next line

  RESTORE_REGS
  RET
DRAW_GIRL_DOWN ENDP

END MAIN
