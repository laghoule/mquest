CHARACTER STRUCT
  ch_x                 DW ? ; X-coordinate of the character
  ch_y                 DW ? ; Y-coordinate of the character
  ch_dir               DW ? ; Direction of the character
  ch_dir_table_ptr     DW ? ; Pointer to the direction table
  ch_anim_idx          DW ? ; Index of the animation frame
  ch_bg_ptr            DW ? ; Pointer to the saved background
  ch_buf_ptr           DW ? ; Pointer to the character buffer sprite
CHARACTER ENDS
