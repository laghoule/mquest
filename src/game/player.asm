;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;---------------------------------------------------------
; MOVE_CHAR
; Description: Handles movement and collision for all directions
; Input:  AX: char_index, DX: direction
; Output: None
; Modify: Character data table of char_index
;         pos_x, pos_y
;---------------------------------------------------------
MOVE_CHAR PROC
  SAVE_REGS

  ; Calcul -> Test -> Action

  MOV char_index, AX                        ; We save the character index for later use

  SHL AX, 1                                 ; Conversion characted index -> offset (DW)
  MOV BX, AX

  MOV BX, [char_data_table + BX]            ; BX = Address of the character data structure

  XOR DH, DH                                ; ch_dir is a byte, so we clear DH
  MOV [BX].CHARACTER.ch_dir, DL             ; Set character direction from input DX

  ;Resolve the direction indirection: Master table -> direction data block
  MOV SI, [BX].CHARACTER.ch_dir_table_addr  ; SI = Address of the 4-directions table
  SHL DX, 1                                 ; Conversion direction index -> offset (DW)
  ADD SI, DX                                ; SI = Address of the direction data
  MOV SI, [SI]                              ; Dereference the direction data (hitbox, sprites, ...)

  MOV AX, char_index
  CALL RENDER_RESTORE_BACKGROUND            ; We restore the background

  ; We retrieve the x,y coordinates of the character
  MOV CX, [BX].CHARACTER.ch_x
  MOV DX, [BX].CHARACTER.ch_y

  ; Load pending_tick in AL
  XOR AH, AH
  MOV AL, pending_tick

  ; Check for which direction to go
  CMP [BX].CHARACTER.ch_dir, RIGHT_DIR      ; Check for right
  JE @mm_calc_right

  CMP [BX].CHARACTER.ch_dir, LEFT_DIR       ; Check for left
  JE @mm_calc_left

  CMP [BX].CHARACTER.ch_dir, UP_DIR         ; Check for up
  JE @mm_calc_up

  ; If we are here, it's down direction
  ADD DX, AX                                ; Add pending_tick to Y position
  JMP @mm_collision_detection               ; Goto collision detection

@mm_calc_right:
  ADD CX, AX                                ; Add pending_tick to X position
  JMP @mm_collision_detection               ; Goto collision detection

@mm_calc_left:
  SUB CX, AX                                ; Subtract pending_tick from X position
  JMP @mm_collision_detection               ; Goto collision detection

@mm_calc_up:
  SUB DX, AX                                ; Subtract pending_tick from Y position

@mm_collision_detection:
  ; Hitbox 1 position X
  XOR AX, AX
  MOV AL, [SI + 2]                          ; Load hitbox P1X
  ADD AX, CX                                ; Add hitbox P1X to X position
  MOV pos_x, AX                             ; Save X position

  ; Hitbox 1 position Y
  XOR AX, AX
  MOV AL, [SI + 3]                          ; Load hitbox P1Y
  ADD AX, DX                                ; Add hitbox P1Y to Y position
  MOV pos_y, AX                             ; Save Y position

  ; TODO: get rid of pos_x, pos_y
  CALL CHECK_COLLISION                      ; Check for collition via pos_x, pos_y
  JC @mmg_skip_to_anim                      ; Goto skip to animation if carry flag set

  ; Hitbox 2 position X
  XOR AX, AX
  MOV AL, [SI + 4]                          ; Load hitbox P2X
  ADD AX, CX                                ; Add hitbox P2X to X position
  MOV pos_x, AX                             ; Save X position

  ; Hitbox 2 position Y
  XOR AX, AX
  MOV AL, [SI + 5]                          ; Load hitbox P2Y
  ADD AX, DX                                ; Add hitbox P2Y to Y position
  MOV pos_y, AX                             ; Save Y position

  ; TODO: get rid of pos_x, pos_y
  CALL CHECK_COLLISION                      ; Check for collition via pos_x, pos_y
  JC @mmg_skip_to_anim                      ; Goto skip to animation if carry flag set

  ; No collision detected
  MOV [BX].CHARACTER.ch_x, CX               ; We save the x,y in the character struct
  MOV [BX].CHARACTER.ch_y, DX

@mmg_skip_to_anim:
  MOV AX, char_index
  CALL UPDATE_CHARACTER_ANIM_INDEX          ; Update animation index

  RESTORE_REGS
  RET
MOVE_CHAR ENDP
