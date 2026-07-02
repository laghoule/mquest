;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;---------------------------------------------------------------
; CHECK_TILE_COLLISION
; Description: Check if collision with tile at position (AX, BX)
; Register: AX, BX, CX, DX
; Input: AX = pos_x, BX = pos_y
; Output: Carry flag set if collision, clear otherwise
; Modifed: TX, pos_x, pos_y, Carry flag
; Notes:
;  1. LocalX = pos_x AND 15  |  LocalY = WorldY AND 15
;
;  2. Boundary Check (16x16 Tile) :
;     0,0 +-----------------+ 15,0
;         |  hb_x1,hb_y1    |
;         |    +-----+      |
;         |    |  *  |      | <-- * = (LocalX, LocalY)
;         |    +-----+      |
;         |        hb_x2,hb_y2
;    0,15 +-----------------+ 15,15
;
;  3. COLLISION IF:
;     (FineX >= hb_x1) AND (FineX <= hb_x2) AND
;     (FineY >= hb_y1) AND (FineY <= hb_y2)
;---------------------------------------------------------------
CHECK_TILE_COLLISION PROC
  SAVE_REGS
  CLC                         ; Clear carry flag

  MOV pos_x, AX
  MOV pos_y, BX

  ; Get position offset for tile collision check (AH = FineX, AL = FineY)
  CALL RESOLVE_TILE_FINEOFFSET
  MOV TX, AX

  MOV CX, 2                   ; CX = number of layers to check
  XOR DX, DX                  ; DX = offset of the map (bg = 0)

@ctc_next_layer:
  MOV AX, pos_x
  MOV BX, pos_y
  CALL GET_TILE_PROP          ; We then get the tile properties in AL

  AND AL, MASK_COLLISION      ; Mask out the collision bits

  ; --- Check no collision ---
  CMP AL, COLL_NONE          ; We test if the tile is collidable
  JE @ctc_no_collision       ; Jump if collision detected

  ; --- Check full collision ---
  TEST AL, COLL_FULL
  JNZ @ctc_is_collision

  ; --- Get tile hitbox ---
  CALL RETRIEVE_TILE_HITBOX   ;OUTPUT: AH = hb_x1, AL = hb_x2, BH = hb_y1, BL = hb_y2

  MOV DX, TX                  ; Restore the FineOffset

  ; --- TODO: Review ---
  ; NOT (FineX >= hb_x1) AND (FineX <= hb_x2)
  CMP DH, AH
  JB @ctc_no_collision
  CMP DH, BH
  JA @ctc_no_collision
  ; NOT (FineY >= hb_y1) AND (FineY <= hb_y2)
  CMP DL, BH
  JB @ctc_no_collision
  CMP DL, BL
  JA @ctc_no_collision

  ; --- Collision detected ---
  JMP @ctc_is_collision

@ctc_no_collision:
  MOV DX, MAP_LAYER_SIZE      ; DX = offset of the scene (fg = 1, last part of the map)
  DEC CX
  JNZ @ctc_next_layer

  JMP @ctc_done

@ctc_is_collision:
  STC                         ; Set carry flag for detected collision

@ctc_done:
  RESTORE_REGS
  RET
CHECK_TILE_COLLISION ENDP

;---------------------------------------------------------------------
; RETRIEVE_TILE_HITBOX
; Description: Retrieves the hitbox for a given tile collision bitmask
; Registers: AX, BX,
; Input: AL = Tile collision bits
; Output: AX = Tile hitbox 1 (AH = x, AL = y)
;         BX = Tile hitbox 2 (BH = x, BL = y)
; Modified: None
;---------------------------------------------------------------------
RETRIEVE_TILE_HITBOX PROC
  PUSH CX

  TEST AL, COLL_BOTTOM
  JNZ @rth_bottom

  TEST AL, COLL_TOP
  JNZ @rth_top

  TEST AL, COLL_LEFT
  JNZ @rth_left

  TEST AL, COLL_RIGHT
  JNZ @rth_right

  TEST AL, COLL_CENTER
  JNZ @rth_center

  TEST AL, COLL_BARRIER
  JNZ @rth_barrier

  ; --- No hitbox found ---
  ; Should not happen, but handle it gracefully
  XOR AX, AX
  XOR BX, BX
  JMP @rth_return

