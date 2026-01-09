;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; --- Draw tile ---
DRAW_TILE_OPAQUE PROC
  SAVE_REGS
  CLD                             ; Clear direction flag

  MOV SI, tile                    ; Load tile
  CALC_VGA_POSITION pos_x, pos_y  ; Calculate VGA position in DI

  MOV DX, TILE_HEIGHT             ; Height of the sprite (number of lines)

  ; --- draw the tile loop
  @dto_draw_line:
    MOV CX, TILE_WIDTH
    PUSH DI                       ; Save current line start

    ; MOVSB copies a byte from DS:SI to ES:DI and increments both pointers
    ; REP repeats the MOVSB instruction CX times (line width)
    REP MOVSB

    POP DI                        ; Restore line start
    ADD DI, SCREEN_WIDTH          ; Move DI to the next line
    DEC DX
    JNZ @dto_draw_line              ; Draw next line if tile is not entirely draw

  RESTORE_REGS
  RET
DRAW_TILE_OPAQUE ENDP

; --- Draw tile with transparence ---
DRAW_TILE_TRANSPARENT PROC
  SAVE_REGS
  CLD                             ; Clear direction flag

  MOV SI, tile                    ; Load tile
  CALC_VGA_POSITION pos_x, pos_y  ; Calculate VGA position in DI

  MOV DX, TILE_HEIGHT             ; Height of the sprite (number of lines)

  ; --- draw the tile loop
  @dtt_draw_line:
    MOV CX, TILE_WIDTH
    PUSH DI                       ; Save current line start

    @dtt_draw_pixel:
      LODSB                       ; Load from SI in AL then increment SI
      OR AL, AL                   ; Check if pixel is transparent
      JZ @dtt_skip_pixel           ; Skip pixel if transparent
      MOV ES:[DI], AL             ; Draw pixel
      @dtt_skip_pixel:
        INC DI                    ;  Next pixel on screen
        LOOP @dtt_draw_pixel

    POP DI                        ; Restore line start
    ADD DI, SCREEN_WIDTH          ; Move DI to the next line
    DEC DX                        ; Decrement line counter
    JNZ @dtt_draw_line             ; Draw next line if tile is not entirely draw

  RESTORE_REGS
  RET
DRAW_TILE_TRANSPARENT ENDP
