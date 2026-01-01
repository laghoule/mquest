;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; --- Base map layer ---
DRAW_OPAQUE_MAP PROC
  SAVE_REGS

  MOV pos_x, 0
  MOV pos_y, 0

  MOV DX, TILE_ROWS   ; Lines

  dom_draw_line:
    MOV CX, TILE_COLS ; Columns
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

  MOV pos_y, 0
  MOV DX, TILE_ROWS                         ; Rows counter

  MOV SI, curr_map                          ; Load current map index

  dtm_rows_loop:
    MOV CX, TILE_COLS
    MOV pos_x, 0

    dtm_colums_loop:
      PUSH CX                               ; Save columns counter
      LODSB                                 ; AL = ID of tile, SI++

      OR AL, AL                             ; Check if tile ID is zero
      JZ dtm_skip_tile

      ; --- Get tile index ---
      XOR AH, AH                            ; Clear AH register
      SHL AX, 1                             ; Shift left by 1 bit (multiply by 2)
      MOV BX, AX
      MOV AX, [tiles_trns_table + BX]       ; Load tile index from table
      MOV tile, AX

      CALL DRAW_TILE_TRANSPARENT

      dtm_skip_tile:
      POP CX                                ; Restore columns counter
      ADD pos_x, TILE_WIDTH                 ; Next tile column
      LOOP dtm_colums_loop

      ADD pos_y, TILE_HEIGHT                ; Next tile row
      DEC DX                                ; Decrement rows counter
      JNZ dtm_rows_loop

  RESTORE_REGS
  RET
DRAW_TRANSPARENT_MAP ENDP
