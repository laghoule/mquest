;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;---------------------------------------------------------
; MOVE_MIA
; Description: Handles movement and collision for all directions
; Input:  AX (index of mia_dir_table)
; Output: None
;---------------------------------------------------------
MOVE_MIA PROC
  SAVE_REGS

  MOV BX, AX
  SHL BX, 1 ; Multiply by 2, because it's a word TODO: pas sur de comprendre, droite ca devrait pas etre 2??
  MOV SI, [mia_dir_table + BX]

  CALL RENDER_RESTORE_BACKGROUNG

  ; collision detection
  XOR AX, AX
  MOV AL, [SI + 4]
  ADD AX, mia_pos_x ; P1X
  MOV pos_x, AX

  XOR AX, AX
  MOV AL, [SI + 5]
  ADD AX, mia_pos_y ; P1Y
  MOV pos_y, AX

  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmg_to_anim

  XOR AX, AX
  MOV AL, [SI + 6]
  ADD AX, mia_pos_x ; P2X
  MOV pos_x, AX

  XOR AX, AX
  MOV AL, [SI + 7]
  ADD AX, mia_pos_y ; P2Y
  MOV pos_y, AX

  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmg_to_anim

  MOV AL, pending_tick
  XOR AH, AH

  XOR CX, CX
  MOV CL, [SI + 8]

  CMP CX, RIGHT_DIR
  JE @mmg_right

  CMP CX, LEFT_DIR
  JE @mmg_left

  CMP CX, UP_DIR
  JE @mmg_up

  ; Down direction
  ADD mia_pos_y, AX
  JMP @mmg_to_anim

@mmg_right:
  ADD mia_pos_x, AX
  JMP @mmg_to_anim

@mmg_left:
  SUB mia_pos_x, AX
  JMP @mmg_to_anim

@mmg_up:
  SUB mia_pos_y, AX

@mmg_to_anim:
  ; -- TODO: not optimal, but easier for now ---
  MOV AX, [SI]
  MOV curr_sprite_table, AX
  MOV BX, [SI + 2] ; 2 because its a  word
  MOV AL, [BX]
  MOV curr_anim_state, AL ; AniState
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV BX, [SI + 2] ; 2 because its a word
  MOV [BX], AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

  RESTORE_REGS
  RET
MOVE_MIA ENDP
