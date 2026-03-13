;  Copyright (C) 2025, 2026 Pascal Gauthier
;  This program is free software: you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation, either version 3 of the License.

;----------------------------------------------------------------
; CHECK_SCENE_TRANSITION
; Description: Check if the player is on a scene transition direction
; Input:
; Output:
; Modifed: curr_scne
;----------------------------------------------------------------
CHECK_SCENE_TRANSITION PROC
  SAVE_REGS

  LEA BX, mia_data
  
  ; North  
  ; South
  ; East
  ; West
  
  RESTORE_REGS
  RET
CHECK_SCENE_TRANSITION ENDP
