;  Copyright (C) 2025 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; --- Test background ---
DRAW_TMP_BG PROC
  SAVE_REGS
  CLD

  ;XOR DI, DI
  ;MOV AL, 06h ; brown color
  ;MOV CX, 64000
  ;REP STOSB

  MOV pos_x, 0
  MOV pos_y, 0

  MOV tile, OFFSET forest_bg_0
  MOV DX, 12
  MOV CX, 20
dt_draw_line:
  MOV CX, 20
  MOV pos_x, 0
  dt_draw_tile:
    CALL DRAW_TILE
    ADD pos_x, TILE_WIDTH
    LOOP dt_draw_tile
  ADD pos_y, TILE_HEIGHT
  DEC DX
  JNZ dt_draw_line

  RESTORE_REGS
  RET
DRAW_TMP_BG ENDP
