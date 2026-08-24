;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; -----------------------------------------------------------------------------
;                         HUD LAYOUT BLUEPRINT (320 x 24)
; -----------------------------------------------------------------------------
;  VRAM Area : Y = 176 to 199 (Height = 24 pixels, Width = 320 pixels)
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
; Input: TODO
; Output: None
; Modified: None
; -------------------------------------------------------------------
DRAW_HUD_VGA PROC
  SAVE_REGS

  ;===========
  ; PROTOTYPE
  ;===========

  ; --- Local variables ---
  ; [BP + 0] = X position
  ; [BP + 2] = Y position
  ; [BP + 4] = HUD tile width
  ; [BP + 6] = HUD tile height
  SUB SP, 8
  MOV BP, SP

  MOV BX, 0
  MOV [BP + 0], BX   ; TODO: magic number
  MOV BX, 176
  MOV [BP + 2], BX ; TODO: magic number
  MOV BX, HUD_TILE_WIDTH
  MOV [BP + 4], BX
  MOV BX, HUD_TILE_HEIGHT
  MOV [BP + 6], BX

  MOV SI, OFFSET hud_buffer
  MOV CX, HUD_SCENE_WIDTH

  @dhd_next_tile:
  LODSB

  MOV AH, AL    ; 16x16 offset
  XOR AL, AL

  ADD AX, OFFSET hud_tileset_buffer
  CALL DRAW_TILE_VGA               ; Draw opaque tile on screen

  MOV BX, HUD_TILE_WIDTH
  ADD [BP + 0], BX
  XOR BX, BX

  LOOP @dhd_next_tile

  ADD SP, 8
  RESTORE_REGS
  RET
DRAW_HUD_VGA ENDP
