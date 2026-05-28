;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; -------------------------------------------------------------
; DRAW_TILE_VGA
; Description: Draws a tile with or without transparency on VGA
; Registers: AX, BX, CX, DX, SI, DI
; Input:  AX = tileset offset, BX = map type (bg || fg)
; Output: None
; Modified: None
; -------------------------------------------------------------
DRAW_TILE_VGA PROC
  SAVE_REGS
  CLD                             ; Clear direction flag

  PUSH BX                         ; Save map type in BX
  MOV BX, AX
  LEA SI, [BX]                    ; Tileset offset

  ; Here BX is rewritten by SYNC_POS_REGS
  SYNC_POS_REGS                   ; AX=pos_x, BX=pos_y
  CALC_VGA_POSITION AX, BX        ; Calculate VGA position in DI

  POP BX                          ; Restore map type in BX
  MOV DX, MAP_TILE_HEIGHT         ; Height of the sprite (number of lines)

  ; --- draw the tile loop
  @dtv_draw_line:
    MOV CX, MAP_TILE_WIDTH
    PUSH DI                       ; Save current line start

    ; BX determine the map type
    ; 0 = bg (opaque)
    ; 1 = fg (transparent)
    TEST BX, BX
    JNZ @dtv_draw_pixel

    ; MOVSB copies a byte from DS:SI to ES:DI and increments both pointers
    ; REP repeats the MOVSB instruction CX times (line width)
    REP MOVSB                     ; TODO: use MOVSW
    JMP @dtv_next_line

    @dtv_draw_pixel:
      LODSB                       ; Load from SI in AL then increment SI | TODO: use LODSW
      OR AL, AL                   ; Check if pixel is transparent
      JZ @dt_skip_pixel           ; Skip pixel if transparent
      MOV ES:[DI], AL             ; Draw pixel
      @dt_skip_pixel:
        INC DI                    ;  Next pixel on screen
        LOOP @dtv_draw_pixel

    @dtv_next_line:
      POP DI                      ; Restore line start
      ADD DI, SCREEN_WIDTH        ; Move DI to the next line
      DEC DX
      JNZ @dtv_draw_line           ; Draw next line if tile is not entirely draw

  RESTORE_REGS
  RET
DRAW_TILE_VGA ENDP

; ------------------------------------------------------------------------------
; DRAW_TILE_RAM
; Description: Draws a tile with or without transparency in a memory buffer
; Registers: AX, BX, CX, DX, SI, DI
; Input:  AX = tileset offset, BX = map type (bg || fg), DI = memory tile buffer
; Output: None
; Modified: None
; NOTES: Maybe merge with DRAW_TILE_VGA in the future
; ------------------------------------------------------------------------------
DRAW_TILE_RAM PROC
  SAVE_REGS
  PUSH ES

  CLD                             ; Clear direction flag

  MOV DX, DS
  MOV ES, DX                      ; Set ES to DS (RAM)

  PUSH BX                         ; Save map type in BX
  MOV BX, AX
  LEA SI, [BX]                    ; Tileset offset

  POP BX                          ; Restore map type in BX
  MOV DX, MAP_TILE_HEIGHT         ; Height of the sprite (number of lines)

  ; --- draw the tile loop
  @dtr_draw_line:
    MOV CX, MAP_TILE_WIDTH
    PUSH DI                       ; Save current line start

    ; BX determine the map type
    ; 0 = bg (opaque)
    ; 1 = fg (transparent)
    TEST BX, BX
    JNZ @dtr_draw_pixel

    ; MOVSB copies a byte from DS:SI to ES:DI and increments both pointers
    ; REP repeats the MOVSB instruction CX times (line width)
    REP MOVSB                     ; Draw a line of the tile in the memory buffer
    JMP @dtr_next_line

    @dtr_draw_pixel:
      LODSB                       ; Load from SI in AL then increment SI
      OR AL, AL                   ; Check if pixel is transparent
      JZ @dtr_skip_pixel          ; Skip pixel if transparent
      MOV [DI], AL                ; Draw pixel in the memory buffer
      @dtr_skip_pixel:
        INC DI                    ;  Next pixel in the buffer memory
        LOOP @dtr_draw_pixel

    @dtr_next_line:
      POP DI                      ; Restore line start
      ADD DI, SCENE_SCRATCHPAG_BG ; Move DI to the next line (2 x MAP_TILE_WIDTH)
      DEC DX
      JNZ @dtr_draw_line          ; Draw next line if tile is not entirely draw

  POP ES
  RESTORE_REGS
  RET
DRAW_TILE_RAM ENDP

