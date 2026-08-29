;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; FIXME: review blueprint, HUD in testing mode, can change frequently

; -----------------------------------------------------------------------------
;                         HUD LAYOUT BLUEPRINT (320 x 24)
; -----------------------------------------------------------------------------
;  VRAM Area : Y = 176 to 199 (Height = 24 pixels, Width = 320 pixels)
;  Tile Size : 8x8 px (40 tiles wide, 3 tiles tall)
;  Offset    : 0DC00h in Segment 0A000h (56,320 bytes)
;
;  0 px                     124 px                 224 px                320 px
;  +---------------------------+----------------------+-----------------------+
;  |                           |                      |                       |
;  |  [AVATAR]  OBJECTIF:      | [SLOT1][SLOT2][SLOT3]|  LV 07                |
;  |   16x16    Potion soin    |  16x16  16x16  16x16 |  <3  <3  <3  (3 PV)   |
;  |                           |                      |                       |
;  +---------------------------+----------------------+-----------------------+
;
;  PANELS COORDINATES (Y = 180, Content Height = 16 px) :
;  ----------------------------------------------------------------------------
;  1. LEFT PANEL   (X: 4..120)   : Portrait (16x16) + 2 Lines of 8x8 Text
;  2. CENTER PANEL (X: 124..220) : Quick Item Slots (3 or 4 Icons 16x16)
;  3. RIGHT PANEL  (X: 224..316) : Level Text (8x8) + Hearts Row (8x8 Icons)
; ----------------------------------------------------------------------------

; -------------------------------------------------------------------
; DRAW_HUD_VGA
; Description: Draw / update the HUD on the VGA screen
; Registers: AX, BX, CX, DX, SI, DI, BP
; Input: None
; Output: None
; Modified: None
; -------------------------------------------------------------------
DRAW_HUD_VGA PROC
  SAVE_REGS

  ; --- Local variables ---
  ; [BP + 0] = X position
  ; [BP + 2] = Y position
  ; [BP + 4] = HUD tile height
  ; [BP + 6] = HUD tile width
  SUB SP, 8
  MOV BP, SP

  MOV BX, 0
  MOV [BP + 0], BX                          ; TODO: magic number
  MOV BX, 176
  MOV [BP + 2], BX                          ; TODO: magic number
  MOV BX, HUD_TILE_HEIGHT
  MOV [BP + 4], BX
  MOV BX, HUD_TILE_WIDTH
  MOV [BP + 6], BX

  MOV SI, OFFSET hud_buffer
  MOV DX, 3

  ; Draw the HUD layer
  ; 8x8 px tile - 40x3 tiles
  @dhd_next_line:
    MOV CX, HUD_LAYER_WIDTH
    XOR BX, BX
    MOV [BP + 0], BX
    @dhd_next_tile:
        LODSB                               ; Data are store in bytes (AL)

        ; Bit schifting to get the correct tile index
        ; Multiply by 64 (8x8)
        ; Must use AX, else we overflow the register
        XOR AH, AH
        SHL AX, 1
        SHL AX, 1
        SHL AX, 1
        SHL AX, 1
        SHL AX, 1
        SHL AX, 1

        ADD AX, OFFSET hud_tileset_buffer
        CALL DRAW_TILE_VGA                  ; Draw opaque tile on screen

        MOV BX, HUD_TILE_WIDTH
        ADD [BP + 0], BX

        LOOP @dhd_next_tile

    MOV BX, [BP + 2]
    ADD BX, HUD_TILE_HEIGHT
    MOV [BP + 2], BX

    DEC DX
    JNZ @dhd_next_line

  ADD SP, 8                                 ; Restore stack (free local variables)
  RESTORE_REGS
  RET
DRAW_HUD_VGA ENDP
