; map files
;----------
map_bg_file       DB "assets/map-bg.map", 0
map_fg_file       DB "assets/map-fg.map", 0
map_tileset_file  DB "assets/map-ts.til", 0

; ASSET struct <file_addr, buffer_addr>
;---------------------------------------
grandma_assets      ASSET <OFFSET grandma_tile_file, OFFSET grandma_buffer>
mia_assets          ASSET <OFFSET mia_tile_file,     OFFSET mia_buffer>

map_bg_assets       ASSET <OFFSET map_bg_file,       OFFSET map_bg_buffer>
map_fg_assets       ASSET <OFFSET map_fg_file,       OFFSET map_fg_buffer>
map_tileset_assets  ASSET <OFFSET map_tileset_file,  OFFSET map_tileset_buffer>

; Assets table is the list of all assets in the game
;---------------------------------------------------
assets_table    DW grandma_assets
                DW mia_assets
                DW map_bg_assets
                DW map_fg_assets
                DW map_tileset_assets
assets_count    EQU ($ - assets_table) / 2   ; Number of assets in the table
