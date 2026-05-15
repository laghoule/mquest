SYNC_POS_REGS MACRO
  MOV AX, pos_x
  MOV BX, pos_y
ENDM

RENDER_CHARACTER MACRO
  CALL RESTORE_CHARACTER_BG
  CALL SAVE_CHARACTER_BG          ; Save the background of the character
  CALL DRAW_CHARACTER_MEM         ; Draw the character in memory
  CALL DRAW_CHARACTER_VGA         ; Draw the character on the screen
ENDM

RENDER_CHARACTER_MEM MACRO
  ;CALL RESTORE_CHARACTER_BG
  ;CALL SAVE_CHARACTER_BG          ; Save the background of the character
  CALL DRAW_CHARACTER_MEM         ; Draw the character in memory
ENDM

RENDER_CHARACTER_VGA MACRO
  PUSH AX
  WAIT_VSYNC                  ; Wait for vertical syncronization to avoid flickering
  POP AX
  ;CALL RESTORE_CHARACTER_BG
  ;CALL SAVE_CHARACTER_BG          ; Save the background of the character  
  CALL DRAW_CHARACTER_VGA         ; Draw the character on the screen
ENDM

INIT_RENDER_CHARACTER MACRO
  CALL SAVE_CHARACTER_BG          ; Save the background of the character
  CALL DRAW_CHARACTER_MEM         ; Draw the character on the screen
  CALL DRAW_CHARACTER_VGA         ; Draw the character on the screen
ENDM