; ASSETS struct <file_addr, buffer_addr>
grandma_assets  ASSETS <OFFSET grandma_tile_file, OFFSET grandma_buffer>
mia_assets      ASSETS <OFFSET mia_tile_file,     OFFSET mia_buffer>

; Assets table is the list of all assets in the game
assets_table    DW grandma_assets
                DW mia_assets
assets_count    EQU ($ - assets_table) / 2   ; Number of assets in the table
