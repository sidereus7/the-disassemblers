*-----------------------------------------------------------
* Title      : Opening Screen Project
* Written by : Chance O'Day
* Date       : 3/6/2015
* Description: Displays an opening message and prompts the
*              user for the start and end addresses for
*              the program to be dissassembled.
*-----------------------------------------------------------
    ORG    $1000
START:          LEA         LINE1,A1
                MOVE.B      #14,D0
                TRAP        #15
            
                LEA         GETSTARTMESSAGE,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.B      #1,D7
                MOVE.B      #0,D6
            
PROMPTSTARTADDR MOVEA.L     #$5000,A1
                MOVE.B      #2,D0
                TRAP        #15
            
                MOVE.B      #8,D2
                CMP.W       D1,D2
                BNE         ERRORINPUTSIZE
                MOVE.B      #4,D2
                MOVE.B      #0,D3
                
                MOVE.L      #$12345678,STARTADDRSTRING1   *TEST             
                LEA         STARTADDRSTRING1,A2
LOADSTARTADDR1  MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADSTARTADDR1
                
                MOVE.B      #0,D3
                MOVEA.L     STARTADDRSTRING2,A2
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
                
                MOVE.B      #0,D3
                MOVEA.L     ENDADDRSTRING1,A2
LOADENDADDR1    MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADENDADDR1
                
                MOVE.B      #0,D3
                MOVEA.L     ENDADDRSTRING2,A2
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
                
                MOVE.L      STARTADDRSTRING1,D0
                
            

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

ENDADDRSTRING1      DS.L        1
ENDADDRSTRING2      DS.L        1
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
