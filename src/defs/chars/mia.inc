; --- definition ------------------------------------------------------------------------------------
; ch_action_addr, ch_event, ch_loc, ch_dir, ch_dir_table_addr, ch_anim_idx, ch_anim_spd, ch_anim_cnt,
; ch_bg_buf_addr, ch_prev_bg_buf_addr, ch_sprt_buf_addr, ch_render_buf_addr, ch_scene_addr
; ---------------------------------------------------------------------------------------------------
mia_data CHARACTER <0, <0, 0, 0, 0>, <280, 90>, DOWN_DIR, OFFSET mia_dir_table, 0, 3, 0, OFFSET mia_bg_buffer, OFFSET mia_prev_bg_buffer, OFFSET mia_tile_buffer, OFFSET mia_sprite_buffer, OFFSET map_scene_0_0>

mia_tile_file           DB "assets/mia.pic", 0  ; Mia tileset
mia_bg_buffer           DB CHAR_SIZE DUP(0)     ; Mia background buffer
mia_prev_bg_buffer      DB CHAR_SIZE DUP(0)      ; Mia previous background buffer
mia_tile_buffer         DB 3500 DUP(0)          ; Mia buffered tiles sprite
mia_sprite_buffer       DB 272 DUP(0)           ; Mia buffered sprite

; --- Mia movement data table ---
; Must follow orders define in defs/game/dir.inc
mia_dir_table           DW OFFSET mia_right_data
                        DW OFFSET mia_left_data
                        DW OFFSET mia_up_data
                        DW OFFSET mia_down_data

; --- Mia direction data ---
mia_right_data          CHAR_DIR_DATA <OFFSET mia_sprt_right_table, OFFSET mia_hb_right,  RIGHT_DIR>
mia_left_data           CHAR_DIR_DATA <OFFSET mia_sprt_left_table,  OFFSET mia_hb_left,   LEFT_DIR>
mia_up_data             CHAR_DIR_DATA <OFFSET mia_sprt_up_table,    OFFSET mia_hb_top,    UP_DIR>
mia_down_data           CHAR_DIR_DATA <OFFSET mia_sprt_down_table,  OFFSET mia_hb_bottom, DOWN_DIR>

; --- Mia animation down table ---
mia_sprt_down_table     DW CHAR_SPRT_IDX_0  ; tile 0
                        DW CHAR_SPRT_IDX_4  ; tile 4
                        DW CHAR_SPRT_IDX_8  ; tile 8

; --- mia animation right table ---
mia_sprt_right_table    DW CHAR_SPRT_IDX_1  ; tile 1
                        DW CHAR_SPRT_IDX_5  ; tile 5
                        DW CHAR_SPRT_IDX_9  ; tile 9

; --- Mia animation up table ---
mia_sprt_up_table       DW CHAR_SPRT_IDX_2  ; tile 2
                        DW CHAR_SPRT_IDX_6  ; tile 6
                        DW CHAR_SPRT_IDX_10 ; tile 10

; --- Mia animation left table ---
mia_sprt_left_table     DW CHAR_SPRT_IDX_3  ; tile 3
                        DW CHAR_SPRT_IDX_7  ; tile 7
                        DW CHAR_SPRT_IDX_11 ; tile 11

; --- Mia hitbox data ---
mia_hb_left             HITBOX <1, 1, 15, 15>
mia_hb_right            HITBOX <1, 1, 15, 15>
mia_hb_top              HITBOX <1, 1, 15, 15>
mia_hb_bottom           HITBOX <1, 1, 15, 15>
