;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;------------------------------------------------------------------------------------
; UPDATE_CHARACTER_ANIM_INDEX
; Description : Update the sprite of the character based on the animation index
; Input:    AX: char_index
; Output:   None
; Modified: Character data struct
;------------------------------------------------------------------------------------
UPDATE_CHARACTER_ANIM_INDEX PROC
  SAVE_REGS

  SHL AX, 1                           ; Conversion index -> offset (DW)
  MOV BX, AX                          ; Move the offset into BX

  MOV BX, [char_data_table + bx]      ; BX = character data struct

  ; We use the game tick to update the animation index
  MOV AL, game_tick
  AND AL, 03h                         ; Mask the lower 2 bits of the time value
  CMP AL, 3                           ; Check if the animation frequency is reached
  JNE @F                              ; If not, skip the animation update
  XOR AL, AL                          ; Reset the animation state to 0
@@:
  MOV [BX].CHARACTER.ch_anim_idx, AL  ; Save the animation index in the character struct

  RESTORE_REGS
  RET
UPDATE_CHARACTER_ANIM_INDEX ENDP

;----------------------------------------------
; DRAW_CHARACTER
; Description: Draw the character on the screen
; Input:    AX: char_index
; Output:   None
; Modified:
; ---------------------------------------------
DRAW_CHARACTER PROC
  SAVE_REGS
  CLD                                      ; Clear direction flag

  SHL AX, 1                                ; Convert index -> offset (DW)
  MOV BX, AX

  MOV BX, [char_data_table + BX]           ; BX = character data struct

  ; --- Direction ---
  XOR AH, AH
  MOV AL, [BX].CHARACTER.ch_dir            ; AL = direction index
  SHL AX, 1                                ; Convert index -> offset (DW)

  MOV SI, [BX].CHARACTER.ch_dir_table_addr ; SI = Address of the character direction table
  ADD SI, AX                               ; SI = Address of the direction data

  ; --- Resolve double indirection to sprite table ---
  ; dir_table[dir_offset] -> direction_data -> sprite_table
  MOV SI, [SI]                             ; Follow pointer to direction_data
  MOV SI, [SI]                             ; Follow pointer to sprite_table

  ; --- Animation sprite ---
  XOR AH, AH
  MOV AL, [BX].CHARACTER.ch_anim_idx       ; AL = animation index
  SHL AX, 1                                ; Convert index -> offset (DW)

  ADD SI, AX                               ; SI = Address of the sprite data for the current animation index
  MOV AX, [SI]                             ; AX = Dereference sprite offset to get the right tile

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
