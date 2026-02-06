; TODO: Get rid of this macro
SYNC_MIA_POSITION MACRO
  MOV AX, mia_pos_x       ; Save X position to generic position
  MOV pos_x, AX
  MOV AX, mia_pos_y       ; Save Y position to generic position
  MOV pos_y, AX
ENDM

; TODO: Try to eliminate pos_x, pos_y
SYNC_POS_REGS MACRO
  MOV AX, pos_x
  MOV BX, pos_y
ENDM