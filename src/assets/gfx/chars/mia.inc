; Tool for sprites creation: https://github.com/laghoule/png2asm

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
mia_sprites_table_down  DW 0                  ; tile 0
                        DW 1088               ; tile 4
                        DW 2176               ; tile 8

; --- mia animation right table ---
mia_sprites_table_right DW 272                ; tile 1
                        DW 1360               ; tile 5
                        DW 2448               ; tile 9

; --- Mia animation up table ---
mia_sprites_table_up    DW 544                ; tile 2
                        DW 1632               ; tile 6
                        DW 2720               ; tile 10

; --- Mia animation left table ---
mia_sprites_table_left  DW 816                ; tile 3
                        DW 1904               ; tile 7
                        DW 2992               ; tile 11
