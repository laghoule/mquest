;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;------------------------------------------------------------------------------
; UPDATE_CHARACTER_ANIM_INDEX
; Description : Update the sprite of the character based on the animation index
; Registers: AX, BX, CL
; Input:    AX: char_index
; Output:   None
; Modified: Character data struct
;------------------------------------------------------------------------------
UPDATE_CHARACTER_ANIM_INDEX PROC
  SAVE_REGS

  SHL AX, 1                           ; Conversion index -> offset (DW)
  MOV BX, AX                          ; Move the offset into BX

  MOV BX, [char_data_table + BX]      ; BX = character data struct

  INC [BX].CHARACTER.ch_anim_cnt
  MOV CL, [BX].CHARACTER.ch_anim_cnt
  CMP [BX].CHARACTER.ch_anim_spd, CL
  JNE @ucai_skip

  MOV [BX].CHARACTER.ch_anim_cnt, 0

  MOV AL, [BX].CHARACTER.ch_anim_idx
  ADD AL, 1
  CMP AL, 3
  JNE @F
  XOR AL, AL
@@:
  MOV [BX].CHARACTER.ch_anim_idx, AL  ; Save the animation index in the character struct

@ucai_skip:
  RESTORE_REGS
  RET
UPDATE_CHARACTER_ANIM_INDEX ENDP

;---------------------------------------------------
; DRAW_CHARACTER_MEM
; Description: Draw the character in a memory buffer
; Registers: AX, BX, CX, DX, SI, DI, ES
; Input:AX: char_index
; Output: None
; Modified:
; --------------------------------------------------
DRAW_CHARACTER_MEM PROC
  SAVE_REGS
  CLD                                         ; Clear direction flag

  SHL AX, 1                                   ; Convert index -> offset (DW)
  MOV BX, AX

  MOV BX, [char_data_table + BX]              ; BX = character data struct

  ; --- Copy character background to ch_sprite_buffer
  PUSH ES
  MOV AX, DS
  MOV ES, AX
  MOV SI, [BX].CHARACTER.ch_bg_buf_addr       ; SI = Address of the character background buffer
  MOV DI, [BX].CHARACTER.ch_render_buf_addr   ; DI = Address of the character render buffer
  MOV CX, CHAR_SIZE                           ; CX = Number of bytes to copy
  SHR CX, 1                                   ; Convert byte count -> word count
  REP MOVSW                                   ; Copy background to render buffer
  POP ES

  ; --- Setup registers for sprite drawing ---
  MOV DI, [BX].CHARACTER.ch_render_buf_addr

  ; --- Direction ---
  XOR AH, AH
  MOV AL, [BX].CHARACTER.ch_dir               ; AL = direction index
  SHL AX, 1                                   ; Convert index -> offset (DW)

  MOV SI, [BX].CHARACTER.ch_dir_tbl_addr      ; SI = Address of the character direction table
  ADD SI, AX                                  ; SI = Address of the direction data

  ; --- Resolve double indirection to sprite table ---
  ; dir_table[dir_offset] -> direction_data -> sprite_table
  MOV SI, [SI]                                ; Follow pointer to direction_data
  MOV SI, [SI].CHAR_DIR_DATA.cd_sprt_tbl_addr ; Follow pointer to sprite_table

  ; --- Animation sprite ---
  XOR AH, AH
  MOV AL, [BX].CHARACTER.ch_anim_idx          ; AL = animation index
  SHL AX, 1                                   ; Convert index -> offset (DW)

  ADD SI, AX                                  ; SI = Address of the sprite data for the current animation index
  MOV AX, [SI]                                ; AX = Dereference sprite offset to get the right tile

  ; --- Sprite buffered data ---
  MOV SI, [BX].CHARACTER.ch_sprt_buf_addr     ; Load character offset buffer
  ADD SI, PIC_HDR_SIZE                        ; Jump above .pic header size
  ADD SI, AX                                  ; Tile index in the tileset buffef

  MOV DX, CHAR_HEIGHT                         ; Height of the sprite (number of lines)

  ; --- draw the character loop ---
  PUSH ES                                     ; Save ES (VGA segment)
  MOV AX, DS
  MOV ES, AX                                  ; ES = DS (Memory segment)
  @dc_draw_line:
    MOV CX, CHAR_WIDTH
    PUSH DI                                   ; Save current line start
    @dc_draw_pixel:
      LODSB                                   ; Load pixel from SI in AL then SI++
      OR AL, AL                               ; Check if pixel color is 0 (transparent)
      JZ @dc_skip_pixel                       ; If pixel is transparent, skip pixel
      MOV ES:[DI], AL                         ; Draw pixel
      @dc_skip_pixel:
        INC DI                                ; Next pixel on sreen
        LOOP @dc_draw_pixel

    POP DI                                    ; Restore line start
    ADD DI, CHAR_WIDTH                        ; Move DI to the next line
    DEC DX
    JNZ @dc_draw_line                         ; Draw next line if character is not entirely draw
  POP ES                                      ; Restore ES (VGA segment)

  RESTORE_REGS
  RET
