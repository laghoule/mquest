;  Copyright (C) 2025 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

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
