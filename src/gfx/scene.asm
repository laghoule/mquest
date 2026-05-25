;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; -------------------------------------------------------------------
; DRAW_SCENE_VGA
; Description: Draw the scene on the screen, 2 layers (bg, fg) on VGA
; Input: AX: scene buffer
; Output: None
; Modified: VGA memory
; -------------------------------------------------------------------
DRAW_SCENE_VGA PROC
  SAVE_REGS

  MOV SI, AX                           ; Load offset of scene buffer
  MOV CX, 2                            ; 2 layer (bg, fg)

@dsv_next_layer:
  PUSH SI                              ; Save the scene buffer for the next layer (loop)
  PUSH CX                              ; Save the CX counter

  CMP CX, 1                            ; Is this the foreground layer?
  JNE @dsv_is_bg                       ; If not, it's the backgrounf layer, jump to @ds_is_bg

  ADD SI, MAP_LAYER_SIZE               ; Point to the foreground layer
  MOV BX, 1                            ; Set BX to 1 (foreground layer)
  JMP @dsv_start_draw

@dsv_is_bg:
  MOV BX, 0                            ; Set BX to the background layer

@dsv_start_draw:
  MOV pos_y, 0
  MOV DX, MAP_SCENE_HEIGHT             ; Lines / height

  @dsv_draw_line:
    MOV CX, MAP_SCENE_WIDTH            ; Columns / width
    MOV pos_x, 0

    @dsv_draw_tile:
      PUSH CX
      LODSB

      ; BX determines if tile is opaque or transparent
      ; 0 = bg (opaque)
      ; 1 = fg (transparent)
      TEST BX, BX
      JE @dsv_do_draw_tile              ; Background, jump to @ds_do_draw_tile

      TEST AL, AL                       ; Check if tile ID is VOID (0)
      JZ @dsv_skip_tile                 ; Skip to next tile if zero

    @dsv_do_draw_tile:
      ; Tile size is 256 (16x16)
      ; AL = index of tile in tileset
      ; AX = index of tile in tileset * 256
      MOV AH, AL                       ; Bit shift of 8 = multiply by 256
      XOR AL, AL                       ; Reset AL, for AX recomposition

      ; AX = offset of tile in tileset buffer
      ADD AX, OFFSET map_tileset_buffer
      CALL DRAW_TILE_VGA               ; Draw opaque tile on screen

    @dsv_skip_tile:
      POP CX                           ; Restore columns counter
      ADD pos_x, MAP_TILE_WIDTH        ; Increment position by tile width
      LOOP @dsv_draw_tile              ; Loop until all columns are drawn

    ADD pos_y, MAP_TILE_HEIGHT         ; Increment position by tile height
    DEC DX                             ; Decrement rows counter
    JNZ @dsv_draw_line                 ; Loop until all lines are drawn

    POP CX
    POP SI
    LOOP @dsv_next_layer

  RESTORE_REGS
  RET
DRAW_SCENE_VGA ENDP

; -------------------------------------------------------------------------
; DRAW_SCENE_PARTIAL_RAM
; Description:
; Input: AX = pos_x, BX = pos_y, SI = scene buffer, DI = memory tile buffer
; Output:
; Modified:
; -------------------------------------------------------------------------
DRAW_SCENE_PARTIAL_RAM PROC
  SAVE_REGS
  ; TODO: Implement
  RESTORE_REGS
  RET
DRAW_SCENE_PARTIAL_RAM ENDP
