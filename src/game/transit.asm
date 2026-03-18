;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------
; CHECK_SCENE_TRANSITION
; Description: Check if the player is on a scene transition direction
; Register: AX, BX, CX, DX, SI
; Input:
;   Implicit: mia_data
; Output:
; Modifed: curr_scne
;----------------------------------------------------------------
CHECK_SCENE_TRANSITION PROC
  SAVE_REGS

  MOV BX, OFFSET mia_data                   ; Only mia supported

  ; Going borth direction
  CMP [BX].CHARACTER.ch_dir, UP_DIR
  JE @cs_north_check

  ; Going south direction
  CMP [BX].CHARACTER.ch_dir, DOWN_DIR
  JE @cs_south_check

  ; Going east direction
  CMP [BX].CHARACTER.ch_dir, RIGHT_DIR
  JE @cs_east_check

  ; Going west direction
  JMP @cs_west_check

  ; North scene check
@cs_north_check:
  CMP [BX].CHARACTER.ch_y, LIMIT_NORTH      ; Check if the player is on the north limit
  JA @cs_no_transition                      ; If not, no transition

  PUSH BX                                   ; Save BX mia_data
  MOV BX, [BX].CHARACTER.ch_scene_addr      ; Load the scene address
  MOV SI, [BX].SCENE.sc_north_addr          ; Load the north scene address
  POP BX
  CMP SI, SCENE_EDGE                        ; Check if the north scene is an edge
  JE @cs_no_transition                      ; If it is, no transition

  XOR CX, CX                                ; CX  = 0 for y transition
  MOV DX, LIMIT_SOUTH                       ; DX = south limit for y transition
  JMP @cs_scne_transition                   ; Jump to scene transition

  ; South scene check
@cs_south_check:
  CMP [BX].CHARACTER.ch_y, LIMIT_SOUTH      ; Check if the player is on the south limit
  JNA @cs_no_transition                     ; If not, no transition

  PUSH BX
  MOV BX, [BX].CHARACTER.ch_scene_addr      ; Load the scene address
  MOV SI, [BX].SCENE.sc_south_addr          ; Load the south scene address
  POP BX
  CMP SI, SCENE_EDGE                        ; Check if the south scene is an edge
  JE @cs_no_transition                      ; If it is, no transition

  XOR CX, CX                                ; CX = 0 for y transition
  MOV DX,LIMIT_NORTH                        ; DX = north limit for y transition
  JMP @cs_scne_transition                   ; Jump to scene transition


  ; East check
@cs_east_check:
  CMP [BX].CHARACTER.ch_x, LIMIT_EAST       ; Check if the player is on the east limit
  JNA @cs_no_transition                     ; If not, no transition

  PUSH BX
  MOV BX, [BX].CHARACTER.ch_scene_addr      ; Load the scene address
  MOV SI, [BX].SCENE.sc_east_addr           ; Load the east scene address
  POP BX
  CMP SI, SCENE_EDGE                        ; Check if the east scene is an edge
  JE @cs_no_transition                      ; If it is, no transition

  MOV CX, 1                                 ; CX = 1 for x transition
  MOV DX, LIMIT_WEST                        ; DX = west limit for x transition
  JMP @cs_scne_transition                   ; Jump to scene transition

  ; West check
@cs_west_check:
  CMP [BX].CHARACTER.ch_x, LIMIT_WEST       ; Check if the player is on the west limit
  JA @cs_no_transition                      ; If not, no transition

  PUSH BX
  MOV BX, [BX].CHARACTER.ch_scene_addr      ; Load the scene address
  MOV SI, [BX].SCENE.sc_west_addr           ; Load the west scene address
  POP BX
  CMP SI, SCENE_EDGE                        ; Check if the west scene is an edge
  JE @cs_no_transition                      ; If it is, no transition

  MOV CX, 1                                 ; CX = 1 for x transition
  MOV DX, LIMIT_EAST                        ; DX = east limit for x transition

  ; Scene transition
@cs_scne_transition:
  PUSH BX
  MOV BX, [SI].SCENE.sc_map_buffer_addr     ; Load the map buffer address
  MOV curr_scne, BX                         ; Set the current scene
  POP BX

  TEST CX, 1                                ; Check if it's an x transition
  JCXZ @cs_y_transition                     ; If not, it's a y transition
  JMP @cs_x_transition                      ; If it is, it's an x transition

  ; x transition
@cs_x_transition:
  MOV [BX].CHARACTER.ch_x, DX               ; Set the x position in the character structure
  MOV [BX].CHARACTER.ch_scene_addr, SI      ; Set the scene address in the character structure
  JMP @cs_draw_transition                   ; Draw the transition

  ; y transition
@cs_y_transition:
  MOV [BX].CHARACTER.ch_y, DX               ; Set the y position in the character structure
  MOV [BX].CHARACTER.ch_scene_addr, SI      ; Set the scene address in the character structure

  ; Draw the transition
@cs_draw_transition:
  MOV AX, curr_scne                         ; Load the current scene address in AX, needed for DRAW_SCENE
  CALL DRAW_SCENE                           ; Draw the scene

  XOR AX, AX                                ; AX = 0 for mia character
  RENDER_CHARACTER                          ; Render the character

  ; No transition needed
@cs_no_transition:
  RESTORE_REGS
  RET
CHECK_SCENE_TRANSITION ENDP
