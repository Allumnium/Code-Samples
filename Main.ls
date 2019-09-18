//This LS file has been modified to hide any proprietary or confidential information.
//deleted lines 1-11 and most of header

/PROG  MAIN
COMMENT		= "Pick & Place";

  11:  IF (GI[1:Prod Code]=3) THEN ;
  12:  OVERRIDE=50% ;
  13:  ELSE ;
  14:  OVERRIDE=70% ;
  15:  ENDIF ;
  16:   ;
  17:  UFRAME_NUM=1 ;
  18:   ;
  19:  LBL[1] ;
  20:  CALL INIT_IO    ;
  21:   ;
  22:  --eg:Stop timing the cycle if not in autorun ;
  23:  TIMER[1]=STOP ;
  24:   ;
  25:  LBL[5] ;
  34:  CALL GO_HOME    ;
  35:  F[1:PLC RUN]=(OFF) ;
  36:   ;
  37:  !Wait for ok to cycle start ;
  38:  IF DI[3:Autorun]<>ON,JMP LBL[20] ;
  39:  --eg:Initialize the autorun mode ;
  40:  CALL INIT_CYCLESTART    ;
  41:  IF DI[3:Autorun]=OFF,JMP LBL[1] ;
  42:   ;
  43:  !Auto cycle ;
  44:  LBL[10] ;
  45:  IF DI[3:Autorun]=OFF,JMP LBL[1] ;
  46:  !Pick, Process, and Place ;
  47:  CALL PICK    ;
  48:  IF DI[14:AIR OK]=OFF,JMP LBL[1] ;
  49:  CALL PROCESS    ;
  50:  IF DI[14:AIR OK]=OFF,JMP LBL[1] ;
  51:  CALL PLACE    ;
  52:  IF DI[14:AIR OK]=OFF,JMP LBL[1] ;
  53:  --eg:Turn off first cycle flag ;
  54:  F[2:First Cycle]=(OFF)    ;
  55:  JMP LBL[10] ;
  56:   ;
  57:  --eg:Manual cycle ;
  58:  LBL[20] ;
  60:  DO[3:In Auto]=OFF ;
  61:  R[105:Manual Mode]=1    ;
  63:  GO[3:Prod echo]=(0) ;
  33:   ;
  64:  --eg:Go maint and open/close grippers ;
  65:  IF DI[18:Req Maint]=ON,CALL GO_MAINT ;
  66:  IF DI[19:Req open]=ON,CALL OPEN ;
  67:  IF DI[20:Req Close]=ON,CALL CLOSE ;
  68:  --eg:Stop monitoring the overheat alarm ;
  69:  MONITOR END MON_FAULT_CODES ;
  70:  WAIT    .25(sec) ;
  71:  JMP LBL[5] ;
/POS
/END
