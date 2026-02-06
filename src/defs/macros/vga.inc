; SHL is faster than MUL
CALC_VGA_POSITION MACRO AX, BX
  ; Calculating the position in the VGA memory
  ; DI = (pos_y * 320) + pos_x
  MOV CX, BX
  ; --- No MUL operation, so we use SHL : DI = (Y * 320) + X ---
  ; Calculatin Y * 256 (shifting left of 8)
  SHL BX, 1             ; BX = Y * 256
  SHL BX, 1
  SHL BX, 1
  SHL BX, 1
  SHL BX, 1
  SHL BX, 1
  SHL BX, 1
  SHL BX, 1
  ; Calculing Y * 64 (shifting left of 6)
  SHL CX, 1             ; AX = Y * 64
  SHL CX, 1
  SHL CX, 1
  SHL CX, 1
  SHL CX, 1
  SHL CX, 1

  ADD CX, BX            ; AX = (Y * 64) + (Y * 256) = Y * 320
  ADD AX, CX            ; AX = (Y * 320) + X

  MOV DI, AX
ENDM

; Synchronize with the vertical retrace to avoid screen tearing
; https://www.scs.stanford.edu/22wi-cs212/pintos/specs/freevga/vga/vgacrtc.htm
WAIT_VSYNC MACRO
  LOCAL wait_start, wait_end
  MOV DX, 03DAh
wait_end:
  IN AL, DX
  TEST AL, 8
  JNZ wait_end  ; Wait for the end of the vertical sync
wait_start:
  IN AL, DX
  TEST AL, 8
  JZ wait_start ; Wait for the start of the vertical sync
ENDM
