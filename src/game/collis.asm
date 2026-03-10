;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------
; CHECK_COLLISION
; Description: Checks if a position is colliding with an object
; Input:  pos_x, pos_y
; Output: Carry flag set if collision, clear otherwise
; Modifed: curr_scne
;----------------------------------------------------------------
CHECK_COLLISION PROC
  SAVE_REGS
  CLC                         ; Clear carry flag

  XOR DX, DX                  ; DX = offset of the map (bg = 0)
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  TEST AL, B_CL               ; We test if the tile is collidable
  JNZ @cc_is_collision

  MOV DX, MAP_LAYER_SIZE      ; DX = offset of the scene (fg = 1, last part of the map)
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  TEST AL, B_CL               ; We test if the tile is collidable
  JNZ @cc_is_collision

  JMP @cc_done

@cc_is_collision:
  STC                         ; Set carry flag for detected collision

@cc_done:
  RESTORE_REGS
  RET
CHECK_COLLISION ENDP
