; SHL is faster than MUL
CALC_VGA_POSITION MACRO AX, BX
  ; Calculating the position in the VGA memory
  ; DI = (pos_y * 320) + pos_x
  MOV CX, BX
  ; --- No MUL operation, so we use SHL : DI = (Y * 320) + X ---
  ; Calculatin Y * 256 (shifting left of 8)
  MOV BH, BL            ; Fast bitshift of 8 bits
  XOR BL, BL

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
