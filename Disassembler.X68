*-----------------------------------------------------------
* Title      : 68K Disassembler
* Written by : Chance O'Day, Sara Jackson, and Bonnie Vo
* Date       : 3/6/2015
* Description: Displays an opening message and prompts the
*              user for the start and end addresses for
*              the program to be dissassembled.
*-----------------------------------------------------------
    ORG    $1000
START:          LEA         stack,SP
                LEA         LINE1,A1                *Display welcome message to console
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

****************************************************************************
*-------------------------------------------------------------------------*
****************************************************************************
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
                
                MOVE.W      #$1207,$C0680000   *Fills data to show that following code works correctly.
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
                ROL.W       #8,D7
                MOVE.B      (A2)+,D7        *D7 storing 16 bits of Machine Code into D7. Only WORD data is relevant.
                
                MOVE.W      #$F000,D2                
                AND.W       D7,D2           * D2 storing the nibble representing opcode.
                ROR.L       #8,D2
                ROR.L       #4,D2
                
                MOVE.B      OPCODE_0,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_0
                
                MOVE.B      #OPCODE_1,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_1
                
                MOVE.B      #OPCODE_2,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_2                

                MOVE.B      #OPCODE_3,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_3
                
                MOVE.B      #OPCODE_4,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_4
                
                MOVE.B      #OPCODE_5,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_5
                
                MOVE.B      #OPCODE_6,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_6                

                MOVE.B      #OPCODE_7,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_7

                MOVE.B      #OPCODE_8,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_8
                
                MOVE.B      #OPCODE_9,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_9
                
                MOVE.B      #OPCODE_B,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_B                

                MOVE.B      #OPCODE_C,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_C

                MOVE.B      #OPCODE_D,D3
                CMP.B       D2,D3
                BEQ         PARSE_OP_D
                
                MOVE.B      #OPCODE_E,D3
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
                
                
* USABLE REGISTERS FOR THIS SECTION:  D0-D6, A3-A6 (A0, A1, A7 usable if necessary, but refrain)                
* ANDI,SUBI,EORI,CMPI,BCHG
PARSE_OP_0


* MOVE.B
PARSE_OP_1      LEA         PRINT_MOVE_B,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.W      D7,D6       * D6 stores replicate of 16 bits stored in D7
                MOVE.W      #$003F,D5
                AND.W       D5,D6       * D6 stores Source information
                
                MOVE.W      #%000111,D5 * BitMask for Source register
                AND.W       D6,D5       * D5 stores Source Register
                LSR.W       #3,D6       * D6 stores Source Mode
                
                MOVE.W      D6,D4       * Temp memory for swap
                MOVE.W      D5,D6       * D6 stores Source Register
                MOVE.W      D4,D5       * D5 stores Source Mode
                
                JSR         HANDLE_OPERAND   * Enter Subroutine for Source Handling
                
                LEA         PRINT_COMMA,A1      * Print comma
                MOVE.B      #14,D0
                TRAP        #15         
                
               
                MOVE.W      D7,D6       * D6 stores replicate of 16 bits stored in D7
                MOVE.W      #$0FC0,D5
                AND.W       D5,D6       * D6 stores only Destination information, not shifted.
                LSR.W       #6,D6       * D6 stores Destination info
                
                MOVE.W      #%000111,D5   * BitMask for only mode
                AND.W       D6,D5         * D5 stores Destination Mode
                
                LSR.W       #3,D6         * D6 stores Destination Register
                
                JSR         HANDLE_OPERAND
                
                LEA         CR_LF_MSG,A1      * Print New Line
                MOVE.B      #14,D0
                TRAP        #15
                
                BRA         OP_IDENT


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

*********************************************************************************
*---------------------------Operand Subroutine----------------------------------*
*********************************************************************************
* D6 holds register.  D5 holds mode.
HANDLE_OPERAND          MOVEM.L     D7,-(SP)
                        
                        MOVE.B      #DR_DIRECT,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_0             * Branch to Data Register Direct
                        
                        MOVE.B      #AR_DIRECT,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_1             * Branch to Address Register Direct
                        
                        MOVE.B      #AR_INDIRECT,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_2             * Branch to Address Register Indirect
                        
                        MOVE.B      #AR_INDIRECT_POST,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_3             * Branch to Address Register Indirect w/Post-Incrementing
                        
                        MOVE.B      #AR_INDIRECT_PRE,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_4             * Branch to Address Register Indirect w/Pre-Decrimenting
                        
                        MOVE.B      #ABS_ADDR,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_7             * Branch to Absolute Addressing

* Invalid Destination Mode Handling                        
INVALID_OPERAND_MODE    LEA         INVALID_OPERAND_MODE_MSG,A1        
                        MOVE.B      #14,D0
                        TRAP        #15                     * Print error message for Destination Mode
                        
                        MOVE.L      D5,D1
                        MOVE.B      #15,D0
                        MOVE.B      #2,D2
                        TRAP        #15                     * Print the problematic Destination mode
                        
                        LEA         CR_LF_MSG,A1
                        MOVE.B      #14,D0
                        TRAP        #15                     * Print carriage return/new line
                        
                        
