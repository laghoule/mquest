; --- Save registers on the stack ---
; Use with RESTORE_REGS
SAVE_REGS MACRO
  ; We can use BP via SP assignment like this to access saved registers
  PUSH BP   ; [BP+12]
  PUSH DI   ; [BP+10]
  PUSH SI   ; [BP+8]
  PUSH DX   ; [BP+6]
  PUSH CX   ; [BP+4]
  PUSH BX   ; [BP+2]
  PUSH AX   ; [BP]
ENDM

; --- Restore registers from the stack ---
; Use with SAVE_REGS
RESTORE_REGS MACRO
  POP AX
  POP BX
  POP CX
  POP DX
  POP SI
  POP DI
  POP BP
ENDM
