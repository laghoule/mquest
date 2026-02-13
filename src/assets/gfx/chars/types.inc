CHARACTER STRUCT
  ch_x                 DW ? ; X-coordinate of the character
  ch_y                 DW ? ; Y-coordinate of the character
  ch_dir               DB ? ; Direction of the character
  ch_dir_table_addr    DW ? ; Address of the direction table
  ch_anim_idx          DB ? ; Index of the animation frame
  ch_bg_addr           DW ? ; Address of the saved background
  ch_buf_addr          DW ? ; Address of the character buffer sprite
CHARACTER ENDS
