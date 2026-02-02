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

  MOV SI, DX    ; Offset of the error message to print
  CALL STR_LEN  ; Calculate the length of the error message (IN: DI, OUT: CX)

  ; --- Write to file (stderr (BX:2) is console)
  MOV AH, 40h   ; Write to file function
  MOV BX, 2     ; File handle for STDERR
  INT 21h       ; Call DOS

  RESTORE_REGS
  RET
PRINT_ERR ENDP
