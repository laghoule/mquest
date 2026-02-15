# Roadmap: Map & Scene System

This document outlines the technical plan for the transition from static, hardcoded map data to a dynamic, externalized Zelda-like scene system for Mia's Herbal Quest.

## Phase 1: Infrastructure & Tooling (Current)

**Goal:** Establish a modern data pipeline from visual editing to ASM binary.

### 1.1 Tiled Integration

Configure Tiled Map Editor for 320x200 resolution:

- Grid size: 20x12 tiles.
- Tile size: 16x16 pixels.

Define standard Layer naming convention:

- `bg` (Background): Opaque terrain.
- `fg` (Foreground): Transparent props and interactable items.

Set export format to JSON.

### 1.2 Go Tooling (The "Packer")

Develop a Go utility to:

- Parse Tiled JSON exports.
- Pack multiple scenes into a single binary file: `world.map`.
- Generate an ASM include file (`world_data.inc`) containing:
  - Offsets for every scene in the binary.
  - Pre-filled SCENE and MAP structures.
  - Adjacency pointers (`sc_north_addr`, `sc_east_addr`, etc.) based on configuration.

### 1.3 ASM Data Structures

Implement embedded structures in MASM:

- `MAP STRUCT`: Pointers to specific data offsets and render types.
- `SCENE STRUCT`: Container for bg, fg, music, and neighbor scene addresses.

Reserve `world_buffer` in the `.DATA` segment to hold the loaded `world.map`.

## Phase 2: Core Game Logic

**Goal:** Implement Zelda-style navigation and world interaction.

### 2.1 Loader & Rendering

- Update `LOAD_FILE` to populate the `world_buffer` at startup.
- Refactor `DRAW_MAP` to utilize the SCENE structure instead of hardcoded labels.
- Implement `SWITCH_SCENE` logic to update render pointers when changing areas.

### 2.2 Zelda-style Transitions

Implement screen-edge detection (North, South, East, West).

Handle scene hopping:

- Load the neighbor SCENE address.
- Reposition the player sprite to the opposite side of the screen.
- Trigger background music changes if specified in the new scene.

### 2.3 World Mutability

Implement item collection logic:

- Calculate the index in the `world_buffer` based on Mia's position.
- Modify the buffer in real-time (writing `VOID_0` to "erase" a collected plant).

## Phase 3: Future Roadmap

**Goal:** Automation and persistence.

- **Advanced Tooling:** Extend the Go tool to handle tileset generation (evolving png2pic).
- **State Persistence:** Implement a system to save/load the `world_buffer` to disk for save games.
- **Advanced Triggers:** Add teleportation flags and scripted events to the tile properties.

## Technical Specifications

| Attribute | Value |
|-----------|-------|
| Screen Resolution | 320x200 (Mode 13h) |
| Map Dimensions | 20x12 tiles (240 bytes per layer) |
| Tile Size | 16x16 pixels |
| Storage Strategy | Single binary world.map loaded into RAM |
| Navigation Style | Screen-by-screen (Zelda-like) |
