;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

; ------------------------------------------
; INIT_TICKS
; Initialize the game tick and pending tick
; INPUT: game_tick, pending_tick
; OUTPUT: game_tick, pending_tick
; ------------------------------------------
INIT_TICKS PROC
  SAVE_REGS
  PUSH ES

  MOV AX, 40h         ; Load the segment of the BIOS data area into AX
  MOV ES, AX          ; Load the segment of the BIOS data area into ES
  MOV AL, ES:[6Ch]    ; Load the current tick count into AL

  MOV game_tick, AL   ; Save the current tick count into game_tick
  MOV pending_tick, 0 ; Initialize pending_tick to 0

  POP ES
  RESTORE_REGS
  RET
INIT_TICKS ENDP

; -----------------------------------------------
; SYNC_TICKS
; Count the number of ticks since the last check
; INPUT:  game_tick
; OUTPUT: CX (number of tick missed)
; -----------------------------------------------
SYNC_TICKS PROC
  PUSH AX             ; Save AX
  PUSH ES             ; Save the original segment register

  MOV AX, 40h         ; Load the segment of the BIOS data area into AX
  MOV ES, AX          ; Load the segment of the BIOS data area into ES
  MOV AL, ES:[6Ch]    ; Load the current tick count into AL
  POP ES              ; Restore the original segment register

  MOV AH, AL          ; Save the current tick count into AH
  SUB AL, game_tick   ; Subtract the game tick from the current tick count
  JZ @sc_no_change       ; If the result is zero, jump to @no_change

  MOV game_tick, AH   ; Update the game tick with the current tick count
  MOV CL, AL          ; CL = Number of tick missed
  XOR CH, CH          ; CX = Delta
  POP AX              ; Restore AX
  RET

@sc_no_change:
  POP AX              ; Restore AX
  XOR CX, CX          ; Clear CX
  RET

SYNC_TICKS ENDP
