; --- Generic sprite info ---
char_index            DW 0                      ; Character index (0: Mia)
char_sprite_index     DW 0                      ; Character sprite index
char_sprite_table     DW 0                      ; Character sprite table
char_anim_state       DB 0                      ; Character animation state
bg_sprite             DB 272 DUP(0)             ; Background sprite
pos_x                 DW 0                      ; Sprite x position
pos_y                 DW 0                      ; Sprite y position

; --- Character sprite table info ---
char_buffer_table     DW OFFSET mia_buffer      ; mia buffered sprite
                      DW OFFSET grandma_buffer  ; grandma buffered sprite
