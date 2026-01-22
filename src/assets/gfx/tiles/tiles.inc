; Tiles data
tile DW 0                           ; Tile data

; IDs must follow the definition here: defs/gfx/tiles.inc
tiles_table DW 10 DUP(0)            ; Place holder
  DW OFFSET grass_opq_0             ; ID 10
  DW 9 DUP(0)                       ; Place holder
  DW OFFSET flower_trns_0           ; ID 20
  DW OFFSET flower_trns_1           ; ID 21
  DW 8 DUP(0)                       ; Place holder
  DW OFFSET plant_trns_0            ; ID 30
  DW OFFSET plant_trns_1            ; ID 31
  DW OFFSET plant_trns_2            ; ID 32
  DW 7 DUP(0)                       ; Place holder
  DW OFFSET rock_opq_0              ; ID 40
  DW OFFSET rock_trns_0             ; ID 41
  DW OFFSET rock_trns_1             ; ID 42
  DW 7 DUP(0)                       ; Place holder
  DW OFFSET tresors_trns_0          ; ID 50

; TODO: use ORG TILES_PROPS + X
TILES_PROPS LABEL BYTE
  DB B_FR               ; ID 0 - Void
  DB 9 DUP(0)           ; Place holder
  DB B_FR               ; ID 10 - Grass 0
  DB 9 DUP(0)           ; Place holder
  DB B_FR               ; ID 20 - Flower 0
  DB B_FR               ; ID 21 - Flower 1
  DB 8 DUP(0)           ; Place holder
  DB B_FR               ; ID 30 - Plant 0
  DB B_FR               ; ID 31 - Plant 1
  DB B_FR               ; ID 32 - Plant 2
  DB 7 DUP(0)           ; Place holder
  DB B_CL               ; ID 40 - Rock 0
  DB B_CL               ; ID 41 - Rock 1
  DB B_CL               ; ID 42 - Rock 2
  DB 7 DUP(0)           ; Place holder
  DB B_CL               ; ID 50 - Treasure 1
