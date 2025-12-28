SAVE_REGS MACRO
  PUSH AX
  PUSH BX
  PUSH CX
  PUSH DX
  PUSH SI
  PUSH DI
ENDM

RESTORE_REGS MACRO
  POP DI
  POP SI
  POP DX
  POP CX
  POP BX
  POP AX
ENDM

; SHL is faster than MUL
CALC_VGA_POSITION MACRO pos_x, pos_y
  ; Calculating the position in the VGA memory
  ; DI = (pos_y * 320) + pos_x
  MOV AX, pos_y
  MOV BX, AX
  ; --- No MUL operation, so we use SHL : DI = (Y * 320) + X ---
  MOV CL, 8
  SHL BX, CL            ; BX = Y * 256
  ; Calculing Y * 64 (shifting left of 6)
  MOV CL, 6
  SHL AX, CL            ; AX = Y * 64

  ADD AX, BX            ; AX = (Y * 64) + (Y * 256) = Y * 320
  ADD AX, pos_x         ; AX = (Y * 320) + X

  MOV DI, AX
ENDM

; Wait for the vertical sync
; https://www.scs.stanford.edu/22wi-cs212/pintos/specs/freevga/vga/vgacrtc.htm
WAIT_VSYNC MACRO
  LOCAL wait_start, wait_end
  MOV DX, 03DAh
wait_start:
  IN AL, DX
  TEST AL, 8
  JZ wait_start
wait_end:
  IN AL, DX
  TEST AL, 8
  JNZ wait_end
ENDM
