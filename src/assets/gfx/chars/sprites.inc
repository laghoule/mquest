; --- Generic sprite info ---
char_index            DW 0                        ; Character index (0: Mia) ; TODO: should be a DB
pos_x                 DW 0                        ; Sprite x position
pos_y                 DW 0                        ; Sprite y position

; --- Character sprite table info ---
char_buffer_table     DW OFFSET mia_buffer        ; mia buffered sprite
                      DW OFFSET grandma_buffer    ; grandma buffered sprite

char_data_table       DW OFFSET mia_data          ; Mia character data
                      DW OFFSET grandma_data      ; Grandma character data

char_dir_table        DW OFFSET mia_dir_table     ; Mia direction table
                      DW OFFSET grandma_dir_table ; Grandma direction table
