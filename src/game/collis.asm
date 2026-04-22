;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------
; CHECK_COLLISION
; Description: Checks if a position is colliding with an object
; Register: AL, DX
; Input: AX = pos_x, BX = pos_y
;   Implicit: curr_scne (via GET_TILE_PROP)
; Output: Carry flag set if collision, clear otherwise
; Modifed: Carry flag
;----------------------------------------------------------------
CHECK_COLLISION PROC
  SAVE_REGS
  CLC                         ; Clear carry flag

  PUSH AX                     ; Save AX, because GER_TILE_PROP uses it for return value

  XOR DX, DX                  ; DX = offset of the map (bg = 0)
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  TEST AL, B_CL               ; We test if the tile is collidable
  POP AX                      ; Restore pos_x in AX (need to be before jump)
  JNZ @cc_is_collision        ; Jump if collision detected

  MOV DX, MAP_LAYER_SIZE      ; DX = offset of the scene (fg = 1, last part of the map)
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  TEST AL, B_CL               ; We test if the tile is collidable
  JNZ @cc_is_collision        ; Jump if collision detected

  JMP @cc_done

@cc_is_collision:
  STC                         ; Set carry flag for detected collision

@cc_done:
  RESTORE_REGS
  RET
CHECK_COLLISION ENDP

; ------------------------------------------------------------------------
; CHECK_HITBOX_COLLISION
; Description: Check if a character hitbox collides with object in the map
; Registers: AX, BX, CX, DX, SI, DI
; Input: AX = Character index, CX = X position, DX = Y position
;   Implicit: curr_scne
; Output: Carry flag = 1 if collision detected
; Modified: Carry flag
; ------------------------------------------------------------------------
CHECK_HITBOX_COLLISION PROC
  SAVE_REGS

  SHL AX, 1                                 ; Conversion characted index -> offset (DW)
  MOV BX, AX

  MOV BX, [char_data_table + BX]            ; BX = Address of the character data structure

  ; Get the direction of the character
  XOR AH, AH
  MOV AL, [BX].CHARACTER.ch_dir
  SHL AX, 1

  ;Resolve the direction indirection: Master table -> direction data block
  MOV SI, [BX].CHARACTER.ch_dir_tbl_addr    ; SI = Address of the 4-directions table
  ADD SI, AX                                ; SI = Address of the direction data
  MOV SI, [SI]                              ; Dereference the direction data (hitbox, sprites, ...)
  MOV DI, [SI].CHAR_DIR_DATA.cd_hitbox      ; Dereference the hitbox

  ; Hitbox 1 position X (CX -> AX (X))
  XOR AX, AX
  MOV AL, [DI].HITBOX.hb_x1
  ADD AX, CX                                ; Add hitbox P1X to X position

  ; Hitbox 1 position Y (DX -> BX (Y))
  XOR BX, BX
  MOV BL, [DI].HITBOX.hb_y1
  ADD BX, DX                                ; Add hitbox P1Y to Y position

  CALL CHECK_COLLISION                      ; Check for collition , carry flag will be set if collision
  JC @chc_return                            ; If collision, return

  ; Hitbox 2 position X (CX -> AX (X))
  XOR AX, AX
  MOV AL, [DI].HITBOX.hb_x2
  ADD AX, CX                                ; Add hitbox P2X to X position

  ; Hitbox 2 position Y (DX -> BX (Y))
  XOR BX, BX
  MOV BL, [DI].HITBOX.hb_y2
  ADD BX, DX                                ; Add hitbox P2Y to Y position

  CALL CHECK_COLLISION                      ; Check for collition, carry flag will be set if collision

@chc_return:
  RESTORE_REGS
  RET
CHECK_HITBOX_COLLISION ENDP
