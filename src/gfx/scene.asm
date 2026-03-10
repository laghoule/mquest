;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; ------------------------------------------------------
; DRAW_SCENE
; Description: Draw the scene on the screen, 2 layers (bg, fg)
; Input: AX: scene buffer
; Output: None
; Modified: VGA memory
; ------------------------------------------------------
DRAW_SCENE PROC
  SAVE_REGS

  MOV SI, AX                           ; Load offset of scene buffer
  MOV CX, 2                            ; 2 layer (bg, fg)

@ds_next_layer:
  PUSH SI                              ; Save the scene buffer for the next layer (loop)
  PUSH CX                              ; Save the CX counter

  CMP CX, 1                            ; Is this the foreground layer?
  JNE @ds_is_bg                        ; If not, it's the backgrounf layer, jump to @ds_is_bg

  ADD SI, MAP_LAYER_SIZE               ; Point to the foreground layer
  MOV BX, 1                            ; Set BX to 1 (foreground layer)
  JMP @ds_start_draw

@ds_is_bg:
  MOV BX, 0                            ; Set BX to the background layer

@ds_start_draw:
  MOV pos_y, 0
  MOV DX, MAP_SCENE_HEIGHT             ; Lines / height

  @ds_draw_line:
    MOV CX, MAP_SCENE_WIDTH            ; Columns / width
    MOV pos_x, 0

    @ds_draw_tile:
      PUSH CX
      LODSB

      ; BX determines if tile is opaque or transparent
      ; 0 = bg (opaque)
      ; 1 = fg (transparent)
      TEST BX, BX
      JE @ds_do_draw_tile              ; Background, jump to @ds_do_draw_tile

      TEST AL, AL                      ; Check if tile ID is VOID (0)
      JZ @ds_skip_tile                 ; Skip to next tile if zero

    @ds_do_draw_tile:
      ; Tile size is 256
      ; AL = index of tile in tileset
      ; AX = index of tile in tileset * 256
      MOV AH, AL                       ; Bit shift of 8 = multiply by 256
      XOR AL, AL                       ; Reset AL, for AX recomposition

      ; AX = offset of tile in tileset buffer
      ADD AX, OFFSET map_tileset_buffer
      CALL DRAW_TILE                   ; Draw opaque tile

    @ds_skip_tile:
      POP CX                           ; Restore columns counter
      ADD pos_x, MAP_TILE_WIDTH        ; Increment position by tile width
      LOOP @ds_draw_tile               ; Loop until all columns are drawn

    ADD pos_y, MAP_TILE_HEIGHT         ; Increment position by tile height
    DEC DX                             ; Decrement rows counter
    JNZ @ds_draw_line                  ; Loop until all lines are drawn

    POP CX
    POP SI
    LOOP @ds_next_layer

  RESTORE_REGS
  RET
DRAW_SCENE ENDP
