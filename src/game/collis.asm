;----------------------------------------------------------------
; CHECK_COLLISION
; Description: Checks if a position is colliding with an obstacle
; Input:  pos_x, pos_y
; Output: AL = 0 (free), AL = 1 (collision)
;----------------------------------------------------------------
CHECK_COLLISION PROC
  SAVE_REGS

  ADD pos_y, 15 ; We test the foot (character are 16x17)
  CALL GET_TILE_PROP

  TEST AL, B_CL
  JNZ @cc_is_collision

  MOV collision_result, 0
  JMP @cc_done

@cc_is_collision:
  MOV collision_result, 1
  JMP @cc_done

@cc_done:
  RESTORE_REGS
  RET
CHECK_COLLISION ENDP
