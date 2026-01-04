; -----------------------------------------------
; SYNC_TICKS
; Count the number of ticks since the last check
; INPUT: game_tick
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
  JZ @no_change       ; If the result is zero, jump to @no_change

  MOV game_tick, AH   ; Update the game tick with the current tick count
  MOV CL, AL          ; CL = Number of tick missed
  XOR CH, CH          ; CX = Delta
  POP AX              ; Restore AX
  RET

@no_change:
  POP AX              ; Restore AX
  XOR CX, CX          ; Clear CX
  RET

SYNC_TICKS ENDP
