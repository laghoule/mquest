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

  ; North direction
  CMP [BX].CHARACTER.ch_dir, UP_DIR
  JE @cs_north_check

  ; South direction
  CMP [BX].CHARACTER.ch_dir, DOWN_DIR
  JE @cs_south_check

  ; East direction
  CMP [BX].CHARACTER.ch_dir, RIGHT_DIR
  JE @cs_east_check

  ; West direction
  JMP @cs_west_check

  ; North check
@cs_north_check:
  CMP [BX].CHARACTER.ch_y, LIMIT_NORTH
  JA @cs_no_transition

  PUSH BX
  MOV BX, [BX].CHARACTER.ch_scene_addr
  MOV SI, [BX].SCENE.sc_north_addr
  POP BX
  CMP SI, 0
  JE @cs_south_check

  PUSH BX
  MOV BX, [SI].SCENE.sc_map_buffer_addr
  MOV curr_scne, BX
  POP BX
  MOV [BX].CHARACTER.ch_y, LIMIT_SOUTH
  MOV [BX].CHARACTER.ch_scene_addr, SI
  JMP @cs_transition

  ; South check
@cs_south_check:
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
  MOV [BX].CHARACTER.ch_y, LIMIT_NORTH
  MOV [BX].CHARACTER.ch_scene_addr, SI
  JMP @cs_transition

  ; East check
@cs_east_check:
  CMP [BX].CHARACTER.ch_x, LIMIT_EAST
  JNA @cs_no_transition

  PUSH BX
  MOV BX, [BX].CHARACTER.ch_scene_addr
  MOV SI, [BX].SCENE.sc_east_addr
  POP BX
  CMP SI, 0
  JE @cs_no_transition

  PUSH BX
  MOV BX, [SI].SCENE.sc_map_buffer_addr
  MOV curr_scne, BX
  POP BX
  MOV [BX].CHARACTER.ch_x, LIMIT_WEST
  MOV [BX].CHARACTER.ch_scene_addr, SI
  JMP @cs_transition

  ; West check
@cs_west_check:
  CMP [BX].CHARACTER.ch_x, LIMIT_WEST
  JA @cs_no_transition

  PUSH BX
  MOV BX, [BX].CHARACTER.ch_scene_addr
  MOV SI, [BX].SCENE.sc_west_addr
  POP BX
  CMP SI, 0
  JE @cs_no_transition

  PUSH BX
  MOV BX, [SI].SCENE.sc_map_buffer_addr
  MOV curr_scne, BX
  POP BX
  MOV [BX].CHARACTER.ch_x, LIMIT_EAST
  MOV [BX].CHARACTER.ch_scene_addr, SI

@cs_transition:
  MOV AX, curr_scne
  CALL DRAW_SCENE

  XOR AX, AX
  RENDER_CHARACTER

@cs_no_transition:
  RESTORE_REGS
  RET
CHECK_SCENE_TRANSITION ENDP
