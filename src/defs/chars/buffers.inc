mia_bg_buffer           DB CHAR_SIZE DUP(?)     ; Mia background buffer
mia_prev_bg_buffer      DB CHAR_SIZE DUP(?)     ; Mia previous background buffer
mia_tile_buffer         DB 3500 DUP(?)          ; Mia buffered tiles sprite // FIXME: initialized (?) create artifact
mia_sprite_buffer       DB 272 DUP(?)           ; Mia buffered sprite

grandma_bg_buffer       DB CHAR_SIZE DUP(?)     ; Grandma background buffer
grandma_prev_bg_buffer  DB CHAR_SIZE DUP(?)     ; Grandma previous background buffer
grandma_tile_buffer     DB 3500 DUP(?)          ; Grandma buffered tiles sprite // FIXME: // FIXME: initialized (?) create artifact
grandma_sprite_buffer   DB 272 DUP(?)           ; Grandma buffered sprite

