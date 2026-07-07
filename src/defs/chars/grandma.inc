; --- grandma_data CHARACTER structure fields: ---
; ch_action_addr:      OFFSET UPDATE_GRANDMA_0_0
; ch_event:            <0, 0, 0, 0, 1>
; ch_tick:             0
; ch_loc:              <280, 45>
; ch_prev_loc:         <280, 45>
; ch_dir:              LEFT_DIR
; ch_dir_tbl_addr:     OFFSET grandma_dir_table
; ch_anim_idx:         0
; ch_anim_spd:         1
; ch_anim_cnt:         0
; ch_bg_buf_addr:      OFFSET grandma_bg_buffer
; ch_prev_bg_buf_addr: OFFSET grandma_prev_bg_buffer
; ch_sprt_buf_addr:    OFFSET grandma_tile_buffer
; ch_render_buf_addr:  OFFSET grandma_sprite_buffer
; ch_scene_addr:       OFFSET map_scene_0_0
grandma_data CHARACTER <\
  OFFSET UPDATE_GRANDMA_0_0,\
  <0, 0, 0, 0, 1>,\
  0,\
  <280, 45>,\
  <280, 45>,\
  LEFT_DIR,\
  OFFSET grandma_dir_table,\
  0,\
  1,\
  0,\
  OFFSET grandma_bg_buffer,\
  OFFSET grandma_prev_bg_buffer,\
  OFFSET grandma_tile_buffer,\
  OFFSET grandma_sprite_buffer,\
  OFFSET map_scene_0_0\
>

grandma_tile_file           DB "assets/grandma.pic", 0  ; Grandma tileset
grandma_bg_buffer           DB CHAR_SIZE DUP(0)         ; Grandma background buffer
grandma_prev_bg_buffer      DB CHAR_SIZE DUP(0)         ; Grandma previous background buffer
grandma_tile_buffer         DB 3500 DUP(0)              ; Grandma buffered tiles sprite
grandma_sprite_buffer       DB 272 DUP(0)               ; Grandma buffered sprite

; --- Grandma movement data table ---
; Must follow orders define in defs/game/dir.inc
grandma_dir_table           DW OFFSET grandma_right_data
                            DW OFFSET grandma_left_data
                            DW OFFSET grandma_up_data
                            DW OFFSET grandma_down_data

; --- Grandma direction data ---
grandma_right_data          CHAR_DIR_DATA <OFFSET grandma_sprt_right_table, OFFSET grandma_hb_right,  RIGHT_DIR>
grandma_left_data           CHAR_DIR_DATA <OFFSET grandma_sprt_left_table,  OFFSET grandma_hb_left,   LEFT_DIR>
grandma_up_data             CHAR_DIR_DATA <OFFSET grandma_sprt_up_table,    OFFSET grandma_hb_top,    UP_DIR>
grandma_down_data           CHAR_DIR_DATA <OFFSET grandma_sprt_down_table,  OFFSET grandma_hb_bottom, DOWN_DIR>

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

; --- Grandma hitbox data ---
grandma_hb_left             HITBOX <4, 10, 11, 15>
grandma_hb_right            HITBOX <4, 10, 11, 15>
grandma_hb_top              HITBOX <4, 10, 11, 15>
grandma_hb_bottom           HITBOX <4, 10, 11, 15>
