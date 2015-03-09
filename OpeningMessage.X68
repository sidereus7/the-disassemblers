*-----------------------------------------------------------
* Title      : Opening Screen Project
* Written by : Chance O'Day
* Date       : 3/6/2015
* Description: Displays an opening message and prompts the
*              user for the start and end addresses for
*              the program to be dissassembled.
*-----------------------------------------------------------
    ORG    $1000
START:          LEA         LINE1,A1                *Display welcome message to console
                MOVE.B      #14,D0
                TRAP        #15
            
                LEA         GETSTARTMESSAGE,A1      *Display prompt for start address
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.B      #1,D7
                MOVE.B      #0,D6                   *Toggle for start/end address prompting: 0 = start, 1 = end
            
PROMPTSTARTADDR MOVEA.L     #$5000,A1
                MOVE.B      #2,D0
                TRAP        #15
            
                MOVE.B      #8,D2
                CMP.W       D1,D2
                BNE         ERRORINPUTSIZE
                MOVE.B      #4,D2
                MOVE.B      #0,D3
                            
                LEA         STARTADDRSTRING1,A2
LOADSTARTADDR1  MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADSTARTADDR1
                
                MOVE.B      #0,D3
                LEA         STARTADDRSTRING2,A2
LOADSTARTADDR2  MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADSTARTADDR2
                BRA         ENDADDR
            
ERRORINPUTSIZE  LEA         ERRORMESSAGESIZE,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         BUGFIXMESSAGE,A1
                CMP.B       D7,D6
                BNE         PROMPTSTARTADDR
                BRA         PROMPTENDADDR
                
ENDADDR         LEA         GETENDMESSAGE,A1
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #1,D6
                MOVE.B      #8,D2
                
                
PROMPTENDADDR   MOVEA.L     #$5000,A1
                MOVE.B      #2,D0
                TRAP        #15
                
                CMP.W       D1,D2
                BNE         ERRORINPUTSIZE
                
                MOVE.B      #4,D2
                MOVE.B      #0,D3
                LEA         ENDADDRSTRING1,A2
LOADENDADDR1    MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADENDADDR1
                
                MOVE.B      #0,D3
                LEA         ENDADDRSTRING2,A2
LOADENDADDR2    MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADENDADDR2
                               
CONVERTSTART1   MOVE.L      STARTADDRSTRING1,D1
                MOVE.B      #0,D6
                MOVE.B      #4,D5
                MOVE.B      #$39,D3
                
NEXTCHAR        MOVE.B      D1,D2
                CMP.B       D2,D3
                BLT         CHARISLETTER
                
CHARISNUM       SUB.B       #48,D2
                MOVE.B      D2,D7
                ROR.L       #4,D7
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         CONVERTSTART2
                BRA         NEXTCHAR

CHARISLETTER    SUB.B       #55,D2
                MOVE.B      D2,D7
                ROR.L       #4,D7
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         CONVERTSTART2
                BRA         NEXTCHAR
                
CONVERTSTART2   MOVE.L      STARTADDRSTRING2,D1
                MOVE.B      #0,D6
                MOVE.B      #4,D5
                MOVE.B      #$39,D3
                
NEXTCHAR2       MOVE.B      D1,D2
                CMP.B       D2,D3
                BLT         CHARISLETTER2

CHARISNUM2      SUB.B       #48,D2
                MOVE.B      D2,D4
                ROR.L       #4,D4
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         COMBINESTART
                BRA         NEXTCHAR2

                
CHARISLETTER2   SUB.B       #55,D2
                MOVE.B      D2,D4
                ROR.L       #4,D4
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         COMBINESTART
                BRA         NEXTCHAR2
                
COMBINESTART    ROR.L       #8,D4
                ROR.L       #8,D4
                ADD.L       D4,D7
                MOVE.L      D7,HEXSTARTADDR
                MOVE.L      #$00000000,D7
                MOVE.L      #$00000000,D4
                
CONVERTEND1     MOVE.L      ENDADDRSTRING1,D1
                MOVE.B      #0,D6
                MOVE.B      #4,D5
                MOVE.B      #$39,D3
                
NEXTCHAR3       MOVE.B      D1,D2
                CMP.B       D2,D3
                BLT         CHARISLETTER3
                
CHARISNUM3      SUB.B       #48,D2
                MOVE.B      D2,D7
                ROR.L       #4,D7
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         CONVERTEND2
                BRA         NEXTCHAR3

CHARISLETTER3   SUB.B       #55,D2
                MOVE.B      D2,D7
                ROR.L       #4,D7
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         CONVERTEND2
                BRA         NEXTCHAR3
                
CONVERTEND2     MOVE.L      ENDADDRSTRING2,D1
                MOVE.B      #0,D6
                MOVE.B      #4,D5
                MOVE.B      #$39,D3
                
NEXTCHAR4       MOVE.B      D1,D2
                CMP.B       D2,D3
                BLT         CHARISLETTER4

CHARISNUM4      SUB.B       #48,D2
                MOVE.B      D2,D4
                ROR.L       #4,D4
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         COMBINEEND
                BRA         NEXTCHAR4

                
CHARISLETTER4   SUB.B       #55,D2
                MOVE.B      D2,D4
                ROR.L       #4,D4
                ROR.L       #8,D1
                ADD.B       #1,D6
                CMP.B       D6,D5
                BEQ         COMBINEEND
                BRA         NEXTCHAR4
                
COMBINEEND      ROR.L       #8,D4
                ROR.L       #8,D4
                ADD.L       D4,D7
                MOVE.L      D7,HEXENDADDR
                MOVE.L      #$00000000,D7
                MOVE.L      #$00000000,D4

                MOVE.L      HEXSTARTADDR,D0
                MOVE.L      HEXENDADDR,D1
                
                MOVE.L      STARTADDRSTRING1,D2
                MOVE.L      STARTADDRSTRING2,D3
                MOVE.L      ENDADDRSTRING1,D4
                MOVE.L      ENDADDRSTRING2,D5
            

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here
CR                  EQU             $0D
LF                  EQU             $0A

LINE1               DC.B        'Welcome to our 68K Dissassembler.',CR,LF,0
GETSTARTMESSAGE     DC.B        'Please provide a valid start address.',CR,LF,0
GETENDMESSAGE       DC.B        'Please provide a valid end address.',CR,LF,0
ERRORMESSAGESIZE    DC.B        'The input you have provided is not 32 bits long.  Please provide a valid address',CR,LF,0

BUGFIXMESSAGE       DC.B        'This does nothing, and should never appear.',CR,LF,0

STARTADDRSTRING1    DS.L        1
STARTADDRSTRING2    DS.L        1
HEXSTARTADDR        DS.L        1

ENDADDRSTRING1      DS.L        1
ENDADDRSTRING2      DS.L        1
HEXENDADDR          DS.L        1
    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
