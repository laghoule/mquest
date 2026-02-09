;----------------------------------------------------------------
; CHECK_COLLISION
; Description: Checks if a position is colliding with an obstacle
; Input:  pos_x, pos_y
; Output: AH = 0, AL = 0 (free), AH = 0, AL = 1 (collision)
;----------------------------------------------------------------
; TODO: use control flag instean (carry or zero)
CHECK_COLLISION PROC
  SAVE_REGS

  MOV AX, curr_map_opq        ; We get the current tile map opaque
  MOV curr_map, AX
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  TEST AL, B_CL               ; We test if the tile is collidable
  JNZ @cc_is_collision

  MOV TX, 0

  MOV AX, curr_map_trns       ; We get the current tile map transparent
  MOV curr_map, AX
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  TEST AL, B_CL               ; We test if the tile is collidable
  JNZ @cc_is_collision

  MOV TX, 0                   ; We use TX for temporary storage for no collision
  JMP @cc_done

@cc_is_collision:
  MOV TX, 1                   ; We set TX to 1 for collision

@cc_done:
  RESTORE_REGS
  XOR AX, AX                  ; Clear AX
  MOV AX, TX                  ; Copy the collision result in AX (AL containt the result)
  MOV TX, 0                   ; Reset TX to 0
  RET
CHECK_COLLISION ENDP
