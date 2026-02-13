;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;------------------------------------------------------------------------------------
; UPDATE_CHARACTER_ANIM_INDEX
; Description : Update the right sprite of the character based on the animation index
; Input:  AX: char_index
; Output: None
;------------------------------------------------------------------------------------
UPDATE_CHARACTER_ANIM_INDEX PROC
  SAVE_REGS

  SHL AX, 1                           ; Multiply by 2 to get the offset of the character
  MOV BX, AX                          ; Move the offset into BX

  MOV BX, [char_data_table + bx]      ; Load the character data into BX

  ; --- via the timer stored in game_tick ---
  MOV AL, game_tick
  AND AL, 03h                         ; Mask the lower 2 bits of the time value
  CMP AL, 3                           ; Check if the animation frequency is reached
  JNE @F                              ; If not, skip the animation update
  XOR AL, AL                          ; Reset the animation state to 0
@@:
  MOV [BX].CHARACTER.ch_anim_idx, AL  ; Save the animation index

  RESTORE_REGS
  RET
UPDATE_CHARACTER_ANIM_INDEX ENDP

;-------------------------------------------------
; RENDER_CHARACTER
; Description: Render the character on the screen
; Input:       none
; Output:      none
; ------------------------------------------------
; TODO refactor for input character index (input)
RENDER_CHARACTER PROC
  CALL SAVE_CHARACTER_BG          ; Save the background of the character
  CALL DRAW_CHARACTER             ; Draw the character on the screen
  RET
RENDER_CHARACTER ENDP

;-------------------------------------------------
; RENDER_RESTORE_BACKGROUND
; Description: Restore the background of the character on the screen
; Input:       none
; Output:      none
; ------------------------------------------------
; TODO refactor for input character index (input)
RENDER_RESTORE_BACKGROUND PROC
  CALL RESTORE_CHARACTER_BG       ; Restore the background of the character
  RET
RENDER_RESTORE_BACKGROUND ENDP

;----------------------------------------------
; DRAW_CHARACTER
; Description: Draw the character on the screen
; Input: AX: char_index
; Output: None
; ---------------------------------------------
DRAW_CHARACTER PROC
  SAVE_REGS
  CLD                                      ; Clear direction flag

  SHL AX, 1                                ; char_index, multiply by 2
  MOV BX, AX

  MOV BX, [char_data_table + BX]           ; Character data

  ; --- Direction ---
  MOV SI, [BX].CHARACTER.ch_dir_table_addr ; Load direcion table pointer
  XOR AH, AH
  MOV AL, [BX].CHARACTER.ch_dir            ; Load direction
  SHL AX, 1                                ; Multiply by 2
  ADD SI, AX                               ; Add offset of the direction to the direction table pointer

  ; --- Resolve pointer ---
  MOV SI, [SI]                             ; Direction table offset
  MOV SI, [SI]                             ; Sprite table offset

  ; --- Animation sprite ---
  XOR AH, AH                               ; Clear AH
  MOV AL, [BX].CHARACTER.ch_anim_idx       ; Load animation index
  SHL AX, 1                                ; Multiply by 2

  ADD SI, AX                               ; Add offset of the animation index to the sprite table pointer
  MOV AX, [SI]                             ; Load the sprite index

  ; --- Sprite buffered data ---
  MOV SI, [BX].CHARACTER.ch_buf_addr       ; Load character offset buffer
  ADD SI, TILESET_HDR_SIZE                 ; Jump above header size
  ADD SI, AX                               ; Tile index in the tileset buffef

  ; --- Position ---
  MOV AX, [BX].CHARACTER.ch_x              ; This will be gone when position refactor is complete
  PUSH BX                                  ; Save BX
  MOV BX, [BX].CHARACTER.ch_y              ; Idem
  CALC_VGA_POSITION AX, BX                 ; Calculate VGA position in DI
  POP BX

  MOV DX, CHAR_HEIGHT                      ; Height of the sprite (number of lines)

  ; --- draw the character loop ---
  @dc_draw_line:
    MOV CX, CHAR_WIDTH
    PUSH DI                                ; Save current line start
    @dc_draw_pixel:
      LODSB                                ; Load pixel from SI in AL then SI++
      OR AL, AL                            ; Check if pixel color is 0 (transparent)
      JZ @dc_skip_pixel                    ; If pixel is transparent, skip pixel
      MOV ES:[DI], AL                      ; Draw pixel
      @dc_skip_pixel:
        INC DI                             ; Next pixel on sreen
        LOOP @dc_draw_pixel

    POP DI                                 ; Restore line start
    ADD DI, SCREEN_WIDTH                   ; Move DI to the next line
    DEC DX
    JNZ @dc_draw_line                      ; Draw next line if character is not entirely draw

  RESTORE_REGS
  RET
