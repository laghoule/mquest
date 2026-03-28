;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; --------------------------------------------
; LOAD_FILE
; Description: Load a file in a buffer
; Registers: AX, BX, CX, DX, SI, DI
; Input:  DX: Offset of the name of the file
;         DI: Offset of the destination buffer
; Output: Carry flag set if error
; Modified: None
; --------------------------------------------
LOAD_FILE PROC
  SAVE_REGS

  ; --- Call DOS for opening the file specified in DX ---
  MOV AH, 3Dh             ; Open File fucntion
  MOV AL, 0               ; Open in read only mode
  INT 21h                 ; Call DOS, return file handle in AX
  JC @lf_fail_open        ; Carry flag set if error

  MOV BX, AX              ; Store file handle in BX

  ; --- Call DOS for reading the file ---
  PUSH DX                 ; Save the file name
  MOV AH, 3Fh             ; Read file function
  MOV CX, 0FFFFh          ; Max allowed 64K (entire segment)
  MOV DX, DI              ; Destination buffer (DI addr in DX)
  INT 21h                 ; Call DOS, fill DX (buffered var)
  POP DX                  ; Restore the file name
  PUSHF                   ; Save flags for checking error later, need to close the file before

  ; -- Call DOS to close the file ---
  MOV AH, 3Eh             ; Close file function
  INT 21h                 ; Call DOS
  POPF                    ; Restore flags from reading function
  JC @lf_fail_read        ; Carry flag set if error reading file

  RESTORE_REGS
  RET

@lf_fail_open:            ; Open file error handler
  MOV SI, DX              ; Set SI to the filename
  LEA DI, ERR_OPEN_FILE   ; Set DI to the error message

  MOV AX, 20              ; Concat at location 20
  CALL CONCAT_ERROR_MSG

  LEA DX, ERR_OPEN_FILE   ; Offset of open file error message
  MOV AL, 1               ; Set stderr
  CALL PRINT              ; Call print
  STC                     ; Set carry flag to indicate error
  JMP @lf_return

@lf_fail_read:            ; Read file error handler
  MOV SI, DX              ; Set SI to the filename
  LEA DI, ERR_READ_FILE   ; Set DI to the error message

  MOV AX, 20              ; Concat at location 20
  CALL CONCAT_ERROR_MSG

  LEA DX, ERR_READ_FILE   ; Offset of read file error message
  MOV AL, 1               ; Set stderr
  CALL PRINT              ; Call print
  STC                     ; Set carry flag to indicate error
  JMP @lf_return

@lf_return:
  RESTORE_REGS
  RET
LOAD_FILE ENDP