EXIT_HANDLE_OPERAND     MOVEM.L     (SP)+,D7                *Exit HANDLE_DESTINATION subroutine
                        RTS

* Complex part of destination handling

* Data Register Direct                        
OPERAND_MODE_0          LEA         PRINT_D,A1          * Print D
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1               * Print target Register
                        MOVE.B      #15,D0
                        MOVE.B      #10,D2
                        TRAP        #15
                        
* Code goes here
                        BRA         EXIT_HANDLE_OPERAND

* Address Register Direct
OPERAND_MODE_1          LEA         PRINT_A,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1
                        MOVE.B      #15,D0
                        MOVE.B      #10,D2
                        TRAP        #15
   
                        BRA         EXIT_HANDLE_OPERAND

* Address Register Indirect
OPERAND_MODE_2          LEA         PRINT_A_INDIRECT,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1
                        MOVE.B      #15,D0
                        MOVE.B      #10,D2
                        TRAP        #15
                        
                        LEA         PRINT_END_PAREN,A1
                        MOVE.B      #14,D0
                        TRAP        #15       

                        BRA         EXIT_HANDLE_OPERAND

* Address Register Indirect w/Post-Incrementation
OPERAND_MODE_3          LEA         PRINT_A_INDIRECT,A1
                        MOVE.B      #14,D0
                        TRAP        #15

                        MOVE.L      D6,D1
                        MOVE.B      #15,D0
                        MOVE.B      #10,D2
                        TRAP        #15
                        
                        LEA         PRINT_END_PAREN_PLUS,A1
                        MOVE.B      #14,D0
                        TRAP        #15                           

                        BRA         EXIT_HANDLE_OPERAND
                        
* Address Register Indirect w/Pre-Decrementation
OPERAND_MODE_4          LEA         PRINT_MINUS_A_INDIRECT,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1
                        MOVE.B      #15,D0
                        MOVE.B      #10,D2
                        TRAP        #15
                        
                        LEA         PRINT_END_PAREN,A1
                        MOVE.B      #14,D0
                        TRAP        #15

                        BRA         EXIT_HANDLE_OPERAND
                        
* Absolute Addressing
OPERAND_MODE_7          
* Code goes here
                        BRA         EXIT_HANDLE_OPERAND   
                     
*********************************************************************************
*-------------------------------------------------------------------------------*
*********************************************************************************



END                      
                              
    SIMHALT             ; halt simulator

* Put variables and constants here
stack               EQU             $7000   *Stack pointer start location

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

DR_DIRECT           EQU             %000    * Data Register Direct Mode
AR_DIRECT           EQU             %001    * Address Register Direct Mode
AR_INDIRECT         EQU             %010    * Address Register Indirect Mode
AR_INDIRECT_POST    EQU             %011    * Address Register Indirect Post-Incrementing Mode
AR_INDIRECT_PRE     EQU             %100    * Address Register Inderect Pre-Decrementing Mode
ABS_ADDR            EQU             %111    * Absolute Address and Immediate Data Mode

ABS_ADDR_WORD_REG   EQU             %000    * Absolute Word Address Register
ABS_ADDR_LONG_REG   EQU             %001    * Absolute Long Address Register
IMMEDIATE_DATA      EQU             %100    * Immediate Data Register


LINE1               DC.B        'Welcome to our 68K Dissassembler.',CR,LF,0
GETSTARTMESSAGE     DC.B        'Please provide a valid start address.',CR,LF,0
GETENDMESSAGE       DC.B        'Please provide a valid end address.',CR,LF,0
ERRORMESSAGESIZE    DC.B        'The input you have provided is not 32 bits long.  Please provide a valid address',CR,LF,0
INVALID_OPERAND_MODE_MSG   DC.B 'The following operand mode is invalid: ',0
PRINT_D             DC.B        'D',0
PRINT_COMMA         DC.B        ',',0
PRINT_A             DC.B        'A',0
PRINT_A_INDIRECT    DC.B        '(A',0
PRINT_END_PAREN     DC.B        ')',0
PRINT_END_PAREN_PLUS    DC.B    ')+',0
PRINT_MINUS_A_INDIRECT  DC.B    '-(',0
PRINT_DOLLAR        DC.B        '$',0
PRINT_NUM_DOLLAR    DC.B        '#$',0


BUGFIXMESSAGE       DC.B        'This message is loaded to resolve a bug, and should never be printed.',CR,LF,0
INVALID_OP_MSG      DC.B        'Invalid Operation Code: ',0
CR_LF_MSG           DC.B        CR,LF,0
TAB_MSG             DC.B        HT,0

PRINT_MOVE_B        DC.B        'MOVE.B',HT,0

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
