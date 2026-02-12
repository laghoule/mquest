;----------------------------------------------------------------
; CHECK_COLLISION
; Description: Checks if a position is colliding with an object
; Input:  pos_x, pos_y
; Output: Carry flag set if collision, clear otherwise
; Modifed: curr_map
;----------------------------------------------------------------
; TODO: curr_map not efficent
CHECK_COLLISION PROC
  SAVE_REGS
  CLC                         ; Clear carry flag

  MOV AX, curr_map_opq        ; We get the current tile map opaque
  MOV curr_map, AX
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  TEST AL, B_CL               ; We test if the tile is collidable
  JNZ @cc_is_collision

  MOV AX, curr_map_trns       ; We get the current tile map transparent
  MOV curr_map, AX
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
