*-----------------------------------------------------------
* Title      : Opening Screen Project
* Written by : Chance O'Day, Sara Jackson, and Bonnie Vo
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
            
PROMPTSTARTADDR MOVE.B      #2,D0
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

*  TEST CODE FOR DEMONSTRATING THE VALUES IN THE VARIABLES                
*                MOVE.L      HEXSTARTADDR,D0
*                MOVE.L      HEXENDADDR,D1
                
*                MOVE.L      STARTADDRSTRING1,D2
*                MOVE.L      STARTADDRSTRING2,D3
*                MOVE.L      ENDADDRSTRING1,D4
*                MOVE.L      ENDADDRSTRING2,D5

* Clear all registers to move on to next segment
                CLR.L       D0
                CLR.L       D1
                CLR.L       D2
                CLR.L       D3
                CLR.L       D4
                CLR.L       D5
                CLR.L       D6
                CLR.L       D7
                MOVE.L      D0,A0
                MOVE.L      D0,A1
                MOVE.L      D0,A2
                MOVE.L      D0,A3
                MOVE.L      D0,A4
                MOVE.L      D0,A5
                MOVE.L      D0,A6
                MOVE.L      D0,A7
                
                MOVE.W      #$AABB,$C0680000   *Fills data to show that following code works correctly.
BEGIN_OP_IDENT  MOVE.L      HEXSTARTADDR,A2    *A2 is RESERVED for walking through the target code.

OP_IDENT        MOVE.L      HEXENDADDR,D0
                MOVE.L      A2,D1
                CMP.L       D0,D1
                BGT         END

                MOVE.L      A2,D1           *Print current address.  TODO: Add tab
                MOVE.B      #15,D0
                MOVE.B      #16,D2
                TRAP        #15
                
                LEA         TAB_MSG,A1
                MOVE.B      #14,D0
                TRAP        #15

                MOVE.B      (A2)+,D7
                ROL.L       #8,D7
                MOVE.B      (A2)+,D7
                
                MOVE.W      #$F000,D2                  
                AND.W       D7,D2           * D2 storing the nibble representing opcode.
                ROR.L       #8,D2
                ROR.L       #4,D2
                
                MOVE.B      OPCODE_0,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_0
                
                MOVE.B      OPCODE_1,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_1
                
                MOVE.B      OPCODE_2,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_2                

                MOVE.B      OPCODE_3,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_3
                
                MOVE.B      OPCODE_4,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_4
                
                MOVE.B      OPCODE_5,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_5
                
                MOVE.B      OPCODE_6,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_6                

                MOVE.B      OPCODE_7,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_7

                MOVE.B      OPCODE_8,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_8
                
                MOVE.B      OPCODE_9,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_9
                
                MOVE.B      OPCODE_B,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_B                

                MOVE.B      OPCODE_C,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_C

                MOVE.B      OPCODE_D,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_D
                
                MOVE.B      OPCODE_E,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_E
                                
                
                *CASE where nothing matched, bad data. report to user. Skip to next 16 bit code
NO_OP_MATCH     LEA         INVALID_OP_MSG,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.L      D2,D1
                MOVE.B      #15,D0
                MOVE.B      #2,D2
                TRAP        #15
                
                LEA         CR_LF_MSG,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                BRA         OP_IDENT
                
                
                
* ANDI,SUBI,EORI,CMPI,BCHG
PARSE_OP_0

* MOVE.B
PARSE_OP_1

* MOVE.L
PARSE_OP_2

* MOVE.W
PARSE_OP_3

* CLR,RTS,JSR,MOVEM,LEA
PARSE_OP_4

* ADDQ
PARSE_OP_5

* BCC
PARSE_OP_6

* MOVEQ
PARSE_OP_7

* DIVS
PARSE_OP_8

* SUB,SUBA
PARSE_OP_9

* EOR,CMP,CMPA
PARSE_OP_B

* AND,MULS
PARSE_OP_C

* ADD,ADDA
PARSE_OP_D

* ASL,ASR,LSL,LSR,ROL,ROR
PARSE_OP_E

END                      
                              
    SIMHALT             ; halt simulator

* Put variables and constants here
CR                  EQU             $0D     * Carriage Return
LF                  EQU             $0A     * Line Feed
HT                  EQU             $09     * Horizontal Tab

OPCODE_0            EQU             %0000   * ANDI,SUBI,EORI,CMPI,BCHG
OPCODE_1            EQU             %0001   * MOVE.B
OPCODE_2            EQU             %0010   * MOVE.L
OPCODE_3            EQU             %0011   * MOVE.W
OPCODE_4            EQU             %0100   * CLR,RTS,JSR,MOVEM,LEA
OPCODE_5            EQU             %0101   * ADDQ
OPCODE_6            EQU             %0110   * BCC
OPCODE_7            EQU             %0111   * MOVEQ
OPCODE_8            EQU             %1000   * DIVS
OPCODE_9            EQU             %1001   * SUB,SUBA
OPCODE_B            EQU             %1011   * EOR,CMP,CMPA
OPCODE_C            EQU             %1100   * AND,MULS
OPCODE_D            EQU             %1101   * ADD,ADDA
OPCODE_E            EQU             %1110   * ASL,ASR,LSL,LSR,ROL,ROR


LINE1               DC.B        'Welcome to our 68K Dissassembler.',CR,LF,0
GETSTARTMESSAGE     DC.B        'Please provide a valid start address.',CR,LF,0
GETENDMESSAGE       DC.B        'Please provide a valid end address.',CR,LF,0
ERRORMESSAGESIZE    DC.B        'The input you have provided is not 32 bits long.  Please provide a valid address',CR,LF,0

BUGFIXMESSAGE       DC.B        'This does nothing, and should never appear.',CR,LF,0
INVALID_OP_MSG      DC.B        'Invalid Operation Code: ',0
CR_LF_MSG           DC.B        CR,LF,0
TAB_MSG             DC.B        HT,0

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
