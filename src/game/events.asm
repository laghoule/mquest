;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;--------------------------------------------------
; SLEEP
; Description: Wait for a number of second (max 10)
; Registers: AX, BX, CX, DX, ES
; Input:  CX = Number of second to wait
;   Implicit: tick = Initial tick
; Output: None
; Modify: None
;--------------------------------------------------
SLEEP PROC
  SAVE_REGS

  MOV CX, 2
  
  MOV AX, 40h         ; Segment of the BIOS data area
  MOV ES, AX
  MOV AX, ES:[6Ch]    ; Get the current tick
  ;MOV AX, [SI]

  ; We need to wait for CX * 18.20648 ticks
  MOV BX, CX          ; Multiply * 2
  SHL BX, 1

  SHL CX, 1           ; Multiply * 16
  SHL CX, 1
  SHL CX, 1
  SHL CX, 1

  ADD CX, BX          ; We add to get the * 18

  ; --- Wait for the number of tick ---
@s_wait:
  MOV DX, ES:[6Ch]    ; Get the current tick
  SUB DX, AX          ; Subtract the initial tick
  CMP DX, CX          ; Compare with the number of tick to wait
  JGE @s_return       ; If we have waited enough, return
  JMP @s_wait         ; Else, wait more

@s_return:
  RESTORE_REGS
  RET
SLEEP ENDP
