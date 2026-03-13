ASSET STRUCT
  file_addr           DW ?  ; File address
  buffer_addr         DW ?  ; Buffer address
ASSET ENDS

SCENE STRUCT
  sc_map_buffer_addr  DW ?  ; Map buffer adress
  sc_music_addr       DW ?  ; Music theme adress
  sc_north_addr       DW ?  ; Address of north scene
  sc_south_addr       DW ?  ; Address of south scene
  sc_east_addr        DW ?  ; Address of east scene
  sc_west_addr        DW ?  ; Address of west scene
SCENE ENDS
