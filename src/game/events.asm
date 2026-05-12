;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;--------------------------------------------------
; PAUSE
; Description: Wait for a number of second (max 10)
; Registers: AX, BX, CX, DX, ES
; Input:  CX = Number of second to wait
;   Implicit: tick = Initial tick
; Output: None
; Modify: None
;--------------------------------------------------
PAUSE PROC
  SAVE_REGS

  MOV CX, 2

  SHL AX, 1
  MOV BX, AX
  MOV BX, [char_data_table + BX]

  MOV AX, [BX].CHARACTER.ch_tick

  ; We need to wait for CX * 18.20648 ticks
  MOV DX, CX          ; Multiply * 2
  SHL DX, 1

  SHL CX, 1           ; Multiply * 16
  SHL CX, 1
  SHL CX, 1
  SHL CX, 1

  ADD CX, DX          ; We add to get the * 18

  ; --- Wait for the number of tick ---
  MOV DX, 40h
  PUSH ES
  MOV ES, DX
  MOV DX, ES:[6Ch]    ; Get the current tick
  POP ES
  SUB DX, AX          ; Subtract the initial tick
  CMP DX, CX          ; Compare with the number of tick to wait
  JGE @s_unpause      ; If we have waited enough, unpause the character
  MOV [BX].CHARACTER.ch_state, 1
  JMP @s_return

@s_unpause:
  MOV [BX].CHARACTER.ch_state, 0

@s_return:
  RESTORE_REGS
  RET
PAUSE ENDP