; --------------------------------------------------------------------------
; DRAW_METATILE_RAM
; Description: Draws a metatile of 32x32 in RAM
; Input: AX = pos_x, BX = pos_y, SI = scene address, DI = memory tile buffer
; Output:
; Modified:
; Notes: Tiles are stored in memory as follows:
;
;    0               16              32
;  0 +---------------+---------------+
;    |    Tile TL    |    Tile TR    |
;    |   (DI + 0)    |   (DI + 16)   |
; 16 +---------------+---------------+
;    |    Tile BL    |    Tile BR    |
;    |  (DI + 512)   |  (DI + 528)   |
; 32 +---------------+---------------+
;
; --------------------------------------------------------------------------
DRAW_METATILE_RAM PROC
  SAVE_REGS

  MOV pos_x, AX           ; Save X position
  MOV pos_y, BX           ; Save Y position

  MOV DX, 0               ; Initial layer is background (0)

@dspr_next_layer:
  MOV AX, pos_x
  MOV BX, pos_y
  ; --- Resolve the 4 tiles that are needed to draw the background ----
  ; Input: AX = pos_x, BX = pos_y, DX = background (0) or foreground (1), SI = scene address
  CALL RESOLVE_MAP_TILES ; Return: AX = X, Y offsets, BX = top left, right tiles , CX = bottom left, right tiles

  PUSH AX                 ; Save X, Y offsets
  PUSH BX                 ; Save top left, right tiles
  PUSH DI                 ; Save memory tile buffer

  ; --- Top left tile id ---
  XOR AH, AH              ; Clear AH
  MOV AL, BH              ; AX = tile id for top left

  ; Get the offset of the tile in the tileset
  MOV AH, AL              ; Multiply by 256 (bitshifting of 8 bits)
  XOR AL, AL              ; AX = tile id * 256 (offset)

  MOV BX, DX              ; Map layer
  ; Input:  AX = tileset offset, BX = map type (bg || fg), DI = memory tile buffer
  CALL DRAW_TILE_RAM      ; Draw the BG tile in buffer
  ; ------------------------

  ; --- Top right tile id ---
  ADD DI, 16              ; Next tile in buffer
  XOR AH, AH              ; Clear AH
  MOV AL, BL              ; AX = tile id for top right

  ; Get the offset of the tile in the tileset
  MOV AH, AL              ; Multiply by 256 (bitshifting of 8 bits)
  XOR AL, AL              ; AX = tile id * 256 (offset)

  MOV BX, DX              ; Map layer
  ; Input:  AX = tileset offset, BX = map type (bg || fg), DI = memory tile buffer
  CALL DRAW_TILE_RAM      ; Draw the BG tile in buffer
  ; ------------------------

  ; --- Bottom left tile id ---
  ADD DI, 496             ; Next tile in buffer (512 - 16)
  XOR AH, AH              ; Clear AH
  MOV AL, CH              ; AX = tile id for bottom left

  ; Get the offset of the tile in the tileset
  MOV AH, AL              ; Multiply by 256 (bitshifting of 8 bits)
  XOR AL, AL              ; AX = tile id * 256 (offset)

  MOV BX, DX              ; Map layer
  ; Input:  AX = tileset offset, BX = map type (bg || fg), DI = memory tile buffer
  CALL DRAW_TILE_RAM      ; Draw the BG tile in buffer
  ; ------------------------

  ; --- Bottom right tile id ---
  ADD DI, 16             ; Next tile in buffer (528 − 512)
  XOR AH, AH              ; Clear AH
  MOV AL, CL              ; AX = tile id for bottom right

  ; Get the offset of the tile in the tileset
  MOV AH, AL              ; Multiply by 256 (bitshifting of 8 bits)
  XOR AL, AL              ; AX = tile id * 256 (offset)

  MOV BX, DX              ; Map layer
  ; Input:  AX = tileset offset, BX = map type (bg || fg), DI = memory tile buffer
  CALL DRAW_TILE_RAM      ; Draw the BG tile in buffer
  ; ------------------------

  POP DI                  ; Restore memory tile buffer
  POP BX                  ; Restore top left, right tiles
  POP AX                  ; Restore X, Y offsets

  INC DX                  ; Next layer
  CMP DX, 1               ; Check if we've drawn all layers
  JLE @dspr_next_layer    ; If DX is lower than or equal 1, draw next layer (0, 1 layer)

  RESTORE_REGS
  RET
DRAW_METATILE_RAM ENDP

