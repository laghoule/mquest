; --- definition ---------------------------------------------------------------------------
; ch_update_proc, ch_loc, ch_dir, ch_dir_table_addr, ch_anim_idx, ch_bg_addr, ch_buf_addr, ch_scene_addr
; ------------------------------------------------------------------------------------------
grandma_data CHARACTER <0, <280, 45>, DOWN_DIR, OFFSET grandma_dir_table, 0, OFFSET grandma_bg_buffer, OFFSET grandma_buffer, OFFSET map_scene_0_0>

grandma_tile_file           DB "assets/grandma.pic", 0  ; Grandma tileset
grandma_bg_buffer           DB CHAR_SIZE DUP(0)         ; Grandma background buffered sprite
grandma_buffer              DB 3500 DUP(0)              ; Grandma buffered sprite

; --- Grandma movement data table ---
; Must follow orders define in defs/game/dir.inc
grandma_dir_table           DW OFFSET grandma_right_data
                            DW OFFSET grandma_left_data
                            DW OFFSET grandma_up_data
                            DW OFFSET grandma_down_data

; --- Grandma direction data ---
grandma_right_data          CHAR_DIR_DATA <OFFSET grandma_sprt_right_table, OFFSET char_hitbox_right, RIGHT_DIR>
grandma_left_data           CHAR_DIR_DATA <OFFSET grandma_sprt_left_table,  OFFSET char_hitbox_left,  LEFT_DIR>
grandma_up_data             CHAR_DIR_DATA <OFFSET grandma_sprt_up_table,    OFFSET char_hitbox_head,  UP_DIR>
grandma_down_data           CHAR_DIR_DATA <OFFSET grandma_sprt_down_table,  OFFSET char_hitbox_foot,  DOWN_DIR>

; --- Grandma animation down table ---
grandma_sprt_down_table     DW CHAR_SPRT_IDX_0  ; tile 0
                            DW CHAR_SPRT_IDX_4  ; tile 4
                            DW CHAR_SPRT_IDX_8  ; tile 8

; --- grandma animation right table ---
grandma_sprt_right_table    DW CHAR_SPRT_IDX_1  ; tile 1
                            DW CHAR_SPRT_IDX_5  ; tile 5
                            DW CHAR_SPRT_IDX_9  ; tile 9

; --- Grandma animation up table ---
grandma_sprt_up_table       DW CHAR_SPRT_IDX_2  ; tile 2
                            DW CHAR_SPRT_IDX_6  ; tile 6
                            DW CHAR_SPRT_IDX_10 ; tile 10

; --- Grandma animation left table ---
grandma_sprt_left_table     DW CHAR_SPRT_IDX_3  ; tile 3
                            DW CHAR_SPRT_IDX_7  ; tile 7
                            DW CHAR_SPRT_IDX_11 ; tile 11
