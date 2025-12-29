# Mia's Herbal Quest

A retro adventure game developed in **8086 Assembly**, designed specifically for the **IBM PC-XT** architecture running MS-DOS.

## The Story

Mia is a young herbalist apprentice. Her grandmother has fallen ill, and the only cure is a remedy made from three rare plants hidden deep within the mystical forest. Players must guide Mia through the woods, navigating obstacles and searching for the ingredients to save her grandmother.

## Technical Specifications

- **Target Hardware:** IBM PC-XT / Pocket 8086.
- **Processor:** Optimized for **AMD 8088-1 (10 MHz)** and **NEC V30**.
- **Graphics:** VGA Mode 13h (320x200, 256 colors).
- **Language:** 8086 Assembly (MASM 6.11 syntax).
- **Development Environment:**
  - **OS:** Linux (Cross-development).
  - **IDE:** Zed.
  - **Tools:** [Custom Go script for PNG-to-ASM conversion](https://github.com/laghoule/png2asm).
  - **Emulator:** DOSBox-X for rapid testing.

## Current Features

- **Unified Rendering Engine:** A single, optimized procedure to draw characters with transparency support.
- **4-Directional Movement:** Full control of Mia (Up, Down, Left, Right).
- **Walk Animation:** 3-frame animation cycle per direction for fluid movement.
- **VSync Synchronization:** Implemented "Wait for Vertical Retrace" to ensure flicker-free rendering at a stable 60/70 FPS.
- **High-Performance Math:** Address calculations optimized using bit-shifting (`SHL`) instead of the costly `MUL` instruction, specifically tuned for the 8088's 8-bit bus.
- **Non-Blocking Input:** Real-time keyboard sensing using BIOS interrupts (AH=01h).

## Roadmap

- [ ] **Background Restoration System:** Implement "Save/Restore" buffer logic to allow Mia to walk over complex terrains without erasing them.
- [ ] **Tiled Map Engine:** Create a "Flip-Screen" world navigation system (Zelda-style).
- [ ] **Collision Detection:** Implement tile-based or pixel-based collision sensing.
- [ ] **OPL3 Sound:** Integrate music and sound effects using the Yamaha YMF262 chip.
- [ ] **Joystick Support:** Add support for analog game controllers via Port 201h.

## Assets

- **Character Sprites:** Custom 16x17 pixel art by ***Fleurman*** via [OpenGameArt.org](https://opengameart.org/content/tiny-characters-set).
- **Environment Tiles:** Based on the "Batch 5" (16x16) tileset by **Hyptosis** via [OpenGameArt.org](https://opengameart.org/content/lots-of-free-2d-tiles-and-sprites-by-hyptosis).

## Build Instructions

1.  Convert sprites using the Go tool: `go run main.go -src sprite.png -dst assets/sprite.inc`
2.  Assemble using MASM 6.11: `ml /Zi mia.asm`
3.  Run in DOSBox or transfer to hardware via Diskette :)

---

_This project is a personal journey into low-level programming, bringing modern development workflows to the classic 8086/8088 architecture. It's a tribute to the era of early PCs._