;----------------------------------------------------
; CHECK_OUT_OF_BOUND_POSITION
; Description: Checks if the position is out of bound
; Registers: AX, BX
; Input:  AX = pos_x, BX = pos_y
; Output: carry flag set if out of bound
; Modified: carry flag
; ---------------------------------------------------
CHECK_OUT_OF_BOUND_POSITION PROC
  CMP AX, LIMIT_EAST + CHAR_WIDTH + 1    ; 325 because pos_x is the left of the character
  JGE @coobp_out_of_bound

  CMP AX, LIMIT_WEST
  JLE @coobp_out_of_bound

  CMP BX, LIMIT_NORTH
  JLE @coobp_out_of_bound

  CMP BX, LIMIT_SOUTH + CHAR_HEIGHT + 1  ; 176 because we reserve 24 lines for the status bar
  JGE @coobp_out_of_bound

  CLC
  JMP @coobp_in_bound

@coobp_out_of_bound:
  STC

@coobp_in_bound:
  RET
CHECK_OUT_OF_BOUND_POSITION ENDP

;-----------------------------------------------------------------
; GET_TILE_PROP
; Description: Retrieves properties of a tile (collision, etc.)
; Registers: AX, BX, CX, DX, SI
; Input: AX = pos_x, BX = pos_y, DX = offset of the scene to check
;   Implicit: curr_scne, map_tiles_props
; Output: AL = tile properties
; Modified: AX, TX
; ----------------------------------------------------------------
GET_TILE_PROP PROC
  SAVE_REGS

  MOV CX, AX                      ; Save pos_x in CX

  CALL CHECK_OUT_OF_BOUND_POSITION
  JNC @gtp_position_validated

  ; Out of bounds, set collision
  MOV AL, B_CL                    ; Collision result in AL
  XOR AH, AH                      ; Clear AH
  JMP @gtp_return                 ; Out of bounds, return

@gtp_position_validated:
  ; TODO: we may reorganize the operation for better optimization
  ; Index = (Y/16 * 20) + (X/16).
  MOV AX, CX                      ; Restore pos_x in AX
  ; AX = Y/16
  MOV AX, BX                      ; Bit shift right by 4
  SHR AX, 1                       ; to get Y / 16
  SHR AX, 1                       ; 4 SHR is better on the 8086
  SHR AX, 1
  SHR AX, 1

  ; BX = Y/16
  MOV BX, AX                      ; We now have the line, save in BX

  ; BX = Y/16 * 16
  SHL BX, 1                       ; We now need to multiply by 20
  SHL BX, 1                       ; We decompose because 20, is not a factor of 2
  SHL BX, 1                       ; Shift left by 4, to get multiply by 16
  SHL BX, 1

  ; CX = Y/16 * 4
  PUSH CX
  MOV CX, AX                      ; We save the line in CX
  SHL CX, 1                       ; We shift left by 2, to get multiply by 4
  SHL CX, 1

  ; Combine the two results
  ; 16 times + 4 times = 20 times
  ADD BX, CX                      ; We now have BX = (Y/16 * 20)
  POP CX

  ; AX = X/16
  MOV AX, CX                      ; Restore pos_x in AX
  SHR AX, 1                       ; Bit shift right (4 times = /16)
  SHR AX, 1
  SHR AX, 1
  SHR AX, 1

  ; Index (Y/16 * 20) + (X/16)
  ADD BX, AX                  ; We now have our index in BX

  MOV SI, [map_buffer_addr]       ; Must be in SI for retriving the tile
  ADD SI, DX                      ; SI now point the the offset of the scene (bg or fg)
  MOV AL, [SI + BX]               ; Offset of map_buffer_addr + index is the tile type
  XOR AH, AH                      ; Clear AH

  MOV BX, AX                      ; BX = Final Map Index (0-239)

  MOV AL, [map_tiles_props + BX]  ; Load tile properties via the index
  MOV AH, BL                      ; Save the tile type in AH

@gtp_return:
  MOV TX, AX                      ; Use a software register to temporary store AX
  RESTORE_REGS
  MOV AX, TX                      ; Restore AX for returning properties in AL
  RET
GET_TILE_PROP ENDP

;-------------------------------------------------------------------------
; GET_MAP_TILE
; Description: Get the tile id (BG & FG) at a specific position in the map
; Registers: AX, BX, DX, SI
; Input: AX = pos_x, BX = pos_y, SI = scene address
; Output: AH = Backgrount tile id, AL = Foreground tile id
; Modified:
; ------------------------------------------------------------------------
GET_MAP_TILE PROC
  ; --- Save registers ---
  PUSH BX
  PUSH CX
  PUSH DX
  PUSH SI

  MOV SI, [SI]                          ; SI = Dereferenced sc_map_buffer_addr

  ; --- Calculate the Tile X, Y ---
  ; Tile are 16 x 16, so we divedy by 16
  SHR AX, 1                             ; Divide by 16
  SHR AX, 1                             ; Using bit shifting (4)
  SHR AX, 1
  SHR AX, 1

  SHR BX, 1                             ; Divide by 16
  SHR BX, 1                             ; Using bit shifting (4)
  SHR BX, 1
  SHR BX, 1

  ; --- Index = (BX * 20) + AX ---
  MOV DX, BX

  SHL BX, 1                             ; Multiply by 16
  SHL BX, 1                             ; Using bit shifting (4)
  SHL BX, 1
  SHL BX, 1

  SHL DX, 1                             ; Multiply by 4
  SHL DX, 1                             ; Using bit shifting (2)

  ADD BX, DX                            ; BX = (BX * 16) + (BX * 4) = BX * 20

  ADD BX, AX                            ; BX = (BX * 20) + AX

  MOV AH, [SI + BX]                     ; AH = Background tile id
  MOV AL, [SI + BX + MAP_LAYER_SIZE]    ; AL = Foreground tile id

  ; --- Restore registers ---
  POP SI
  POP DX
  POP CX
  POP BX

  RET
