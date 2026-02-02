;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;--------------------------------------------------------------
; PRINT_ERR
; Description: Print an error message to the console, in STDERR
; Input:  DX: Offset of the error message to print
; Output: None
; -------------------------------------------------------------
PRINT_ERR PROC
  SAVE_REGS

  MOV SI, DX
  CALL STR_LEN

  MOV AH, 40h
  MOV BX, 2
  INT 21h

  RESTORE_REGS
  RET
PRINT_ERR ENDP
