; --- Non player character AABB temp data ---
; https://kishimotostudios.com/articles/aabb_collision/

aabb_ch1_left   DW ?                    ; x1
aabb_ch1_right  DW ?                    ; x2
aabb_ch1_top    DW ?                    ; y1
aabb_ch1_bottom DW ?                    ; y2

aabb_ch2_left   DW ?                    ; x1
aabb_ch2_right  DW ?                    ; x2
aabb_ch2_top    DW ?                    ; y1
aabb_ch2_bottom DW ?                    ; y2

; --- Character sprite table info ---
char_data_table DW OFFSET mia_data      ; Mia character data
                DW OFFSET grandma_data  ; Grandma character data

; --- Generic sprite info ---
char_index            DW 0              ; Character index (0: Mia) ; TODO: should be a DB
;pos_x                 DW 0              ; Sprite x position
;pos_y                 DW 0              ; Sprite y position
