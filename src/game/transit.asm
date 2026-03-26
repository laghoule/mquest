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

  ; Going north direction
  CMP [BX].CHARACTER.ch_dir, UP_DIR
  JE @cs_north_boundery_check

  ; Going south direction
  CMP [BX].CHARACTER.ch_dir, DOWN_DIR
  JE @cs_south_boundery_check

  ; Going east direction
  CMP [BX].CHARACTER.ch_dir, RIGHT_DIR
  JE @cs_east_boundery_check

  ; Going west direction
  CMP [BX].CHARACTER.ch_dir, LEFT_DIR
  JE @cs_west_boundery_check

  ; No direction, we should not get here
  JMP @cs_no_transition

  ; North scene boundery check
@cs_north_boundery_check:
  CMP [BX].CHARACTER.ch_y, LIMIT_NORTH      ; Check if the player is on the north limit
  JA @cs_no_transition                      ; If not, no transition

  PUSH BX                                   ; Save BX mia_data
  MOV BX, [BX].CHARACTER.ch_scene_addr      ; Load the scene address
  MOV SI, [BX].SCENE.sc_north_addr          ; Load the north scene address
  POP BX
  CMP SI, SCENE_EDGE                        ; Check if the north scene is an edge
  JE @cs_no_transition                      ; If it is, no transition

  XOR CX, CX                                ; CX = 0 for y transition
  MOV DX, LIMIT_SOUTH                       ; DX = south limit for y transition
  JMP @cs_load_scene_transition             ; Jump to scene transition

  ; South scene boundery check
@cs_south_boundery_check:
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
  JMP @cs_load_scene_transition             ; Jump to scene transition

  ; East boundery check
@cs_east_boundery_check:
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
  JMP @cs_load_scene_transition             ; Jump to scene transition

  ; West boundery check
@cs_west_boundery_check:
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

  ; Load scene transition
@cs_load_scene_transition:
  PUSH BX
  MOV BX, [SI].SCENE.sc_map_buffer_addr     ; Load the map buffer address
  MOV map_buffer_addr, BX                   ; Set the map buffer address
  POP BX

  TEST CX, 1                                ; Check if it's an x transition
  JCXZ @cs_check_and_update_y_transition    ; If not, it's a y transition
  JMP @cs_check_and_update_x_transition     ; If it is, it's an x transition

  ; x transition
@cs_check_and_update_x_transition:
  PUSH DX
  XOR AX, AX
  MOV CX, DX                                ; CX = pos_x
  MOV DX, [BX].CHARACTER.ch_y               ; DX = pos_y
  CALL CHECK_HITBOX_COLLISION               ; Check if there is a collision
  POP DX
  JC @cs_restore_scene                      ; If there is a collision, restore the scene and return

  MOV [BX].CHARACTER.ch_x, DX               ; Set the x position in the character structure
  MOV [BX].CHARACTER.ch_scene_addr, SI      ; Set the scene address in the character structure
  JMP @cs_draw_transition                   ; Draw the transition

  ; y transition
@cs_check_and_update_y_transition:
  XOR AX, AX
  MOV CX, [BX].CHARACTER.ch_x               ; CX = pos_x, DX is already pos_y
  CALL CHECK_HITBOX_COLLISION               ; Check if there is a collision
  JC @cs_restore_scene                      ; If there is a collision, restore the scene and return

  MOV [BX].CHARACTER.ch_y, DX               ; Set the y position in the character structure
  MOV [BX].CHARACTER.ch_scene_addr, SI      ; Set the scene address in the character structure
  JMP @cs_draw_transition                   ; Draw the transition

@cs_restore_scene:
  MOV BX, OFFSET mia_data

  MOV BX, [BX].CHARACTER.ch_scene_addr      ; Load the scene address
  MOV SI, [BX].SCENE.sc_map_buffer_addr     ; Load the west scene address

  MOV map_buffer_addr, SI                   ; Set the new map buffer address
  JMP @cs_no_transition

  ; Draw the transition
@cs_draw_transition:
  MOV AX, map_buffer_addr                   ; Load the map buffer address in AX, needed for DRAW_SCENE
  CALL DRAW_SCENE                           ; Draw the scene

  XOR AX, AX                                ; AX = 0 for mia character
  RENDER_CHARACTER                          ; Render the character

  ; No transition needed
@cs_no_transition:
  RESTORE_REGS
  RET
CHECK_SCENE_TRANSITION ENDP
