;  Copyright (C) 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;------------------------------------------------------------------------------
; UPDATE_GRANDMA_0_0
; Description: Update grandma character for scene 0,0
; Registers: AX, BX, CL, DX
; Input: None
; Output: None
; Modified: None
;------------------------------------------------------------------------------
UPDATE_GRANDMA_0_0 PROC
  SAVE_REGS

  ; Load grandma character
  MOV BX, [char_data_table + 2]

  MOV AX, OFFSET PAUSE                          ; Offset of the label of the PAUSE proc
  MOV [BX].CHARACTER.ch_event.ev_addr, AX
  MOV [BX].CHARACTER.ch_event.ev_param, 2
  
  CMP [BX].CHARACTER.ch_event.ev_state, 0       ; If state is 0, we jump to @@
  JZ @F

  MOV AX, 1                                     ; Grandma character index
  CALL [BX].CHARACTER.ch_event.ev_addr          ; State is not 0, so we call the pause event
  JMP @ug_skip

@@:
  ; If not in the current scene, we dont render
  MOV AX, current_scene_addr
  CMP [BX].CHARACTER.ch_scene_addr, AX
  JNE @ug_skip

  ; If no game tick change, skip
  MOV AL, game_tick
  CMP last_grandma_tick, AL
  JE @ug_skip

  MOV last_grandma_tick, AL                     ; Save the last tick for grandma

  ; Only update every 4 ticks
  MOV AL, game_tick
  TEST AL, 03h                                  ; Mask with 00000011b
  JNZ @ug_skip

  ; if grandma x loc < 260 then jump to move right
  CMP [BX].CHARACTER.ch_loc.lo_x, 260
  JL @ug_move_right

  ; if grandma x loc > 290 then jump to move left
  CMP [BX].CHARACTER.ch_loc.lo_x, 290
  JG @ug_move_left

  ; Continue in the current direcction
  XOR DH, DH
  MOV DL, [BX].CHARACTER.ch_dir                 ; DX is the direction in MOVE_CHAR
  JMP @ug_move                                  ; Jump to the MOVE_CHAR call

@ug_move_right:
  MOV DX, RIGHT_DIR                             ; DX is the direction in MOVE_CHAR
  JMP @ug_move                                  ; Jump to the MOVE_CHAR call

@ug_move_left:
  MOV DX, LEFT_DIR                              ; DX is the direction in MOVE_CHAR

@ug_move:
  MOV CL, delta_tick                            ; Use delta_tick as the speed
  MOV AX, 1                                     ; AX is the character index in MOVE_CHAR (1 = grandma) | TODO: remove magic number
  CALL UPDATE_CHAR_TICK
  CALL MOVE_CHAR
  RENDER_CHARACTER

@ug_skip:
  RESTORE_REGS
  RET
UPDATE_GRANDMA_0_0 ENDP

;------------------------------------------------------------------------------
; UPDATE_CHAR_TICK
; Description: Updates the tick of a character
; Registers: AX, BX, ES
; Input: AX = character index
; Output: None
; Modified: [BX].CHARACTER.ch_event.ev_tick
;------------------------------------------------------------------------------
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
