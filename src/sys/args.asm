;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;------------------------------------------------------
; PARSE_CMDLINE_ARGS
; Description: Parse and process command-line arguments
; Input: None
; Output: None
; Modified: mute_flag
; -----------------------------------------------------
PARSE_CMDLINE_ARGS PROC
  SAVE_REGS

  XOR CH, CH
  MOV CL, ES:[80h]          ; Lenght of the cmdline arguments
  JCXZ @pa_done

  ; Supported arguments: /m (mute music)
  ; NOTE: ES points to the PSP (Program Segment Prefix), where the command-line arguments are stored at offset 80h (length) and 81h (string)
  MOV SI, 81h               ; Pointer to the cmdline arguments string

@pa_check_args:

; Check for the "/m" argument to mute music
  MOV AL, ES:[SI]           ; Load the current character
  CMP AL, '/'
  JNE @pa_next_char

  MOV AL, ES:[SI+1]
  CMP AL, 'm'
  JNE @pa_next_char

  MOV mute_flag, 1          ; Mute music

@pa_next_char:
  INC SI                    ; Move to the next character
  LOOP @pa_check_args       ; Loop until all characters are processed

@pa_done:
  RESTORE_REGS
  RET
PARSE_CMDLINE_ARGS ENDP
