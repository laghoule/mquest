;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; --------------------------------------------
; LOAD_FILE
; Description: Load a file in a buffer
; Input:  DX: Offset of the name of the file
;         DI: Offset of the destination buffer
; Output: Carry flag set if error
; --------------------------------------------
LOAD_FILE PROC
  SAVE_REGS

  MOV AH, 3Dh       ; Open File
  MOV AL, 0         ; In read only mode
  INT 21h           ; Call DOS
  JC @lf_fail_open  ; Carry flag if error

  MOV BX, AX        ; Store file handle in BX

  PUSH DX
  MOV AH, 3Fh       ; Read file
  MOV CX, 0FFFFh    ; Max allowed 64K
  MOV DX, DI        ; Destination buffer
  INT 21h           ; Call DOS
  POP DX
  PUSHf             ; Save flags

  MOV AH, 3Eh       ; Close file
  INT 21h           ; Call DOS
  POPf              ; Restore flags
  JC @lf_fail_read  ; Carry flag if error

  RESTORE_REGS
  RET

@lf_fail_open:
  LEA DX, ERR_FILE_OPEN
  CALL PRINT_ERR
  STC
  JMP @lf_return

@lf_fail_read:
  LEA DX, ERR_FILE_READ
  CALL PRINT_ERR
  STC
  JMP @lf_return

@lf_return:
  RESTORE_REGS
  RET
LOAD_FILE ENDP
