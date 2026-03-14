;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------
; CHECK_SCENE_TRANSITION
; Description: Check if the player is on a scene transition direction
; Input:
; Output:
; Modifed: curr_scne
;----------------------------------------------------------------
CHECK_SCENE_TRANSITION PROC
  SAVE_REGS

  MOV BX, OFFSET mia_data
  MOV AX, [BX].CHARACTER.ch_y           ; Mia y position
  MOV DX, [BX].CHARACTER.ch_x           ; Mia x position

  ; South check
  CMP [BX].CHARACTER.ch_y, LIMIT_SOUTH
  JNA @cs_no_transition

  PUSH BX
  MOV BX, [BX].CHARACTER.ch_scene_addr
  MOV SI, [BX].SCENE.sc_south_addr
  POP BX
  CMP SI, 0
  JE @cs_no_transition

  PUSH BX
  MOV BX, [SI].SCENE.sc_map_buffer_addr
  MOV curr_scne, BX
  POP BX
  MOV [BX].CHARACTER.ch_y, 0

@cs_transition:
  MOV AX, curr_scne
  CALL DRAW_SCENE

  XOR AX, AX
  RENDER_CHARACTER

@cs_no_transition:
  RESTORE_REGS
  RET
CHECK_SCENE_TRANSITION ENDP