@rth_bottom:
  MOV AX, 0 ; idx in tile_hb_table
  JMP @rth_get_hitbox

@rth_top:
  MOV AX, 1 ; idx in tile_hb_table
  JMP @rth_get_hitbox

@rth_left:
  MOV AX, 2 ; idx in tile_hb_table
  JMP @rth_get_hitbox

@rth_right:
  MOV AX, 3 ; idx in tile_hb_table
  JMP @rth_get_hitbox

@rth_center:
  MOV AX, 4 ; idx in tile_hb_table
  JMP @rth_get_hitbox

@rth_barrier:
  MOV AX, 5 ; idx in tile_hb_table

@rth_get_hitbox:
  SHL AX, 1 ; multiply by 2 (hb_1)
  SHL AX, 1 ; multiply by 4 (hb_2)

  MOV BX, AX
  MOV BX, [tile_hb_table + BX]
  MOV AH, [BX].HITBOX.hb_x1
  MOV AL, [BX].HITBOX.hb_y1
  MOV BH, [BX].HITBOX.hb_x2
  MOV BL, [BX].HITBOX.hb_y2

@rth_return:
  POP CX
  RET
RETRIEVE_TILE_HITBOX ENDP

; -------------------------------------------------------------------------------
; CHECK_OBJECT_COLLISION
; Description: Check if a character hitbox collides with object hitbox in the map
; Registers: AX, BX, CX, DX, SI, DI
; Input: AX = Character index, CX = X position, DX = Y position
; Output: Carry flag = 1 if collision detected
; Modified: Carry flag
;--------------------------------------------------------------------------------
CHECK_OBJECT_COLLISION PROC
  SAVE_REGS

  SHL AX, 1                                 ; Character ID * 2 (word)
  MOV BX, AX

  MOV BX, [char_data_table + BX]            ; BX = Address of the character data structure

  ; Get the direction of the character
  XOR AH, AH
  MOV AL, [BX].CHARACTER.ch_dir
  SHL AX, 1

  ;Resolve the direction indirection: Master table -> direction data block
  MOV SI, [BX].CHARACTER.ch_dir_tbl_addr    ; SI = Address of the 4-directions table
  ADD SI, AX                                ; SI = Address of the direction data
  MOV SI, [SI]                              ; Dereference the direction data (hitbox, sprites, ...)
  MOV DI, [SI].CHAR_DIR_DATA.cd_hitbox      ; Dereference the hitbox

  ; Hitbox 1 position X (CX -> AX (X))
  XOR AX, AX
  MOV AL, [DI].HITBOX.hb_x1
  ADD AX, CX                                ; Add hitbox P1X to X position

  ; Hitbox 1 position Y (DX -> BX (Y))
  XOR BX, BX
  MOV BL, [DI].HITBOX.hb_y1
  ADD BX, DX                                ; Add hitbox P1Y to Y position

  CALL CHECK_TILE_COLLISION                 ; Check for collision , carry flag will be set if collision
  JC @chc_return                            ; If collision, return

  ; Hitbox 2 position X (CX -> AX (X))
  XOR AX, AX
  MOV AL, [DI].HITBOX.hb_x2
  ADD AX, CX                                ; Add hitbox P2X to X position

  ; Hitbox 2 position Y (DX -> BX (Y))
  XOR BX, BX
  MOV BL, [DI].HITBOX.hb_y2
  ADD BX, DX                                ; Add hitbox P2Y to Y position

  CALL CHECK_TILE_COLLISION                 ; Check for collition, carry flag will be set if collision

@chc_return:
  RESTORE_REGS
  RET
CHECK_OBJECT_COLLISION ENDP

