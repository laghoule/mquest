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
; Modify: [BX].CHARACTER.ch_state
;--------------------------------------------------
PAUSE PROC
  SAVE_REGS

  MOV CX, 2                         ; TODO: hardcoded pause of 2 sec

  SHL AX, 1                         ;  Conversion characted index -> offset (DW)
  MOV BX, AX
  MOV BX, [char_data_table + BX]    ; BX = Address of the character data structure

  MOV AX, [BX].CHARACTER.ch_tick    ; AX = Initial tick of the character

  ; We need to wait for CX * 18.20648 ticks
  MOV DX, CX                        ; Multiply * 2
  SHL DX, 1

  SHL CX, 1                         ; Multiply * 16
  SHL CX, 1
  SHL CX, 1
  SHL CX, 1

  ADD CX, DX                        ; We add to get the * 18

  ; --- Wait for the number of tick ---
  PUSH ES
  MOV DX, 40h
  MOV ES, DX
  MOV DX, ES:[6Ch]                  ; Get the current tick
  POP ES
  ; --- current - character tick to get the number of tick waited ----
  SUB DX, AX                        ; Subtract the initial tick
  CMP DX, CX                        ; Compare with the number of tick to wait
  ; --- If we have waited enough, unpause the character ---
  JGE @s_unpause
  MOV [BX].CHARACTER.ch_state, 1
  JMP @s_return

@s_unpause:
  MOV [BX].CHARACTER.ch_state, 0

@s_return:
  RESTORE_REGS
  RET
PAUSE ENDP
