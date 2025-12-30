; --- Test background ---
DRAW_TMP_BG PROC
  SAVE_REGS
  CLD

  XOR DI, DI
  MOV AL, 06h ; brown color
  MOV CX, 64000
  REP STOSB

  RESTORE_REGS
  RET
DRAW_TMP_BG ENDP
