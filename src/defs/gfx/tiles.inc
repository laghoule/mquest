; --- Tiles IDs ---
VOID_0 EQU 0            ; Empty
GRS_O0 EQU 10           ; Grass 0

FLO_T0 EQU 20           ; Flower 0
FLO_T1 EQU 21           ; Flower 1

PLT_T0 EQU 30           ; Plant 0
PLT_T1 EQU 31           ; Plant 1
PLT_T2 EQU 32           ; Plant 2

RKS_O0 EQU 40           ; Rock 0
RKS_T0 EQU 41           ; Rock 1
RKS_T1 EQU 42           ; Rock 2

TRS_T1 EQU 50           ; Treasure 1

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
