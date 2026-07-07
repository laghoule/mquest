;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;--------------------------------------------------
; EV_PAUSE
; Description: Wait for a number of second (max 10)
; Registers: AX, BX, CX, DX, ES
; Input: CX = Number of second to wait
;   Implicit: tick = Initial tick
; Output: None
; Modify: [BX].CHARACTER.ch_event.ev_state
;--------------------------------------------------
EV_PAUSE PROC
  SAVE_REGS

  SHL AX, 1                                 ;  Conversion characted index -> offset (DW)
  MOV BX, AX
  MOV BX, [char_data_table + BX]            ; BX = Address of the character data structure

  MOV AX, [BX].CHARACTER.ch_event.ev_tick   ; AX = Initial tick of the character
  MOV CX, [BX].CHARACTER.ch_event.ev_param

  ; We need to wait for CX * 18.20648 ticks
  MOV DX, CX                                ; Multiply * 2
  SHL DX, 1

  SHL CX, 1                                 ; Multiply * 16
  SHL CX, 1
  SHL CX, 1
  SHL CX, 1

  ADD CX, DX                                ; We add to get the * 18

  ; --- Wait for the number of tick ---
  PUSH ES
  MOV DX, 40h
  MOV ES, DX
  MOV DX, ES:[6Ch]                          ; Get the current tick
  POP ES
  ; --- current - character tick to get the number of tick waited ----
  SUB DX, AX                                ; Subtract the initial tick
  CMP DX, CX                                ; Compare with the number of tick to wait
  ; --- If we have waited enough, unpause the character ---
  JGE @s_unpause
  MOV [BX].CHARACTER.ch_event.ev_state, 1   ; TODO: magic number
  JMP @s_return

@s_unpause:
  MOV [BX].CHARACTER.ch_event.ev_state, 0   ; TODO: magic number

@s_return:
  RESTORE_REGS
  RET
EV_PAUSE ENDP
