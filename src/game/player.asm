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

  ; Calcul -> Test -> Action

  ; Definition of mia_dir_table and mia_dir-* in file assets/gfx/chars/mia.inc
  MOV BX, AX                          ; Move the index in BX
  SHL BX, 1                           ; Multiply by 2, to get the right index (word = 2)
  MOV SI, [mia_dir_table + BX]        ; Mia direction information in SI

  CALL RENDER_RESTORE_BACKGROUNG      ; We restore the background

  MOV CX, mia_pos_x                   ; CX : X position
  MOV DX, mia_pos_y                   ; DX : Y position
  MOV AL, pending_tick                ; Load pending_tick in AL
  XOR AH, AH

  MOV BL, [SI + 8]                    ; Get direction in the sprite table

  CMP BL, RIGHT_DIR                   ; If right direction
  JE @mm_calc_right                   ; Goto right calculation

  CMP BL, LEFT_DIR                    ; If left direction
  JE @mm_calc_left                    ; Goto left calculation

  CMP BL, UP_DIR                      ; If up direction
  JE @mm_calc_up                      ; Goto up calculation

  ; The down direction is the only one left
  ; The calcul for down
  ADD DX, AX                          ; Add pending_tick to Y position
  JMP @mm_collision_detection         ; Goto collision detection

@mm_calc_right:
  ADD CX, AX                          ; Add pending_tick to X position
  JMP @mm_collision_detection         ; Goto collision detection

@mm_calc_left:
  SUB CX, AX                          ; Subtract pending_tick from X position
  JMP @mm_collision_detection         ; Goto collision detection

@mm_calc_up:
  SUB DX, AX                          ; Subtract pending_tick from Y position

@mm_collision_detection:
  ; Hitbox 1 position X
  XOR AX, AX
  MOV AL, [SI + 4]                    ; Load hitbox P1X
  ADD AX, CX                          ; Add hitbox P1X to X position
  MOV pos_x, AX                       ; Save X position

  ; Hitbox 1 position Y
  XOR AX, AX
  MOV AL, [SI + 5]                    ; Load hitbox P1Y
  ADD AX, DX                          ; Add hitbox P1Y to Y position
  MOV pos_y, AX                       ; Save Y position

  CALL CHECK_COLLISION                ; Check for collition via pos_x, pos_y
  CMP AL, 1                           ; If collision detected
  JE @mmg_skip_to_anim                ; Goto skip to animation

  ; Hitbox 2 position X
  XOR AX, AX
  MOV AL, [SI + 6]                    ; Load hitbox P2X
  ADD AX, CX                          ; Add hitbox P2X to X position
  MOV pos_x, AX                       ; Save X position

  ; Hitbox 2 position Y
  XOR AX, AX
  MOV AL, [SI + 7]                    ; Load hitbox P2Y
  ADD AX, DX                          ; Add hitbox P2Y to Y position
  MOV pos_y, AX                       ; Save Y position

  CALL CHECK_COLLISION                ; Check for collition via pos_x, pos_y
  CMP AL, 1                           ; If collision detected
  JE @mmg_skip_to_anim                ; Goto skip to animation

  ; No collision detected
  MOV mia_pos_x, CX                   ; Save X position
  MOV mia_pos_y, DX                   ; Save Y position

@mmg_skip_to_anim:
  MOV AX, [SI]
  MOV curr_sprite_table, AX           ; Load the sprite table
  MOV BX, [SI + 2]                    ; Offset of mia_anim_state
  MOV AL, [BX]                        ; Data of the anim_state in AL
  MOV curr_anim_state, AL             ; Save in curr_anim_state

  CALL UPDATE_CARACTER_ANIM_STATE     ; Update animation state

  MOV AL, curr_anim_state             ; Save the anim_state in AL
  MOV BX, [SI + 2]                    ; Offset of mia_anim_state
  MOV [BX], AL                        ; Save the anim_state in the memory location of mia_dir_table
  MOV AX, curr_sprite
  MOV mia_curr_sprite, AX             ; Save the current sprite

  RESTORE_REGS
  RET
MOVE_MIA ENDP
