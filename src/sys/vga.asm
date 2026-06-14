;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.


; ------------------------------------------------------------------
; LOAD_GAME_PALETTE
; Description: Loads the game palette into the VGA palette registers
; Registers: AX, CX, DX, SI
; Input: None
;   Indirect: game_palette_data
; Output: None
; Mofified: None
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

; ---------------------------------------------------------------------------------
; WAIT_VSYNC
; Description: Waits for the start and end of the vertical VGA sync
; Registers: AX, DX
; Input: None
; Output: None
; Mofified: None
; Notes:
;   https://www.scs.stanford.edu/22wi-cs212/pintos/specs/freevga/vga/vgacrtc.htm
;   https://www.scs.stanford.edu/22wi-cs212/pintos/specs/freevga/vga/crtcreg.htm#16
; ---------------------------------------------------------------------------------
WAIT_VSYNC PROC
  PUSH AX
  PUSH DX

  MOV DX, 03DAh               ; VGA status port
@wv_wait_end:
  IN AL, DX                   ; Read the status register
  TEST AL, 8                  ; Check if the vertical sync is active (bit 8)
  JNZ @wv_wait_end            ; Wait for the end of the vertical sync
@wv_wait_start:
  IN AL, DX                   ; Read the status register
  TEST AL, 8                  ; Check if the vertical sync is active (bit 8)
  JZ @wv_wait_start           ; Wait for the start of the vertical sync

  POP DX
  POP AX
  RET
WAIT_VSYNC ENDP