; ------------------------------------------------------------------------
; CHECK_CHAR_COLLISION
; Description: Check for character collision with other charater
; Registers: AX, BX, CX, DX, SI, DI
; Input: AX = Character ID
; Output: Carry flag set if collision
; Modified: aabb_ch1_left, aabb_ch1_right, aabb_ch1_top, aabb_ch1_bottom
; Notes:
;   Axis-Aligned Bounding Box (AABB) Collision detection:
;
;            (X1, Y1)  [top]
;               +-------------------+
;               |                   |
;        [left] |    Character 1    | [right]
;               |                   |
;               +-------------------+
;                               (X2, Y2)  [bottom]
;
;   No collision if any of these conditions are met:
;   - Box 1 is to the left of Box 2  (aabb_ch1_right  < aabb_ch2_left)
;   - Box 1 is to the right of Box 2 (aabb_ch1_left   > aabb_ch2_right)
;   - Box 1 is above Box 2           (aabb_ch1_bottom < aabb_ch2_top)
;   - Box 1 is below Box 2           (aabb_ch1_top    > aabb_ch2_bottom)
;
;   Otherwise, they overlap -> Collision detected!
;   REF: https://kishimotostudios.com/articles/aabb_collision/
; ------------------------------------------------------------------------
CHECK_CHAR_COLLISION PROC
  SAVE_REGS

  SHL AX, 1                                 ; Character ID * 2 (word)
  MOV BX, AX
  MOV BX, [char_data_table + BX]            ; BX = Address of the character data structure

  ; TODO: This is a copy/paste of CHECK_HITBOX_COLLISION
  ;Resolve the direction indirection: Master table -> direction data block
  MOV SI, [BX].CHARACTER.ch_dir_tbl_addr    ; SI = Address of the 4-directions table
  XOR DH, DH
  MOV DL, [BX].CHARACTER.ch_dir
  SHL DX, 1                                 ; DX = Direction * 2 (word)
  ADD SI, DX                                ; SI = Address of the direction data
  MOV SI, [SI]                              ; Dereference the direction data (hitbox, sprites, ...)
  MOV DI, [SI].CHAR_DIR_DATA.cd_hitbox      ; Dereference the hitbox
  ;-----------------------------------

  ; --- character 1 left ---
  XOR CH, CH
  MOV CL, [DI].HITBOX.hb_x1
  MOV aabb_ch1_left, CX
  MOV CX, [BX].CHARACTER.ch_loc.lo_x
  ADD aabb_ch1_left, CX                     ; aabb_ch1_left =  pos x + hb_x1

  ; --- character 1 right ---
  XOR CH, CH
  MOV CL, [DI].HITBOX.hb_x2
  MOV aabb_ch1_right, CX
  MOV CX, [BX].CHARACTER.ch_loc.lo_x
  ADD aabb_ch1_right, CX                    ; aabb_ch1_right = pos x + hb_x2

  ; --- character 1 top ---
  XOR CH, CH
  MOV CL, [DI].HITBOX.hb_y1
  MOV aabb_ch1_top, CX
  MOV CX, [BX].CHARACTER.ch_loc.lo_y
  ADD aabb_ch1_top, CX                      ; aabb_ch1_top = pos y + hb_y1

  ; --- character 1 bottom ---
  XOR CH, CH
  MOV CL, [DI].HITBOX.hb_y2
  MOV aabb_ch1_bottom, CX
  MOV CX, [BX].CHARACTER.ch_loc.lo_y
  ADD aabb_ch1_bottom, CX                   ; aabb_ch1_bottom = pos y + hb_y2

  MOV CX, 2  ; 2 characters in the game for now | TODO: calc this dynamically

@ccc_next_char:
  MOV BX, CX ; TODO: This is a hack to avoid a bug
  DEC BX     ; Check to replace this with another strategie
  SHL BX, 1

  CMP BX, AX
  JE @ccc_skip

  MOV BX, [char_data_table + BX]            ; BX = Address of the character data structure

  CALL CHECK_CHAR_BOUNDS_COLLISION
  JC @ccc_return

@ccc_skip:
  LOOP @ccc_next_char


@ccc_return:
  RESTORE_REGS
  RET
