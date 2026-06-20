;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;-----------------------------------------------
; UPDATE_NPC_ACTION
; Description: Update all NPC characters actions
; Registers: AX, BX, CX, DX
; Input: None
; Output: None
; Modified:
;-----------------------------------------------
UPDATE_NPC_ACTION PROC
  SAVE_REGS

  MOV CX, 1                             ; NPC characters index begin at 1

 @UN_NPCS_LOOP:
  MOV AX, CX                            ; AX = character index
  SHL AX, 1                             ; AX = character offset (DW)
  MOV BX, AX                            ; BX = character offset (DW)
  MOV BX, [char_data_table + BX]        ; BX = character data structure address

  MOV DX, current_scene_addr            ; DX = current scene address
  CMP [BX].CHARACTER.ch_scene_addr, DX  ; Compare character scene address with current scene address
  JNE @F                                ; Jump if character scene address does not match current scene address

  CALL [BX].CHARACTER.ch_action_addr    ; Call character action address

@@:
  INC CX                                ; Increment (next) character index
  TEST CX, NPC_TOTALS                   ; Test if character index is greater than or equal to NPC total
  JZ @UN_NPCS_LOOP                      ; Jump if character index is greater than or equal to NPC total

  RESTORE_REGS
  RET
 UPDATE_NPC_ACTION ENDP

;---------------------------------------------
; UPDATE_CHAR_TICK
; Description: Updates the tick of a character
; Registers: AX, BX, ES
; Input: AX = character index
; Output: None
; Modified: [BX].CHARACTER.ch_event.ev_tick
;---------------------------------------------
UPDATE_CHAR_TICK PROC
  SAVE_REGS

  SHL AX, 1                                     ; Conversion characted index -> offset (DW)
  MOV BX, AX
  MOV BX, [char_data_table + BX]                ; BX = Address of the character data structure

  PUSH ES
  MOV AX, 40h
  MOV ES, AX
  MOV AX, ES:[6Ch]
  MOV [BX].CHARACTER.ch_event.ev_tick, AX       ; Set the tick to the current tick for the character
  POP ES

  RESTORE_REGS
  RET
UPDATE_CHAR_TICK ENDP
