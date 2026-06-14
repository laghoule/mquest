;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;------------------------------------------------------------------------------
; UPDATE_CHARACTER_ANIM_INDEX
; Description : Update the sprite of the character based on the animation index
; Registers: AX, BX, CL
; Input:AX = char_index
; Output: None
; Modified: Character data struct
;------------------------------------------------------------------------------
UPDATE_CHARACTER_ANIM_INDEX PROC
  SAVE_REGS

  SHL AX, 1                           ; Conversion index -> offset (DW)
  MOV BX, AX                          ; Move the offset into BX

  MOV BX, [char_data_table + BX]      ; BX = character data struct

  INC [BX].CHARACTER.ch_anim_cnt
  MOV CL, [BX].CHARACTER.ch_anim_cnt
  CMP [BX].CHARACTER.ch_anim_spd, CL
  JNE @ucai_skip

  MOV [BX].CHARACTER.ch_anim_cnt, 0

  MOV AL, [BX].CHARACTER.ch_anim_idx
  ADD AL, 1
  CMP AL, 3
  JNE @F
  XOR AL, AL
@@:
  MOV [BX].CHARACTER.ch_anim_idx, AL  ; Save the animation index in the character struct

@ucai_skip:
  RESTORE_REGS
  RET
UPDATE_CHARACTER_ANIM_INDEX ENDP
