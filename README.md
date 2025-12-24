# Assembly Sprites

A collection of assembly language examples for sprite manipulation on 8086 processors in 16-bit real mode.

## Files

All assembly source files are located in the `src/` directory.

- `basic.asm`: A basic sprite example that displays a static sprite.
- `moving.asm`: An example of a moving sprite controlled by the keyboard.
- `vsync.asm`: An example of using vertical synchronization (vsync) for smooth animation.
- `anim.asm`: An example of an animated sprite.

## Definitions and macros

All the useful macros and constants are defined in the `defs/` directory.

## Assets

The `assets/` directory contains sprite data that is included in the assembly files.

- `mario.inc`: Sprite data for Mario.
- `girl.inc`: Sprite data for a girl character.
- `anim.inc`: Sprite data for the animated girl.
- `testing.inc`: Sprite data for testing purposes.
- `testing2.inc`: Sprite data for testing purposes.

The `raw/` directory contains the original images used to create the sprite data.

## How to Use

To assemble and run these examples, you will need:

1.  **MASM (Microsoft Macro Assembler)** or a compatible assembler (like TASM).
2.  **A DOS emulator (like DOSBox)**: To run the compiled programs.

### Assembling

The `.asm` files are intended to be assembled into `.COM` files. Since this project uses MASM 6.11 running under DOSBox on Linux, you'll need to:

1. **Set up DOSBox**: Mount your project directory and configure it to access MASM 6.11
2. **Use MASM in DOSBox**: Run the assembly and linking commands within the DOSBox environment

#### Basic DOSBox Setup

In your DOSBox configuration or at the DOSBox prompt:

```bash
mount c /path/to/your/sprites
c:
```

#### Assembling with MASM 6.11

To assemble an assembly file, use the `ml.exe` command with the `/TINY` flag (for `.COM` files):

```bash
ml /TINY src/basic.asm
```

This will create `basic.com` in the current directory.

For more control over the build process, you can compile and link separately:

```bash
ml /c /omf /Fo"basic.obj" "src/basic.asm"
link /TINY "basic.obj", "basic.com";
```

**Note**: Make sure MASM 6.11 is in your PATH within DOSBox, or provide the full path to `ml.exe`.

### Running

To run the compiled program, open it in your DOS emulator. For example, in DOSBox:

```
mount c .
c:
basic.com
```
