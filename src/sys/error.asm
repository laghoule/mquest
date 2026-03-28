;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; ---------------------------------------------------------------------
; CONCAT_ERROR_MSG
; Description: Concatenate the error message with the error code
; Registers: AX, CX, SI, DI, ES
; Input:  AX = Concat source at location X to destination error message
;         SI = offset of the source message
;         DI = offset of the destination error message
; Output:
; Modified:
; ---------------------------------------------------------------------
CONCAT_ERROR_MSG PROC
  SAVE_REGS

  PUSH ES           ; Save ES
  PUSH AX           ; Save AX (location at with to concatenate)
  MOV AX, @DATA
  MOV ES, AX        ; Set ES to data segment (needed for MOVSB)

  CALL STR_LEN      ; Get the length of the message in CX

  POP AX
  ADD DI, AX        ; Go to the AX character of the error message

  ; CX is the length of the source message, from STR_LEN
  REP MOVSB         ; Concatenate the 2 strings (DS:SI -> ES:DI)
  POP ES            ; Restore ES

  RESTORE_REGS
  RET
CONCAT_ERROR_MSG ENDP