DRAW_CHARACTER ENDP

; ---------------------------------------------------------------------
; SAVE_CHARACTER_BG
; Description: Save character background in memory
;              with inversion of DS and ES for using MOVSB optimization
; Input:  AX: char_index
; Output: None
; Modified: char_data_table.ch_bg_addr
; ---------------------------------------------------------------------
SAVE_CHARACTER_BG PROC
  SAVE_REGS
  CLD

  SHL AX, 1                           ; Character index, multiply by 2
  MOV BX, AX
  MOV BX, [char_data_table + BX]      ; Pointer to the character data

  PUSH BX
  MOV AX, [BX].CHARACTER.ch_x         ; This will be gone when position refactor is complete
  MOV BX, [BX].CHARACTER.ch_y         ; Idem
  CALC_VGA_POSITION AX, BX            ; Calculate VGA position in DI
  POP BX

  MOV SI, DI                          ; Save VGA position in SI
  MOV DI, [BX].CHARACTER.ch_bg_addr   ; Background buffer in DI

  ; Save and inverse DS and ES
  PUSH DS
  PUSH ES

  MOV AX, DS                          ; Save DS in AX
  MOV DX, ES                          ; Save ES in DX
  MOV DS, DX                          ; Inverse DS and ES
  MOV ES, AX                          ; Inverse ES and DS

  ; Now we have : DS:SI = VGA, ES:DI = RAM

  MOV DX, CHAR_HEIGHT                 ; Number of lines to read

@scb_read_line:
  MOV CX, CHAR_WIDTH                  ; Number of pixels to read
  PUSH SI
  ; MOVSB is used to copy a byte from DS:SI to ES:DI
  ; REP is used to repeat the instruction CX times
  REP MOVSB
  POP SI

  ADD SI, SCREEN_WIDTH                ; Next line
  DEC DX                              ; Decrement line counter
  JNZ @scb_read_line

  ; ---Restore DS & ES---
  POP ES
  POP DS

  RESTORE_REGS
  RET
SAVE_CHARACTER_BG ENDP

; ------------------------------------------------------
; RESTORE_CHARACTER_BG
; Description: Restore character background from memory
;              with MOVSB optimization
; Input:  AX: char_index
; Output: None
; ------------------------------------------------------
RESTORE_CHARACTER_BG PROC
  SAVE_REGS
  CLD

  SHL AX, 1                           ; Character index is a word, so * 2
  MOV BX, AX
  MOV BX, [char_data_table + BX]      ; Pointer to the character data

  PUSH BX
  MOV AX, [BX].CHARACTER.ch_x
  MOV BX, [BX].CHARACTER.ch_y
  CALC_VGA_POSITION AX, BX            ; Calculate VGA position in DI
  POP BX

  MOV SI, [BX].CHARACTER.ch_bg_addr   ; Background save buffer
  MOV DX, CHAR_HEIGHT                 ; Number of lines to draw

@rcb_restore_line:
  PUSH DI
  MOV CX, CHAR_WIDTH                  ; Number of pixels to draw (line width)

  ; MOVSB copies a byte from DS:SI to ES:DI and increments both pointers
  ; REP repeats the MOVSB instruction CX times (line width)
  REP MOVSB

  POP DI                              ; Restore the initial position of the line
  ADD DI, SCREEN_WIDTH                ; Calcul the position of the next line
  DEC DX                              ; Decrement line counter
  JNZ @rcb_restore_line               ; If not zero, repeat the process

  RESTORE_REGS
  RET
RESTORE_CHARACTER_BG ENDP
