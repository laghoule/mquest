;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.


; ------------------------------------------------------------------
; LOAD_GAME_PALETTE
; Description: Loads the game palette into the VGA palette registers
; Input: None
; Output: None
; ------------------------------------------------------------------
LOAD_GAME_PALETTE PROC
  SAVE_REGS
  CLD                               ; Clear direction flag

  MOV DX, 03C8h                     ; Index of the VGA DAC (Digital to Analog Converter)
  XOR AL, AL                        ; We start at 0
  OUT DX, AL                        ; Set index
  INC DX                            ; 03C9h to write data in the DAC

  MOV SI, OFFSET game_palette_data  ; Load game palette data
  MOV CX, 768                       ; 3 (RGB) * 256

@lgp_load_palette:
  LODSB                             ; Load DS:SI in AL, and increment SI
  OUT DX, AL                        ; Push in the DAC
  LOOP @lgp_load_palette            ; Loop until CX is 0

  RESTORE_REGS
  RET
LOAD_GAME_PALETTE ENDP