DRAW_CHARACTER_MEM ENDP

;----------------------------------------------
; DRAW_CHARACTER_VGA
; Description: Draw the character on VGA memory
; Registers: AX, BX, CX, DX, SI, DI, ES
; Input:    AX: char_index
; Output:   None
; Modified:
; ---------------------------------------------
DRAW_CHARACTER_VGA PROC
  SAVE_REGS
  CLD                                         ; Clear direction flag

  SHL AX, 1                                   ; Convert index -> offset (DW)
  MOV BX, AX

  MOV BX, [char_data_table + BX]              ; BX = character data struct

  ; --- Position ---
  MOV AX, [BX].CHARACTER.ch_loc.lo_x          ; AX = character X position
  PUSH BX
  MOV BX, [BX].CHARACTER.ch_loc.lo_y          ; BX = character Y position
  CALC_VGA_POSITION AX, BX                    ; Calculate VGA position in DI
  POP BX

  MOV SI, [BX].CHARACTER.ch_render_buf_addr   ; SI = character render buffer address
  MOV DX, CHAR_HEIGHT

@dcg_draw_line:
  PUSH DI                                     ; Save current line start
  MOV CX, CHAR_WIDTH                          ; CX = number of bytes to copy
  SHR CX, 1                                   ; Divide by 2 for word copy
  REP MOVSW                                   ; Copy a line of the character to the screen
  POP DI                                      ; Restore line start
  ADD DI, SCREEN_WIDTH                        ; Move DI to the next line
  DEC DX                                      ; Decrement line counter
  JNZ @dcg_draw_line                          ; Draw next line if character is not entirely draw

  RESTORE_REGS
  RET
DRAW_CHARACTER_VGA ENDP

; ---------------------------------------------------------------------
; SAVE_CHARACTER_BG
; Description: Save character background in memory
;              with inversion of DS and ES for using MOVSB optimization
; Registers: AX, BX, CX, DI, SI, ES, DS
; Input: AX: char_index
; Output: None
; Modified: char_data_table.ch_bg_addr
; ---------------------------------------------------------------------
SAVE_CHARACTER_BG PROC
  SAVE_REGS
  CLD

  SHL AX, 1                           ; Character index, multiply by 2
  MOV BX, AX
  MOV BX, [char_data_table + BX]      ; Pointer to the character data

  ; Calculate the VGA position of the character
  PUSH BX
  MOV AX, [BX].CHARACTER.ch_loc.lo_x
  MOV BX, [BX].CHARACTER.ch_loc.lo_y
  CALC_VGA_POSITION AX, BX            ; Calculate VGA position in DI
  POP BX

  MOV SI, DI                            ; Save VGA position in SI
  MOV DI, [BX].CHARACTER.ch_bg_buf_addr ; Background buffer in DI

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
  SHR CX, 1                           ; Divide by 2 for MOVSW
  PUSH SI
  ; MOVSW is used to copy a byte from DS:SI to ES:DI
  ; REP is used to repeat the instruction CX times
  REP MOVSW
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
;              with MOVSW optimization
; Registers: AX, BX, CX, DX, SI, DI
; Input:  AX: char_index
; Output: None
; Modified: None
; ------------------------------------------------------
RESTORE_CHARACTER_BG PROC
  SAVE_REGS
  CLD

  SHL AX, 1                                   ; Convert character index to offset (DW)
  MOV BX, AX
  MOV BX, [char_data_table + BX]              ; Address to the character data

  PUSH BX
  ; Load the previous location of the character
  MOV AX, [BX].CHARACTER.ch_prev_loc.lo_x
  MOV BX, [BX].CHARACTER.ch_prev_loc.lo_y
  CALC_VGA_POSITION AX, BX                    ; Calculate VGA position in DI
  POP BX

  MOV SI, [BX].CHARACTER.ch_prev_bg_buf_addr  ; SI = Address of the previous background buffer
  MOV DX, CHAR_HEIGHT                         ; Number of lines to draw

