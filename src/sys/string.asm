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

  XOR CX, CX          ; Clear CX

@sl_loop:
  MOV AL, [SI]        ; Put character in AL
  CMP AL, 0           ; Jump to end if AL is 0 (end of string)
  JE @sl_end_string

  INC CX              ; Increment the CX counter
  INC SI              ; Go to next character
  JMP @sl_loop        ; Jump to next iteration

@sl_end_string:
  MOV TX, CX          ; Temporary storage in TX

  RESTORE_REGS
  MOV CX, TX          ; String len in CX
  RET
STR_LEN ENDP
