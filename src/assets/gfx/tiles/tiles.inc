; Tiles data
tile_addr DW 0                      ; Tile data

; IDs must follow the definition here: defs/gfx/tiles.inc
tiles_table DW 10 DUP(0)            ; Place holder
  DW OFFSET grass_opq_0             ; ID 10
  DW 9 DUP(0)                       ; Place holder
  DW OFFSET flower_trns_0           ; ID 20
  DW OFFSET flower_trns_1           ; ID 21
  DW OFFSET flower_trns_2           ; ID 22
  DW OFFSET flower_trns_3           ; ID 23
  DW 6 DUP(0)                       ; Place holder
  DW OFFSET plant_trns_0            ; ID 30
  DW OFFSET plant_trns_1            ; ID 31
  DW OFFSET plant_trns_2            ; ID 32
  DW OFFSET plant_trns_3            ; ID 33
  DW OFFSET plant_trns_4            ; ID 34
  DW 5 DUP(0)                       ; Place holder
  DW OFFSET rock_trns_0             ; ID 40
  DW OFFSET rock_trns_1             ; ID 41
  DW OFFSET rock_trns_2             ; ID 42
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
  DB B_FR               ; ID 22 - Flower 2
  DB B_FR               ; ID 23 - Flower 3
  DB 6 DUP(0)           ; Place holder
  DB B_FR               ; ID 30 - Plant 0
  DB B_FR               ; ID 31 - Plant 1
  DB B_FR               ; ID 32 - Plant 2
  DB B_FR               ; ID 33 - Plant 3
  DB B_FR               ; ID 34 - Plant 4
  DB 5 DUP(0)           ; Place holder
  DB B_CL               ; ID 40 - Rock 0
  DB B_CL               ; ID 41 - Rock 1
  DB B_CL               ; ID 42 - Rock 2
  DB 7 DUP(0)           ; Place holder
  DB B_CL               ; ID 50 - Treasure 0
