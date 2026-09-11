;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------------
; STR_LEN
; Description: Count the length of a string (terminated by 0)
; Registers: AX, CX, SI
; Input: SI: Offset of the string to count (without the terminating 0)
; Output: CX: Length of the string
; Modified: None
;----------------------------------------------------------------------
STR_LEN PROC
  PUSH AX
  PUSH SI
  
  XOR CX, CX                ; Clear CX

  ; --- CX is the len of the string ---
@sl_loop:
  MOV AL, [SI]              ; Put character in AL
  CMP AL, 0                 ; Jump to end if AL is 0 (end of string)
  JE @sl_end_string

  INC CX                    ; Increment the CX counter
  INC SI                    ; Go to next character
  JMP @sl_loop              ; Jump to next iteration

@sl_end_string:
  POP SI
  POP AX
  RET
STR_LEN ENDP
