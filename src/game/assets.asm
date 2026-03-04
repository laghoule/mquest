;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------
; LOAD_ASSETS
; Description: Loads all assets from the assets table
; Input: AX : Offset of assets table, CX : Number of assets
; Output: None
; Modifed: Carry flag (set: error, cleared: success)
;----------------------------------------------------------------
LOAD_ASSETS PROC
  SAVE_REGS

  MOV SI, AX                          ; Load address of first asset into BX

@la_next_assets:
  MOV BX, [SI]                        ; Load address of asset into BX
  
  MOV DX, [BX].ASSETS.file_addr       ; File name in DX
  MOV DI, [BX].ASSETS.buffer_addr     ; Set destination buffer address
  CALL LOAD_FILE                      ; Load file function
  JC @la_error                        ; Jump to exit if carry flag set (error)

  ADD SI, 2                           ; Move to next asset (word: 2 byte)
  LOOP @la_next_assets

  CLC                                 ; Clear carry flag (success)
  JMP @la_exit                        ; Jump to exit

@la_error:
  STC                                 ; Set carry flag (error)

@la_exit:
  RESTORE_REGS
  RET
LOAD_ASSETS ENDP