@rcb_restore_line:
  PUSH DI
  MOV CX, CHAR_WIDTH                          ; Counter of number of pixels to draw (line width)
  SHR CX, 1                                   ; Divide by 2 because we use MOVSW

  ; MOVSW copies a byte from DS:SI to ES:DI and increments both pointers
  ; REP repeats the MOVSW instruction CX times (line width)
  REP MOVSW

  POP DI                                      ; Restore the initial position of the line
  ADD DI, SCREEN_WIDTH                        ; Calcul the position of the next line
  DEC DX                                      ; Decrement line counter
  JNZ @rcb_restore_line                       ; If not zero, repeat the process

  RESTORE_REGS
  RET
RESTORE_CHARACTER_BG ENDP

; ---------------------------------------------------------------------
; RENDER_CHARACTER
; Description:
; Registers:
; Input: AX: char_index
; Output: None
; Modified:
; ---------------------------------------------------------------------
RENDER_CHARACTER PROC
  PUSH AX                                   ; Save char_index (SHL will modify AX)

  SHL AX, 1
  MOV BX, AX
  MOV BX, [char_data_table + BX]

  ; === Ping-pong bg buffers ===
  MOV AX, [BX].CHARACTER.ch_bg_buf_addr
  MOV DX, [BX].CHARACTER.ch_prev_bg_buf_addr
  MOV [BX].CHARACTER.ch_bg_buf_addr, DX       ; ← slot vide → cible du CROP
  MOV [BX].CHARACTER.ch_prev_bg_buf_addr, AX  ; ← ancien bg → source du RESTORE

  MOV SI, [BX].CHARACTER.ch_scene_addr      ; SI = scene address
  MOV DI, [BX].CHARACTER.ch_bg_buf_addr     ; DI = background buffer
  PUSH DI                                   ; Save DI (background buffer address)
  MOV DI, OFFSET metatile_sp_buffer         ; DI = metatile scratchpad

  MOV AX, [BX].CHARACTER.ch_loc.lo_x
  MOV BX, [BX].CHARACTER.ch_loc.lo_y

  CALL DRAW_METATILE_RAM                    ; Builds 32x32 metatile → metatile_sp_buffer

  CALL RESOLVE_TILE_FINEOFFSET              ; AH = FineX, AL = FineY
  XOR BH, BH
  MOV BL, AL                                ; BX = FineY
  MOV AL, AH                                ; AX = FineX
  XOR AH, AH

  POP DI                                    ; Restore DI = background buffer address
  MOV SI, OFFSET metatile_sp_buffer
  CALL CROP_METATILE_RAM                    ; Crops 16x17 into ch_bg_buf_addr (ready for next frame)

  POP AX
  CALL DRAW_CHARACTER_MEM                   ; Copies bg_buf into render_buf, draws sprite on top

  PUSH AX                                   ; Save AX (char_index)
  WAIT_VSYNC
  POP AX                                    ; Restore AX (char_index)

  CALL RESTORE_CHARACTER_BG
  CALL DRAW_CHARACTER_VGA                   ; Blits render_buf → VGA at current position

  RET
RENDER_CHARACTER ENDP
