;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; ---------------------------------------
; DRAW_TILE
; Description: Draws a tile with or without transparency
; Input:  AX = tileset offset, BX = map type (bg || fg)
; Output: None
; Modified: None
; ---------------------------------------
DRAW_TILE PROC
  SAVE_REGS
  CLD                             ; Clear direction flag

  MOV BX, AX
  LEA SI, [BX + 3]                ; Tileset offset + 3 header = tiles data (TODO: 3 should be a const)
  SYNC_POS_REGS                   ; AX=pos_x, BX=pos_y
  CALC_VGA_POSITION AX, BX        ; Calculate VGA position in DI

  MOV DX, TILE_HEIGHT             ; Height of the sprite (number of lines)

  ; --- draw the tile loop
  @dt_draw_line:
    MOV CX, TILE_WIDTH
    PUSH DI                       ; Save current line start

    ; BX determine the map type
    ; 0 = bg (opaque)
    ; 1 = fg (transparent)
    TEST BX, BX
    JNZ @dt_draw_pixel

    ; MOVSB copies a byte from DS:SI to ES:DI and increments both pointers
    ; REP repeats the MOVSB instruction CX times (line width)
    REP MOVSB
    JMP @dt_next_line

    @dt_draw_pixel:
      LODSB                       ; Load from SI in AL then increment SI
      OR AL, AL                   ; Check if pixel is transparent
      JZ @dt_skip_pixel          ; Skip pixel if transparent
      MOV ES:[DI], AL             ; Draw pixel
      @dt_skip_pixel:
        INC DI                    ;  Next pixel on screen
        LOOP @dt_draw_pixel

    @dt_next_line:
      POP DI                        ; Restore line start
      ADD DI, SCREEN_WIDTH          ; Move DI to the next line
      DEC DX
      JNZ @dt_draw_line            ; Draw next line if tile is not entirely draw

  RESTORE_REGS
  RET
DRAW_TILE ENDP

;----------------------------------------------
; GET_TILE_PROP
; Description: Retrieves properties of a tile
; Input:  pos_x, pos_y
; Output: AH = tile type, AL = tile properties
; ---------------------------------------------
GET_TILE_PROP PROC
  SAVE_REGS

  ; TODO: we may reorganize the operation for better optimization
  ; Index = (Y/16 * 20) + (X/16).
  MOV AX, pos_y               ; Bit shift right by 4
  SHR AX, 1                   ; to get Y / 16
  SHR AX, 1                   ; 4 SHR is better on the 8086
  SHR AX, 1
  SHR AX, 1

  MOV BX, AX                  ; We now have the line, save in BX

  SHL BX, 1                   ; We now need to multiply by 20
  SHL BX, 1                   ; We decompose because 20, is not a factor of 2
  SHL BX, 1                   ; Shift left by 4, to get multiply by 16
  SHL BX, 1

  MOV CX, AX                  ; We save the line in CX
  SHL CX, 1                   ; We shift left by 2, to get multiply by 4
  SHL CX, 1

  ; 16 times + 4 times = 20 times
  ADD BX, CX                  ; We now have (Y/16 * 20) in BX

  MOV AX, pos_x               ; AX = X/16
  SHR AX, 1                   ; Bit shift right (4 times = /16)
  SHR AX, 1
  SHR AX, 1
  SHR AX, 1

  ADD BX, AX                  ; We now have our index in BX

  MOV SI, [curr_scne]         ; curr_scne must be in SI for retriving the tile
  ADD SI, 2                   ; Jump map header
  MOV AL, [SI + BX]           ; Offset of curr_scne + index is the tile type
  XOR AH, AH                  ; Clear AH

  MOV BX, AX                  ; BX = Final Map Index (0-239)

  MOV AL, [map_tiles_props + BX]  ; Load tile properties via the index
  MOV AH, BL                  ; Save the tile type in AH

  MOV TX, AX                  ; Use a software register to temporary store AX
  RESTORE_REGS
  MOV AX, TX                  ; Restore AX for returning properties in AL
  RET
GET_TILE_PROP ENDP
