MOVE_MIA_RIGHT PROC
  CALL RENDER_RESTORE_BACKGROUNG

  MOV AL, pending_tick
  XOR AH, AH
  ADD mia_pos_x, AX

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

  MOV AL, pending_tick
  XOR AH, AH
  SUB mia_pos_x, AX

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

  MOV AL, pending_tick
  XOR AH, AH
  SUB mia_pos_y, AX

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

  MOV AL, pending_tick
  XOR AH, AH
  ADD mia_pos_y, AX

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
