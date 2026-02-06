; Tool for sprites creation: https://github.com/laghoule/png2asm

; --- definition ---------------------------------------------------------------
; ch_x, ch_y, ch_dir, ch_dir_table_ptr, ch_anim_idx, ch_bg_save_ptr, ch_sprite_buffer_ptr
; ------------------------------------------------------------------------------
mia_data CHARACTER <150, 90, DOWN_DIR, OFFSET mia_dir_table, 0, OFFSET mia_bg_sprite, OFFSET mia_buffer>

; --- Mia sprite info ---
mia_pos_x               DW 150                ; Mia starting x position
mia_pos_y               DW 90                 ; Mia starting y position
mia_bg_sprite           DB 272 DUP(0)         ; Mia background sprite
mia_r_anim_state        DB 0                  ; Mia right animation state (0, 1, 2 state) # TODO: replace _state with _index
mia_l_anim_state        DB 0                  ; Mia left animation state (0, 1, 2 state)
mia_u_anim_state        DB 0                  ; Mia up animation state (0, 1, 2 state)
mia_d_anim_state        DB 0                  ; Mia down animation state (0, 1, 2 state)

file_mia                DB "mia.dat", 0       ; Mia tileset
mia_buffer              DB 3500 DUP(0)        ; Mia buffered tileset

; --- Mia movement data table ---
; Must follow orders define in defs/game/dir.inc
mia_dir_table DW OFFSET mia_dir_right
              DW OFFSET mia_dir_left
              DW OFFSET mia_dir_up
              DW OFFSET mia_dir_down

; --- definition ---------------------------------------------------------------
; SpriteTable (DW), AnimState (DW), P1X (DB), P1Y (DB), P2X (DB), P2Y (DB), Dir
; ------------------------------------------------------------------------------
mia_dir_right DW OFFSET mia_sprites_table_right, OFFSET mia_r_anim_state
              DB HIT_RIGHT_X, HIT_HEAD_Y, HIT_RIGHT_X, HIT_BOTTOM_Y
              DB RIGHT_DIR

mia_dir_left  DW OFFSET mia_sprites_table_left,  OFFSET mia_l_anim_state
              DB HIT_LEFT_X, HIT_HEAD_Y, HIT_LEFT_X, HIT_BOTTOM_Y
              DB LEFT_DIR

mia_dir_up    DW OFFSET mia_sprites_table_up,    OFFSET mia_u_anim_state
              DB HIT_LEFT_FOOT_X, HIT_HEAD_Y, HIT_RIGHT_FOOT_X, HIT_HEAD_Y
              DB UP_DIR

mia_dir_down  DW OFFSET mia_sprites_table_down,  OFFSET mia_d_anim_state
              DB HIT_LEFT_FOOT_X, HIT_BOTTOM_Y, HIT_RIGHT_FOOT_X, HIT_BOTTOM_Y
              DB DOWN_DIR

; --- Mia animation down table ---
mia_sprites_table_down  DW CHAR_SPRT_IDX_0  ; tile 0
                        DW CHAR_SPRT_IDX_4  ; tile 4
                        DW CHAR_SPRT_IDX_8  ; tile 8

; --- mia animation right table ---
mia_sprites_table_right DW CHAR_SPRT_IDX_1  ; tile 1
                        DW CHAR_SPRT_IDX_5  ; tile 5
                        DW CHAR_SPRT_IDX_9  ; tile 9

; --- Mia animation up table ---
mia_sprites_table_up    DW CHAR_SPRT_IDX_2  ; tile 2
                        DW CHAR_SPRT_IDX_6  ; tile 6
                        DW CHAR_SPRT_IDX_10 ; tile 10

; --- Mia animation left table ---
mia_sprites_table_left  DW CHAR_SPRT_IDX_3  ; tile 3
                        DW CHAR_SPRT_IDX_7  ; tile 7
                        DW CHAR_SPRT_IDX_11 ; tile 11
