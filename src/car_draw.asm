;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;--------------------------------------------------------------------------------------
; UPDATE_CARACTER_ANIM_STATE
; Description : Update the right sprite of the character based on the animation state.
; Input       : curr_anim_state, curr_sprite_table
; Output      : curr_anim_state, curr_sprite
;--------------------------------------------------------------------------------------
UPDATE_CARACTER_ANIM_STATE PROC
  SAVE_REGS
  PUSH ES                       ; Save ES register

  ; -- we use the bios timer to loop the animation
  MOV AX, 40h                   ; Load the segment of the BIOS data area into AX
  MOV ES, AX                    ; Load the segment of the BIOS data area into ES
  MOV AL, ES:[6Ch]              ; Load the current time into AL

  ; --- via the timer stored in AL ---
  AND AL, 03h                   ; Mask the lower 2 bits of the time value
  CMP AL, 3                     ; Check if the animation frequency is reached
  JNE @F                        ; If not, skip the animation update
  XOR AL, AL                    ; Reset the animation state to 0
@@:
  MOV curr_anim_state, AL

  ; --- we get the index of the sprite in the table ---
  XOR AH, AH                    ; Clear AH
  SHL AX, 1                     ; Multiply by 2 to get the offset of the sprite in the table
  MOV BX, AX                    ; Move the offset into BX

  MOV SI, curr_sprite_table     ; Load the sprite table address into SI
  MOV AX, [SI + BX]             ; [SI + BX] is the offset of the sprite in the table
  MOV curr_sprite, AX

ucrs_exit:
  POP ES                        ; Restore ES register
  RESTORE_REGS
  RET
UPDATE_CARACTER_ANIM_STATE ENDP

;-------------------------------------------------
; RENDER_CARACTER
; Description: Render the caracter on the screen
; Input:       none
; Output:      none
; ------------------------------------------------
RENDER_CARACTER PROC
  PREPARE_MIA_DRAW        ; TODO: comment
  CALL SAVE_CARACTER_BG   ; Save the background of the caracter
  CALL DRAW_CARACTER      ; Draw the caracter on the screen
  RET
RENDER_CARACTER ENDP

; --- Draw caracter ---
DRAW_CARACTER PROC
  SAVE_REGS
  CLD                             ; Clear direction flag

  MOV SI, curr_sprite             ; Load main caracter current sprite
  CALC_VGA_POSITION pos_x, pos_y  ; Calculate VGA position in DI

  MOV DX, CARACTER_HEIGHT         ; Height of the sprite (number of lines)

  ; --- draw the caracter loop
  dc_draw_line:
    MOV CX, CARACTER_WIDTH
    PUSH DI                       ; Save current line start
    dc_draw_pixel:
      LODSB                       ; Load pixel from SI in AL then SI++
      OR AL, AL                   ; Check if pixel color is 0 (transparent)
      JZ dc_skip_pixel            ; If pixel is transparent, skip pixel
      MOV ES:[DI], AL             ; Draw pixel
      dc_skip_pixel:
        INC DI                    ; Next pixel on sreen
        LOOP dc_draw_pixel

    POP DI                      ; Restore line start
    ADD DI, SCREEN_WIDTH        ; Move DI to the next line
    DEC DX
    JNZ dc_draw_line            ; Draw next line if caracter is not entirely draw

  RESTORE_REGS
  RET
DRAW_CARACTER ENDP

; Save caracter background (with inversion of DS and ES for using MOVSB optimization)
SAVE_CARACTER_BG PROC
  SAVE_REGS
  CLD

  CALC_VGA_POSITION pos_x, pos_y    ; Calculate VGA position in DI

  MOV SI, DI                        ; Save VGA position in SI

  ; Save and inverse DS and ES
  PUSH DS
  PUSH ES

  MOV AX, DS                        ; Save DS in AX
  MOV BX, ES                        ; Save ES in BX
  MOV DS, BX                        ; Inverse DS and ES
  MOV ES, AX                        ; Inverse ES and DS
  ; Now we have : DS:SI = VGA, ES:DI = RAM

  MOV DI, OFFSET bg_sprite          ; Background buffer in DI

  MOV DX, CARACTER_HEIGHT           ; Number of lines to read

  s_read_line:
    MOV CX, CARACTER_WIDTH          ; Number of pixels to read
    PUSH SI
    ; MOVSB is used to copy a byte from DS:SI to ES:DI
    ; REP is used to repeat the instruction CX times
    REP MOVSB
    POP SI


  ADD SI, SCREEN_WIDTH            ; Next line
  DEC DX                          ; Decrement line counter
  JNZ s_read_line

  ; ---Restore DS & ES---
  POP ES
  POP DS

  RESTORE_REGS
  RET
SAVE_CARACTER_BG ENDP

; Restore caracter background (with MOVSB optimization)
RESTORE_CARACTER_BG PROC
  SAVE_REGS
  CLD

  CALC_VGA_POSITION pos_x, pos_y  ; Calculate VGA position in DI
  MOV SI, OFFSET bg_sprite        ; Background buffer

  MOV DX, CARACTER_HEIGHT         ; Number of lines to draw

r_restore_line:
  PUSH DI
  MOV CX, CARACTER_WIDTH          ; Number of pixels to draw (line width)

  ; MOVSB copies a byte from DS:SI to ES:DI and increments both pointers
  ; REP repeats the MOVSB instruction CX times (line width)
  REP MOVSB

  POP DI                          ; Restore the initial position of the line
  ADD DI, SCREEN_WIDTH            ; Calcul the position of the next line
  DEC DX                          ; Decrement line counter
  JNZ r_restore_line              ; If not zero, repeat the process

  RESTORE_REGS
  RET
RESTORE_CARACTER_BG ENDP
