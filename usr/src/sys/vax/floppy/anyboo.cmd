!
! BOOTSTRAP ANY DEVICE TO A SINGLE USER SHELL
!
SET DEF HEX
SET DEF LONG
SET REL:0
HALT
UNJAM
INIT
LOAD BOOT
D R11 3		! 3=RB_ASKNAME+RB_SINGLE
! R10 NICHTS	! DEVICE CHOICE ISNT APPLICABLE
START 2
