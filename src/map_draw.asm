;  Copyright (C) 2025 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; --- Base map layer ---
DRAW_OPAQUE_MAP PROC
  SAVE_REGS

  MOV pos_x, 0
  MOV pos_y, 0

  MOV DX, TILE_BY_Y   ; Lines

  dom_draw_line:
    MOV CX, TILE_BY_X ; Columns
    MOV pos_x, 0
    dom_draw_tile:
      ; 'tile' is loaded outside of this proc (before)
      ; and is used in DRAW_TILE_OPAQUE
      CALL DRAW_TILE_OPAQUE
      ADD pos_x, TILE_WIDTH
      LOOP dom_draw_tile
  ADD pos_y, TILE_HEIGHT
  DEC DX
  JNZ dom_draw_line

  RESTORE_REGS
  RET
DRAW_OPAQUE_MAP ENDP

; --- Items with transparence on the map ---
DRAW_TRANSPARENT_MAP PROC
  SAVE_REGS
  CLD

  RESTORE_REGS
  RET
DRAW_TRANSPARENT_MAP ENDP
