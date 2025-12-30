; --- Draw caracter ---
DRAW_CARACTER PROC
  SAVE_REGS
  CLD                             ; Clear direction flag

  MOV SI, curr_sprite             ; Load main caracter current sprite
  CALC_VGA_POSITION pos_x, pos_y  ; Calculate VGA position in DI

  MOV DX, CARACTER_HEIGHT         ; Height of the sprite (number of lines)

  ; --- draw the caracter loop
  c_draw_line:
    MOV CX, CARACTER_WIDTH
    PUSH DI                       ; Save current line start
    c_draw_pixel:
      LODSB                       ; Load pixel from SI in AL then SI++
      OR AL, AL                   ; Check if pixel color is 0 (transparent)
      JZ c_skip_pixel             ; If pixel is transparent, skip pixel
      MOV ES:[DI], AL             ; Draw pixel
      c_skip_pixel:
        INC DI                    ; Next pixel on sreen
        LOOP c_draw_pixel

      POP DI                      ; Restore line start
      ADD DI, SCREEN_WIDTH        ; Move DI to the next line
      DEC DX
      JNZ c_draw_line             ; Draw next line if caracter is not entirely draw

  RESTORE_REGS
  RET
DRAW_CARACTER ENDP

; Save caracter background
SAVE_CARACTER_BG PROC
  SAVE_REGS
  CLD

  CALC_VGA_POSITION pos_x, pos_y    ; Calculate VGA position in DI
  MOV SI, OFFSET bg_sprite          ; Background buffer

  MOV DX, CARACTER_HEIGHT           ; Number of lines to read

  s_read_line:
    MOV CX, CARACTER_WIDTH          ; Number of pixels to read
    PUSH DI
    s_read_pixel:
      MOV AL, ES:[DI]               ; TODO: optimi with SEGS & REP MOVSB
      MOV [SI], AL                  ; Save pixel in background buffer
      INC DI                        ; Next pixel
      INC SI                        ; Next pixel in background buffer
      LOOP s_read_pixel

    POP DI
    ADD DI, SCREEN_WIDTH            ; Next line
    DEC DX                          ; Decrement line counter
    JNZ s_read_line

  RESTORE_REGS
  RET
SAVE_CARACTER_BG ENDP

; Restore caracter background
RESTORE_CARACTER_BG PROC
  SAVE_REGS
  CLD

  CALC_VGA_POSITION pos_x, pos_y  ; Calculate VGA position in DI
  MOV SI, OFFSET bg_sprite        ; Background buffer

  MOV DX, CARACTER_HEIGHT         ; Number of lines to draw

r_restore_line:
  PUSH DI
  MOV CX, CARACTER_WIDTH          ; Number of pixels to draw

  REP MOVSB                       ; Copy line from buffer to screen (TODO: better comments)

  POP DI
  ADD DI, SCREEN_WIDTH            ; Next line
  DEC DX                          ; Decrement line counter
  JNZ r_restore_line

  RESTORE_REGS
  RET
RESTORE_CARACTER_BG ENDP