CHECK_CHAR_COLLISION ENDP

; ------------------------------------------------------------------------
; CHECK_CHAR_BOUNDS_COLLISION
; Description: Check for collision between the current character and the
;              character at address BX
; Registers: AX, BX, CX, DX, SI, DI
; Input: BX = Address of the character data structure
; Output: Carry flag set if collision
; Modified: aabb_ch2_left, aabb_ch2_right, aabb_ch2_top, aabb_ch2_bottom
; ------------------------------------------------------------------------
CHECK_CHAR_BOUNDS_COLLISION PROC
  SAVE_REGS

  ; Are we on the same scene?
  MOV DX, current_scene_addr
  CMP [BX].CHARACTER.ch_scene_addr, DX
  JNE @ccbc_no_collision

  ; TODO: This is a copy/paste of CHECK_HITBOX_COLLISION
  ;Resolve the direction indirection: Master table -> direction data block
  MOV SI, [BX].CHARACTER.ch_dir_tbl_addr    ; SI = Address of the 4-directions table
  XOR DH, DH
  MOV DL, [BX].CHARACTER.ch_dir
  SHL DX, 1                                 ; DX = Direction * 2 (word)
  ADD SI, DX                                ; SI = Address of the direction data
  MOV SI, [SI]                              ; Dereference the direction data (hitbox, sprites, ...)
  MOV DI, [SI].CHAR_DIR_DATA.cd_hitbox      ; Dereference the hitbox
  ;-----------------------------------

  ; --- character 2 left ---
  XOR DH, DH
  MOV DL, [DI].HITBOX.hb_x1
  MOV aabb_ch2_left, DX
  MOV DX, [BX].CHARACTER.ch_loc.lo_x
  ADD aabb_ch2_left, DX                     ; aabb_ch2_left = pos x + hb_x1

  MOV DX, aabb_ch2_left
  CMP aabb_ch1_right, DX                    ; if aabb_ch1_right <= aabb_ch2_left
  JL @ccbc_no_collision                     ; then no collision

  ; --- character 2 right ---
  XOR DH, DH
  MOV DL, [DI].HITBOX.hb_x2
  MOV aabb_ch2_right, DX
  MOV DX, [BX].CHARACTER.ch_loc.lo_x
  ADD aabb_ch2_right, DX                    ; aabb_ch2_right = pos x + hb_x2

  MOV DX, aabb_ch2_right
  CMP aabb_ch1_left, DX                     ; if aabb_ch1_left >= aabb_ch2_right
  JG @ccbc_no_collision                     ; then no collision

  ; --- character 2 top ---
  XOR DH, DH
  MOV DL, [DI].HITBOX.hb_y1
  MOV aabb_ch2_top, DX
  MOV DX, [BX].CHARACTER.ch_loc.lo_y
  ADD aabb_ch2_top, DX                      ; aabb_ch2_top = pos y + hb_y1

  MOV DX, aabb_ch2_top
  CMP aabb_ch1_bottom, DX                   ; if aabb_ch1_bottom <= aabb_ch2_top
  JL @ccbc_no_collision                     ; then no collision

  ; --- character 2 bottom ---
  XOR DH, DH
  MOV DL, [DI].HITBOX.hb_y2
  MOV aabb_ch2_bottom, DX
  MOV DX, [BX].CHARACTER.ch_loc.lo_y
  ADD aabb_ch2_bottom, DX                   ; aabb_ch2_bottom = pos y + hb_y2

  MOV DX, aabb_ch2_bottom
  CMP aabb_ch1_top, DX                      ; if aabb_ch1_top >= aabb_ch2_bottom
  JG @ccbc_no_collision                     ; then no collision

  ; --- Collision detected ---
  STC                                       ; Collision detected, set carry flag
  JMP @ccbc_return

  ; --- No collision detected ---
@ccbc_no_collision:
  CLC                                       ; No collision detected, clear carry flag

@ccbc_return:
  RESTORE_REGS
  RET
CHECK_CHAR_BOUNDS_COLLISION ENDP
