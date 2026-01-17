; Prepare Mia position to use the draw generic position
PREPARE_MIA_DRAW MACRO
  SYNC_MIA_POSITION
  MOV AX, mia_curr_sprite ; Save current sprite to generic sprite
  MOV curr_sprite, AX
ENDM

SYNC_MIA_POSITION MACRO
  MOV AX, mia_pos_x       ; Save X position to generic position
  MOV pos_x, AX
  MOV AX, mia_pos_y       ; Save Y position to generic position
  MOV pos_y, AX
ENDM
