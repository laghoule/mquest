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
  cd_sprt_tbl_addr     DW ?         ; Address of the sprite table
  cd_hitbox_tile       HITBOX < >   ; Hitbox of tile object
  cd_hitbox_npc        HITBOX < >   ; Hitbox of NPC
CHAR_DIR_DATA ENDS

EVENT STRUCT
  ev_addr              DW ?         ; Address of the event procedure
  ev_tick              DW ?         ; Tick counter (timestamp)
  ev_state             DW ?         ; State of the event
  ev_param             DW ?         ; Parameter of the event
  ev_redraw            DW ?         ; Redraw flag (1 = redraw, 0 = no redraw)
EVENT ENDS

CHARACTER STRUCT
  ch_action_addr       DW ?         ; Address of the action procedure
  ch_event             EVENT < >    ; Event data
  ch_tick              DW ?         ; Tick counter (timestamp)
  ch_loc               LOCATION < > ; Current X, Y coordinate of the character
  ch_prev_loc          LOCATION < > ; Previous location of the character
  ch_dir               DB ?         ; Direction of the character
  ch_dir_tbl_addr      DW ?         ; Address of the direction table
  ch_anim_idx          DB ?         ; Index of the animation frame | TODO: create anim struct
  ch_anim_spd          DB ?         ; Speed for the animation frame | TODO: create anim struct
  ch_anim_cnt          DB ?         ; Counter for the animation frame | TODO: create anim struct
  ch_bg_buf_addr       DW ?         ; Address of the background map buffer
  ch_prev_bg_buf_addr  DW ?         ; Address of the previous background map buffer
  ch_sprt_buf_addr     DW ?         ; Address of the character buffer sprite
  ch_render_buf_addr   DW ?         ; Address of the rendered buffer (ch_bg_buf_addr + ch_sprt_buf_addr)
  ch_scene_addr        DW ?         ; Address of the current scene location
CHARACTER ENDS
