; --- definition ---------------------------------------------------------------
; ch_x, ch_y, ch_dir, ch_dir_table_ptr, ch_anim_idx, ch_bg_ptr, ch_buf_ptr
; ------------------------------------------------------------------------------
grandma_data CHARACTER <280, 45, DOWN_DIR, OFFSET grandma_dir_table, 0, OFFSET grandma_bg_sprite, OFFSET grandma_buffer>

file_grandma                DB "grandma.pic", 0   ; Grandma tileset
grandma_anim_state          DB 0                  ; Grandma animation state
grandma_bg_sprite           DB CHAR_SIZE DUP(0)   ; Grandma background sprite
grandma_buffer              DB 3500 DUP(0)        ; Grandma buffered tileset

; --- Grandma movement data table ---
; Must follow orders define in defs/game/dir.inc
grandma_dir_table           DW OFFSET grandma_dir_right
                            DW OFFSET grandma_dir_left
                            DW OFFSET grandma_dir_up
                            DW OFFSET grandma_dir_down

; --- definition ---------------------------------------------------------------
; SpriteTable (DW), AnimState (DW), P1X (DB), P1Y (DB), P2X (DB), P2Y (DB), Dir
; ------------------------------------------------------------------------------
grandma_dir_right           DW OFFSET grandma_sprites_table_right, OFFSET grandma_anim_state
                            DB HIT_RIGHT_X, HIT_HEAD_Y, HIT_RIGHT_X, HIT_BOTTOM_Y
                            DB RIGHT_DIR

grandma_dir_left            DW OFFSET grandma_sprites_table_left,  OFFSET grandma_anim_state
                            DB HIT_LEFT_X, HIT_HEAD_Y, HIT_LEFT_X, HIT_BOTTOM_Y
                            DB LEFT_DIR

grandma_dir_up              DW OFFSET grandma_sprites_table_up,    OFFSET grandma_anim_state
                            DB HIT_LEFT_FOOT_X, HIT_HEAD_Y, HIT_RIGHT_FOOT_X, HIT_HEAD_Y
                            DB UP_DIR

grandma_dir_down            DW OFFSET grandma_sprites_table_down,  OFFSET grandma_anim_state
                            DB HIT_LEFT_FOOT_X, HIT_BOTTOM_Y, HIT_RIGHT_FOOT_X, HIT_BOTTOM_Y
                            DB DOWN_DIR

; --- Grandma animation down table ---
grandma_sprites_table_down  DW CHAR_SPRT_IDX_0  ; tile 0
                            DW CHAR_SPRT_IDX_4  ; tile 4
                            DW CHAR_SPRT_IDX_8  ; tile 8

; --- grandma animation right table ---
grandma_sprites_table_right DW CHAR_SPRT_IDX_1  ; tile 1
                            DW CHAR_SPRT_IDX_5  ; tile 5
                            DW CHAR_SPRT_IDX_9  ; tile 9

; --- Grandma animation up table ---
grandma_sprites_table_up    DW CHAR_SPRT_IDX_2  ; tile 2
                            DW CHAR_SPRT_IDX_6  ; tile 6
                            DW CHAR_SPRT_IDX_10 ; tile 10

; --- Grandma animation left table ---
grandma_sprites_table_left  DW CHAR_SPRT_IDX_3  ; tile 3
                            DW CHAR_SPRT_IDX_7  ; tile 7
                            DW CHAR_SPRT_IDX_11 ; tile 11
