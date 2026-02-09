CHAR_WIDTH     EQU 16         ; Width of a character sprite in pixels
CHAR_HEIGHT    EQU 17         ; Height of a character sprite in pixels
CHAR_SIZE      EQU 272        ; Size of a character sprite in bytes

; Character sprite index in the tileset data
CHAR_SPRT_IDX_0 EQU 0         ; Down
CHAR_SPRT_IDX_1 EQU 272       ; Right
CHAR_SPRT_IDX_2 EQU 544       ; Up
CHAR_SPRT_IDX_3 EQU 816       ; Left
CHAR_SPRT_IDX_4 EQU 1088      ; Down
CHAR_SPRT_IDX_5 EQU 1360      ; Right
CHAR_SPRT_IDX_6 EQU 1632      ; Up
CHAR_SPRT_IDX_7 EQU 1904      ; Left
CHAR_SPRT_IDX_8 EQU 2176      ; Down
CHAR_SPRT_IDX_9 EQU 2448      ; Right
CHAR_SPRT_IDX_10 EQU 2720     ; Up
CHAR_SPRT_IDX_11 EQU 2992     ; Left

; Offset of field in CHARACTER struct
CH_X                 EQU 0    ; X coordinate of the character
CH_Y                 EQU 2    ; Y coordinate of the character
CH_DIR               EQU 4    ; Direction of the character
CH_DIR_TABLE_PTR     EQU 6    ; Pointer to the direction table
CH_ANIM_IDX          EQU 8    ; Index of the current animation frame
CH_BG_SAVE_PTR       EQU 10   ; Pointer to the background save buffer
CH_SPRITE_BUFFER_PTR EQU 12   ; Pointer to the sprite buffer
