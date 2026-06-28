; ===============================================
;           TILE COLLISION MODES (0-7)
; ===============================================
;  0: NONE     1: FULL     2: BOTTOM   3: TOP
;  +---+       +---+       +---+       +---+
;  |   |       |###|       |   |       |###|
;  |   |       |###|       |###|       |   |
;  +---+       +---+       +---+       +---+
;
;  4: LEFT     5: RIGHT    6: CENTER   7: LEDGE
;  +---+       +---+       +---+       +---+
;  |#  |       |  #|       |   |       |===|
;  |#  |       |  #|       | # |       | v |
;  +---+       +---+       +---+       +---+
; ===============================================

; --- Tile Hitbox Table ---
tile_hb_table LABEL BYTE
  HITBOX < 0,  0,  0,  0 >  ; 0: COLL_NONE
  HITBOX < 0,  0, 15, 15 >  ; 1: COLL_FULL
  HITBOX < 0,  8, 15, 15 >  ; 2: COLL_BOTTOM
  HITBOX < 0,  0, 15,  7 >  ; 3: COLL_TOP
  HITBOX < 0,  0,  7, 15 >  ; 4: COLL_LEFT
  HITBOX < 8,  0, 15, 15 >  ; 5: COLL_RIGHT
  HITBOX < 4,  4, 11, 11 >  ; 6: COLL_CENTER
  HITBOX < 0,  6, 15,  9>   ; 7: COLL_BARRIER

; --- Collision Types (Value of bits 0-2) ---
COLL_NONE      EQU 0 ; 00000000b
COLL_FULL      EQU 1 ; 00000001b
COLL_BOTTOM    EQU 2 ; 00000010b
COLL_TOP       EQU 3 ; 00000011b
COLL_LEFT      EQU 4 ; 00000100b
COLL_RIGHT     EQU 5 ; 00000101b
COLL_CENTER    EQU 6 ; 00000110b
COLL_LEDGE     EQU 7 ; 00000111b
