;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;--------------------------------------------------------------
; PRINT
; Description: Print a message to the console
; Input: AL = 0 (stdout) or 1 (stderr)
;        DX: Offset of the error message to print
; Output: None
; -------------------------------------------------------------
PRINT PROC
  SAVE_REGS

  TEST AL, AL
  JNZ @p_set_stdout

  MOV BX, 1     ; stdout (used in INT 21h)
  JMP @p_print

@p_set_stdout:
  MOV BX, 2     ; stderr (used in INT 21h)

@p_print:

  MOV SI, DX    ; Offset of the error message to print
  CALL STR_LEN  ; Calculate the length of the error message (IN: DI, OUT: CX)

  ; --- Write to file (stderr (BX:2) is console)
  MOV AH, 40h   ; Write to file function
  INT 21h       ; Call DOS

  RESTORE_REGS
  RET
PRINT ENDP
