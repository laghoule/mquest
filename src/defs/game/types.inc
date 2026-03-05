ASSET STRUCT
  file_addr    DW ?  ; File address
  buffer_addr  DW ?  ; Buffer address
ASSET ENDS

SCENE STRUCT
  bg_buffer   DW ?  ; Background buffer address
  fg_buffer   DW ?  ; Foreground buffer address
  music_addr  DW ?  ; Music theme address
  north_addr  DW ?  ; Address of north scene
  south_addr  DW ?  ; Address of south scene
  east_addr   DW ?  ; Address of east scene
  west_addr   DW ?  ; Address of west scene
SCENE ENDS
