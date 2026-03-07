;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; ------------------------------------------------------
; DRAW_SCENE
; Description: Draw the scene on the screen
; Input: AX: scene buffer, BX: type (bg || fg)
; Output: None
; Modified: VGA memory
; ------------------------------------------------------
DRAW_SCENE PROC
  SAVE_REGS

    MOV SI, AX
    ADD SI, 2                          ; Add map header size (TODO: should be a const)

  ; til header
  ; ----------
  ; offset 0 tile width
  ; offset 1 tile height
  ; offset 2 tile count

  ; map header
  ; ----------
  ; offset 0 scene width
  ; offset 1 scene height

  MOV pos_y, 0
  MOV DX, TILE_ROWS                    ; Lines (TODO: TILE_ROWS should be dynamic)

  @dom_draw_line:
    MOV CX, TILE_COLS                  ; Columns (TODO: TILE_COLS should be dynamic)
    MOV pos_x, 0

    @dom_draw_tile:
      PUSH CX
      LODSB

      ; BX determines if tile is opaque or transparent
      ; 0 = bg (opaque)
      ; 1 = fg (transparent)
      TEST BX, BX
      JZ @dom_draw_tile_opaque         ; TODO: Fix bad label

      TEST AL, AL                      ; Check if tile ID is VOID (0)
      JZ @dom_skip_tile                ; Skip if zero

      @dom_draw_tile_opaque:           ; TODO: fix bal label
      ; Tile size is 256
      ; AL = index of tile in tileset
      ; AX = index of tile in tileset * 256
      MOV AH, AL                      ; Bit shift of 8 = multiply by 256
      XOR AL, AL

      ; AX = offset of tile in tileset buffer
      PUSH BX
      ADD AX, OFFSET map_tileset_buffer
      MOV BX, 1                       ; Opaque tile
      CALL DRAW_TILE                  ; Draw opaque tile
      POP BX

      @dom_skip_tile:
      POP CX                          ; Restore columns counter
      ADD pos_x, TILE_WIDTH           ; Increment position by tile width (TODO: TILE_WIDTH should be dynamic)
      LOOP @dom_draw_tile             ; Loop until all columns are drawn

    ADD pos_y, TILE_HEIGHT            ; Increment position by tile height (TODO: TILE_HEIGHT should be dynamic)
    DEC DX                            ; Decrement rows counter
    JNZ @dom_draw_line                ; Loop until all lines are drawn

  RESTORE_REGS
  RET
DRAW_SCENE ENDP
