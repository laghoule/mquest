;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; --- Base map layer ---
DRAW_OPAQUE_MAP PROC
  SAVE_REGS

  MOV pos_y, 0
  MOV DX, TILE_ROWS   ; Lines

  MOV SI, curr_map

  @dom_draw_line:
    MOV CX, TILE_COLS ; Columns
    MOV pos_x, 0

    @dom_draw_tile:
      PUSH CX
      ; 'tile' is loaded outside of this proc (before)
      ; and is used in DRAW_TILE_OPAQUE
      LODSB

      XOR AH, AH                      ; Clear AH register
      SHL AX, 1                       ; Shift left by 1 bit (multiply by 2)
      MOV BX, AX
      MOV AX, [tiles_table + BX]      ; Load tile index from table
      MOV tile, AX

      CALL DRAW_TILE_OPAQUE           ; Draw opaque tile

      POP CX                          ; Restore columns counter
      ADD pos_x, TILE_WIDTH           ; Increment position by tile width
      LOOP @dom_draw_tile             ; Loop until all columns are drawn

    ADD pos_y, TILE_HEIGHT            ; Increment position by tile height
    DEC DX                            ; Decrement rows counter
    JNZ @dom_draw_line                ; Loop until all lines are drawn

  RESTORE_REGS
  RET
DRAW_OPAQUE_MAP ENDP

; --- Draw items with transparency on the map ---
DRAW_TRANSPARENT_MAP PROC
  SAVE_REGS
  CLD

  MOV pos_y, 0
  MOV DX, TILE_ROWS                    ; Rows counter

  MOV SI, curr_map                     ; Load current map index

  @dtm_rows_loop:
    MOV CX, TILE_COLS
    MOV pos_x, 0

    @dtm_colums_loop:
      PUSH CX                          ; Save columns counter
      LODSB                            ; AL = ID of tile, SI++

      MOV BL, VOID_0                    ; VOID is empty tile
      OR AL, BL                        ; Check if tile ID is VOID (empty)
      JZ @dtm_skip_tile                ; Skip if zero

      ; --- Get tile index ---
      XOR AH, AH                       ; Clear AH register
      SHL AX, 1                        ; Shift left by 1 bit (multiply by 2)
      MOV BX, AX
      MOV AX, [tiles_table + BX]       ; Load tile index from table
      MOV tile, AX

      CALL DRAW_TILE_TRANSPARENT       ; Draw tile with transparency

      @dtm_skip_tile:
      POP CX                           ; Restore columns counter
      ADD pos_x, TILE_WIDTH            ; Increment position by tile width
      LOOP @dtm_colums_loop            ; Loop until all columns are drawn

      ADD pos_y, TILE_HEIGHT           ; Increment position by tile height
      DEC DX                           ; Decrement rows counter
      JNZ @dtm_rows_loop

  RESTORE_REGS
  RET
DRAW_TRANSPARENT_MAP ENDP
