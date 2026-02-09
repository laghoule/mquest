;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;---------------------------------------------------------
; MOVE_CHAR
; Description: Handles movement and collision for all directions
; Input:  AX: char_index, DX: direction
; Output: None
;---------------------------------------------------------
MOVE_CHAR PROC
  SAVE_REGS

  ; Calcul -> Test -> Action

  MOV char_index, AX

  SHL AX, 1                           ; Multiply by 2, to get the right index (word = 2)
  MOV BX, AX                          ; Move the index in BX

  MOV BX, [char_data_table + BX]

  XOR DH, DH
  MOV [BX].CHARACTER.ch_dir, DL

  MOV SI, [BX].CHARACTER.ch_dir_table_ptr
  SHL DX, 1
  ADD SI, DX
  MOV SI, [SI]                          ; Char direction information in SI

  MOV AX, char_index
  CALL RENDER_RESTORE_BACKGROUND      ; We restore the background

  MOV CX, [BX].CHARACTER.ch_x         ; CX : X position
  MOV DX, [BX].CHARACTER.ch_y         ; DX : Y position
  XOR AH, AH
  MOV AL, pending_tick                ; Load pending_tick in AL

  CMP [BX].CHARACTER.ch_dir, RIGHT_DIR ; If right direction
  JE @mm_calc_right                   ; Goto right calculation

  CMP [BX].CHARACTER.ch_dir, LEFT_DIR                    ; If left direction
  JE @mm_calc_left                    ; Goto left calculation

  CMP [BX].CHARACTER.ch_dir, UP_DIR   ; If up direction
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

  ; TODO: get rid of pos_x, pos_y
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

  ; TODO: get rid of pos_x, pos_y
  CALL CHECK_COLLISION                ; Check for collition via pos_x, pos_y
  CMP AL, 1                           ; If collision detected
  JE @mmg_skip_to_anim                ; Goto skip to animation

  ; No collision detected
  MOV [BX].CHARACTER.ch_x, CX         ; Save X position
  MOV [BX].CHARACTER.ch_y, DX         ; Save Y position

@mmg_skip_to_anim:
  MOV AX, char_index
  CALL UPDATE_CHARACTER_ANIM_STATE    ; Update animation state

  RESTORE_REGS
  RET
MOVE_CHAR ENDP
