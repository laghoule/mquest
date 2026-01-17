; --- Save registers on the stack ---
; Use with RESTORE_REGS
SAVE_REGS MACRO
  PUSH AX
  PUSH BX
  PUSH CX
  PUSH DX
  PUSH SI
  PUSH DI
ENDM

; --- Restore registers from the stack ---
; Use with SAVE_REGS
RESTORE_REGS MACRO
  POP DI
  POP SI
  POP DX
  POP CX
  POP BX
  POP AX
ENDM
