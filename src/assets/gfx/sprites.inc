  ; --- Generic sprite info ---
  curr_sprite           DW 0          ; Current sprite to draw
  curr_sprite_table     DW 0          ; Current sprite table
  curr_anim_state       DB 0          ; Current animation state
  bg_sprite             DB 272 DUP(0) ; Background sprite
  pos_x                 DW 0          ; Sprite x position
  pos_y                 DW 0          ; Sprite y position
