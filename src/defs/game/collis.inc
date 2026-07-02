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
tile_hb_table LABEL WORD
  HITBOX <0, 8, 15, 15>  ; 2: COLL_BOTTOM
  HITBOX <0, 0, 15,  7>  ; 3: COLL_TOP
  HITBOX <0, 0,  5, 15>  ; 4: COLL_LEFT
  HITBOX <5, 0, 15, 15>  ; 5: COLL_RIGHT
  HITBOX <4, 4, 11, 11>  ; 6: COLL_CENTER
  HITBOX <0, 6, 15,  9>  ; 7: COLL_BARRIER

; --- Collision Types (Value of bits 0-2) ---
COLL_NONE      EQU 00000000b
COLL_FULL      EQU 00000001b
COLL_BOTTOM    EQU 00000010b
COLL_TOP       EQU 00000011b
COLL_LEFT      EQU 00000100b
COLL_RIGHT     EQU 00000101b
COLL_CENTER    EQU 00000110b
COLL_BARRIER   EQU 00000111b
