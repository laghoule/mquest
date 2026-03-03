; --- Character directions ---
RIGHT_DIR  EQU 0
LEFT_DIR   EQU 1
UP_DIR     EQU 2
DOWN_DIR   EQU 3

; --- TILES ATTRIBUTS BITS ---
B_FR EQU 00000000b  ; Bit 0: Free (No collision)
B_CL EQU 00000001b  ; Bit 0: Object collision
B_EV EQU 00000010b  ; Bit 1: Event (Interaction)

;--------------------------------------------TODO------------------------------------------
;| Bits | Catégorie | Valeurs possibles |
;| --- | --- | --- |
;| 0, 1, 2 | Collision | 8 types (0:Vide, 1:Plein, 2:Bas, 3:Haut, 4:Gauche, 5:Droite...) |
;| 3, 4 | Sound | 4 types (0:Herbe, 1:Pierre/Grotte, 2:Bois/Pont, 3:Eau/Boue) |
;| 5 | Event | 1 bit (0:Rien, 1:Déclencheur d'interaction) |
;| 6 | Action | 1 bit (0:Rien, 1:Pickable / Ramassable) |
;| 7 | Hazard | 1 bit (0:Sain, 1:Dégâts / Ronces / Poison) |

; --- TILE ATTRIBUTE MASKS ---
MASK_COLLISION EQU 00000111b  ; Bits 0-2
MASK_SOUND     EQU 00011000b  ; Bits 3-4
MASK_EVENT     EQU 00100000b  ; Bit 5
MASK_ACTION    EQU 01000000b  ; Bit 6
MASK_HAZARD    EQU 10000000b  ; Bit 7

; --- COLLISION TYPES (Value of bits 0-2) ---
COLL_NONE      EQU 0
COLL_FULL      EQU 1
COLL_BOTTOM    EQU 2
COLL_TOP       EQU 3
; ... (jusqu'à 7)

; --- SOUND TYPES (Value of bits 3-4) ---
; On utilise des décalages pour faciliter l'écriture
SND_GRASS      EQU (0 SHL 3)
SND_STONE      EQU (1 SHL 3)
SND_WOOD       EQU (2 SHL 3)
SND_WATER      EQU (3 SHL 3)
;-----------------------------------------------------------------------------------------