GET_MAP_TILE ENDP

;-------------------------------------------------------------------------------------------------------
; RESOLVE_MAP_TILES
; Description: Resolves the map tiles for a given position, and a given layer (background or foreground)
; Registers:
; Input: AX = pos_x, BX = pos_y, DX = background (0) or foreground (1), SI = scene address
; Output: AX = X, Y offsets, BX = top left, right tiles , CX = bottom left, right tiles
; Modified:
; ------------------------------------------------------------------------------------------------------
RESOLVE_MAP_TILES PROC
  MOV pos_x, AX
  MOV pos_y, BX

  AND AX, 15            ; Fine offset X (modulo 16)
  MOV AH, AL            ; AH = X offset
  AND BX, 15            ; Fine offset Y (modulo 16)
  MOV AL, BL            ; AL = Y offset

  PUSH AX               ; Save the offsets

  ; --- Top left tile ---
  MOV AX, pos_x
  MOV BX, pos_y
  CALL GET_MAP_TILE     ; Get the tiles at the AX, BX position
  XOR BX, BX            ; Clear BX
  TEST DX, 1            ; Check if we want the background layer
  JNZ @F                ; If not, skip the next instruction
  MOV BH, AH            ; BH = Background tile id
  JMP @rmt_top_right
@@:
  MOV BH, AL            ; BH = Foreground tile id

@rmt_top_right:
  ; --- Top right tile ---
  MOV AX, pos_x         ; AX = pos_x + (CHAR_HEIGHT - 1)
  ADD AX, CHAR_WIDTH
  DEC AX
  PUSH BX               ; Save BX (BH = top left tile id)
  MOV BX, pos_y
  CALL GET_MAP_TILE     ; Get the tiles at the AX, BX position
  POP BX                ; Restore BX (BH = top left tile id)
  TEST DX, 1            ; Check if we want the background layer
  JNZ @F                ; If not, skip the next instruction
  MOV BL, AH            ; BL = Background tile id
  JMP @rmt_bottom_left
@@:
  MOV BL, AL            ; BL = Foreground tile id

@rmt_bottom_left:
  ; --- Bottom left tile ---
  MOV AX, pos_x
  PUSH BX               ; Save BX (BH = top left tile id, BL = top right tile id)
  MOV BX, pos_y         ; BX = pos_y + (CHAR_HEIGHT - 1)
  ADD BX, CHAR_HEIGHT
  DEC BX
  CALL GET_MAP_TILE     ; Get the tiles at the AX, BX position
  POP BX                ; Restore BX (BH = top left tile id, BL = top right tile id)
  TEST DX, 1            ; Check if we want the background layer
  JNZ @F                ; If not, skip the next instruction
  MOV CH, AH            ; CH = Background tile id
  JMP @rmt_bottom_right
@@:
  MOV CH, AL            ; CH = Foreground tile id

@rmt_bottom_right:
  ; --- Bottom right tile ---
  MOV AX, pos_x         ; AX = pos_x + (CHAR_HEIGHT - 1)
  ADD AX, CHAR_WIDTH
  DEC AX
  PUSH BX               ; Save BX (BH = top left tile id, BL = top right tile id)
  MOV BX, pos_y         ; BX = pos_y + (CHAR_HEIGHT - 1)
  ADD BX, CHAR_HEIGHT
  DEC BX
  CALL GET_MAP_TILE     ; Get the tiles at the AX, BX position
  POP BX                ; Restore BX (BH = top left tile id, BL = top right tile id)
  TEST DX, 1            ; Check if we want the background layer
  JNZ @F                ; If not, skip the next instruction
  MOV CL, AH            ; CL = Background tile id
  JMP @rmt_return
@@:
  MOV CL, AL            ; CL = Foreground tile id

@rmt_return:
  POP AX                ; Return Fine Offset X, Y
  RET
RESOLVE_MAP_TILES ENDP
