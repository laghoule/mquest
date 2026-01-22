;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

MOVE_MIA_RIGHT PROC
  CALL RENDER_RESTORE_BACKGROUNG

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 15
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 15
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmr_collision

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 5
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 15
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmr_collision

  MOV AL, pending_tick
  XOR AH, AH
  ADD mia_pos_x, AX

@mmr_collision:
  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_right
  MOV AL, mia_r_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_r_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

  RET
MOVE_MIA_RIGHT ENDP

MOVE_MIA_LEFT PROC
  CALL RENDER_RESTORE_BACKGROUNG

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 1
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 15
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mml_collision

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 10
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 15
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mml_collision

  MOV AL, pending_tick
  XOR AH, AH
  SUB mia_pos_x, AX

@mml_collision:

  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_left
  MOV AL, mia_l_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_l_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------
  RET
MOVE_MIA_LEFT ENDP

MOVE_MIA_UP PROC
  CALL RENDER_RESTORE_BACKGROUNG

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 12
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 12
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmu_collision

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 5
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 12
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmu_collision

  MOV AL, pending_tick
  XOR AH, AH
  SUB mia_pos_y, AX

@mmu_collision:

  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_up
  MOV AL, mia_u_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_u_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

  RET
MOVE_MIA_UP ENDP

MOVE_MIA_DOWN PROC
  CALL RENDER_RESTORE_BACKGROUNG

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 5
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 16
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmd_collision

  MOV AX, mia_pos_x
  MOV pos_x, AX
  ADD pos_x, 12
  MOV AX, mia_pos_y
  MOV pos_y, AX
  ADD pos_y, 16
  CALL CHECK_COLLISION
  CMP AL, 1
  JE @mmd_collision

  MOV AL, pending_tick
  XOR AH, AH
  ADD mia_pos_y, AX

@mmd_collision:

  ; -- TODO: not optimal, but easier for now ---
  MOV curr_sprite_table, OFFSET mia_sprites_table_down
  MOV AL, mia_d_anim_state
  MOV curr_anim_state, AL
  ; --------------------------------------------

  CALL UPDATE_CARACTER_ANIM_STATE

  ; --- TODO: not optimal, but easier for now ---
  MOV AL, curr_anim_state
  MOV mia_d_anim_state, AL
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX
  ;----------------------------------------------

  RET
MOVE_MIA_DOWN ENDP
