; --- Erase caracter ---
ERASE_CARACTER PROC
  SAVE_REGS
  CLD                                     ; Clear direction flag

  CALC_VGA_POSITION mia_pos_x, mia_pos_y  ; Calculate the position in VGA memory

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
  CLD                                     ; Clear direction flag

  MOV SI, mia_curr_sprite                 ; Load main caracter current sprite
  CALC_VGA_POSITION mia_pos_x, mia_pos_y  ; Calculate VGA position in DI

  MOV DX, CARACTER_HEIGHT     ; Height of the sprite (number of lines)

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
