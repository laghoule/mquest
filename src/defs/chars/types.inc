LOCATION STRUCT
  lo_x                 DW ?         ; X coordinate
  lo_y                 DW ?         ; Y coordinate
LOCATION ENDS

HITBOX STRUCT
  hb_x1                DB ?         ; X coordinate 1 of the hitbox
  hb_y1                DB ?         ; Y coordinate 1 of the hitbox
  hb_x2                DB ?         ; X coordinate 2 of the hitbox
  hb_y2                DB ?         ; Y coordinate 2 of the hitbox
HITBOX ENDS

CHAR_DIR_DATA STRUCT
  cd_sprt_tbl_addr    DW ?          ; Address of the sprite table
  cd_hitbox           DW ?          ; Address of the hitbox | TODO: should be HITBOX struct
  cd_dir              DB ?          ; Direction of the character | TODO: value already in CHARACTER struct, check if really needed
CHAR_DIR_DATA ENDS

CHARACTER STRUCT
  ch_action_addr       DW ?         ; Address of the action procedure
  ch_loc               LOCATION < > ; X, Y coordinate of the character
  ch_dir               DB ?         ; Direction of the character
  ch_dir_tbl_addr      DW ?         ; Address of the direction table
  ch_anim_idx          DB ?         ; Index of the animation frame | TODO: create anim struct
  ch_anim_spd          DB ?         ; Speed for the animation frame | TODO: create anim struct
  ch_anim_cnt          DB ?         ; Counter for the animation frame | TODO: create anim struct
  ch_bg_addr           DW ?         ; Address of the saved background
  ch_buf_addr          DW ?         ; Address of the character buffer sprite
  ch_scene_addr        DW ?         ; Address of the current scene location
CHARACTER ENDS
