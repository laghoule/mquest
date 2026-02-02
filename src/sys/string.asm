;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------------
; STR_LEN
; Description: Count the length of a string (terminated by 0)
; Input:  SI: Offset of the string to count (without the terminating 0)
; Output: CX: Length of the string
;----------------------------------------------------------------------
STR_LEN PROC
  SAVE_REGS

  XOR CX, CX

@sl_loop:
  MOV AL, [SI]
  CMP AL, 0
  JE @sl_end_string

  INC CX
  INC SI
  JMP @sl_loop

@sl_end_string:
  MOV TX, CX

  RESTORE_REGS
  MOV CX, TX
  RET
STR_LEN ENDP
