; map files
;----------
map_file          DB "assets/map-wrld.map", 0
map_tileset_file  DB "assets/map-ts.til", 0

; hud files
;----------
hud_file            DB "assets/hud-wrld.map", 0 ; TODO: RENAME
hud_tileset_file    DB "assets/hud-ts.til", 0   ; TODO: RENAME
hud_portrait_file   DB "assets/hud-face.pic", 0 ; TODO: RENAME
hud_heart_file      DB "assets/hud-hrt.pic", 0  ; TODO: RENAME
hud_invt_plant      DB "assets/hud-plnt.pic", 0 ; TODO: RENAME
hud_invt_potion     DB "assets/hud-potn.pic", 0 ; TODO: RENAME
hud_invt_tool       DB "assets/hud-tool.pic", 0 ; TODO: RENAME
hud_invt_book       DB "assets/hud-book.pic", 0 ; TODO: RENAME


; ASSET struct <file_addr, buffer_addr>
;---------------------------------------
grandma_assets      ASSET <OFFSET grandma_tile_file, OFFSET grandma_tile_buffer>
mia_assets          ASSET <OFFSET mia_tile_file,     OFFSET mia_tile_buffer>

map_assets          ASSET <OFFSET map_file,          OFFSET map_buffer>
map_tileset_assets  ASSET <OFFSET map_tileset_file,  OFFSET map_tileset_buffer>

hud_assets          ASSET <OFFSET hud_file,          OFFSET hud_buffer>
hud_tileset_assets  ASSET <OFFSET hud_tileset_file,  OFFSET hud_tileset_buffer>
hud_portrait_assets ASSET <OFFSET hud_portrait_file, OFFSET hud_portrait_buffer>
hud_heart_assets    ASSET <OFFSET hud_heart_file,    OFFSET hud_heart_buffer>
hud_plant_assets    ASSET <OFFSET hud_invt_plant,    OFFSET hud_invt_plant_buffer>
hud_potion_assets   ASSET <OFFSET hud_invt_potion,   OFFSET hud_invt_potion_buffer>
hud_tool_assets     ASSET <OFFSET hud_invt_tool,     OFFSET hud_invt_tool_buffer>
hud_book_assets     ASSET <OFFSET hud_invt_book,     OFFSET hud_invt_book_buffer>

; Assets table is the list of all assets in the game
;---------------------------------------------------
assets_table    DW grandma_assets
                DW mia_assets
                DW map_assets
                DW map_tileset_assets
                DW hud_assets
                DW hud_tileset_assets
                DW hud_portrait_assets
                DW hud_heart_assets
                DW hud_plant_assets
                DW hud_potion_assets
                DW hud_tool_assets
                DW hud_book_assets

assets_count    EQU ($ - assets_table) / 2   ; Number of assets in the table
