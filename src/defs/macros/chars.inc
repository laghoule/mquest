SYNC_POS_REGS MACRO
  MOV AX, pos_x
  MOV BX, pos_y
ENDM

RENDER_CHARACTER MACRO
  CALL SAVE_CHARACTER_BG          ; Save the background of the character
  CALL DRAW_CHARACTER             ; Draw the character on the screen
ENDM