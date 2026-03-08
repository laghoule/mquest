ASSET STRUCT
  file_addr       DW ?  ; File address
  buffer_addr     DW ?  ; Buffer address
ASSET ENDS

SCENE STRUCT
  map_buffer_addr DW ?  ; Map buffer adress
  music_addr      DW ?  ; Music theme adress
  north_addr      DW ?  ; Address of north scene
  south_addr      DW ?  ; Address of south scene
  east_addr       DW ?  ; Address of east scene
  west_addr       DW ?  ; Address of west scene
SCENE ENDS
