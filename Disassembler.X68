*-----------------------------------------------------------
* Title      :  68K Disassembler
* Written by :  Chance O'Day, Sara Jackson, and Bonnie Vo
* Date       :  3/6/2015
* Description:  A disassembler program that will convert a
*               memory image of instructions and data back
*               to 68000 assembly language and output the
*               disassembled code to the display.
*
*               Displays an opening message and prompts
*               the user for the start and end address
*               for the program to be disassembled.
*-----------------------------------------------------------
                ORG         $1000
START:          LEA         stack,SP
                LEA         LINE1,A1                * Display welcome message to console
                MOVE.B      #14,D0
                TRAP        #15
            
                LEA         GETSTARTMESSAGE,A1      * Display prompt for start address
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.B      #1,D7
                MOVE.B      #0,D6                   * Toggle for start/end address prompting: 0 = start, 1 = end
            
PROMPTSTARTADDR MOVE.B      #2,D0                   * Read starting address string from console
                TRAP        #15
            
                MOVE.B      #8,D2
                CMP.W       D1,D2                   * Check start address size
                BNE         ERRORINPUTSIZE          * Branch if address size error
                MOVE.B      #4,D2
                MOVE.B      #0,D3
                            
                LEA         STARTADDRSTRING1,A2     * Load ASCII of the first half of start address to A2 register
LOADSTARTADDR1  MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADSTARTADDR1
                
                MOVE.B      #0,D3
                LEA         STARTADDRSTRING2,A2     * Load ASCII of the second half of start address to A2 register
LOADSTARTADDR2  MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADSTARTADDR2
                BRA         ENDADDR
            
ERRORINPUTSIZE  LEA         ERRORMESSAGESIZE,A1     * Start/End Address Error
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         BUGFIXMESSAGE,A1
                CMP.B       D7,D6
                BNE         PROMPTSTARTADDR
                BRA         PROMPTENDADDR
                
ENDADDR         LEA         GETENDMESSAGE,A1        * Display prompt for end address
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #1,D6
                MOVE.B      #8,D2
                
                
PROMPTENDADDR   MOVEA.L     #$5000,A1
                MOVE.B      #2,D0                   * Read end address string from console
                TRAP        #15
                
                CMP.W       D1,D2                   * Check end address size
                BNE         ERRORINPUTSIZE          * Branch if address size error
                
                MOVE.B      #4,D2
                MOVE.B      #0,D3
                LEA         ENDADDRSTRING1,A2       * Load ASCII of the first half of end address to A2 register
LOADENDADDR1    MOVE.B      (A1)+,(A2)+
                ADD.B       #1,D3
                CMP.B       D2,D3
                BNE         LOADENDADDR1
                
                MOVE.B      #0,D3
                LEA         ENDADDRSTRING2,A2       * Load ASCII of the second half of end address to A2 register
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
*--------------------------------------------------------------------------*
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

*-----------------------TEST CODE-----------------------------------------------------                
                MOVE.W      #$1207,$C0680000        * MOVE.B  D7,D1
                
                MOVE.W      #$143C,$C0680002        * MOVE.B  #$17,D2
                MOVE.B      #$00,$C0680004
                MOVE.B      #$17,$C0680005
                
                MOVE.B      #$1A,$C0680006          * MOVE.B  #$33,(A5)
                MOVE.B      #$BC,$C0680007
                MOVE.B      #$00,$C0680008
                MOVE.B      #$33,$C0680009
                
                MOVE.B      #$98,$C068000A
                MOVE.B      #$14,$C068000B          * SUB.B  (A4),D4
                
                MOVE.B      #$94,$C068000C
                MOVE.B      #$44,$C068000D          * SUB.W  D4,D2
                
                MOVE.B      #$95,$C068000E
                MOVE.B      #$94,$C068000F          * SUB.L  D2,(A4)
                
                MOVE.B      #$92,$C0680010 
                MOVE.B      #$DC,$C0680011          * SUBA.W (A4)+,A1
                
                MOVE.B      #$99,$C0680012
                MOVE.B      #$CF,$C0680013          * SUBA.L  A7,A4
                
                MOVE.W      #$0204,$C0680014        * ANDI.B    #$33,D4
                MOVE.W      #$0033,$C0680016
                
                MOVE.W      #$0253,$C0680018        * ANDI.W    #$8888,(A3)
                MOVE.W      #$8888,$C068001A
                
                MOVE.W      #$029B,$C068001C        * ANDI.L    #$AAAAAAAA,(A3)+
                MOVE.W      #$AAAA,$C068001E
                MOVE.W      #$AAAA,$C0680020
                
                MOVE.W      #$0414,$C0680022        * SUBI.B    #$AA,(A4)
                MOVE.W      #$00AA,$C0680024
                
                MOVE.W      #$0444,$C0680026        * SUBI.W    #$8888,D4
                MOVE.W      #$8888,$C0680028
                
                MOVE.W      #$0484,$C068002A        * SUBI.L    #$AAAAAAAA,D4
                MOVE.W      #$AAAA,$C068002C
                MOVE.W      #$AAAA,$C068002E
                
                MOVE.W      #$0A24,$C0680030        * EORI.B    #$33,-(A4)
                MOVE.W      #$0033,$C0680032
                
                MOVE.W      #$0A44,$C0680034        * EORI.W    #$AAAA,D4
                MOVE.W      #$AAAA,$C0680036
                
                MOVE.W      #$0A84,$C0680038        * EORI.L    #$12345678,D4
                MOVE.W      #$1234,$C068003A
                MOVE.W      #$5678,$C068003C
                
                MOVE.W      #$0C03,$C068003E        * CMPI.B    #$11,D3
                MOVE.W      #$0011,$C0680040
                
                MOVE.W      #$0C46,$C0680042        * CMPI.W    #$1234,D6
                MOVE.W      #$1234,$C0680044
                
                MOVE.W      #$0C84,$C0680046        * CMPI.L    #$AAAAAAAA,D4
                MOVE.W      #$AAAA,$C0680048
                MOVE.W      #$AAAA,$C068004A
                
                MOVE.W      #$0953,$C068004C        * BCHG.B    D4,(A3)
                
                MOVE.W      #$085C,$C068004E        * BCHG.B    #$44,(A4)+
                MOVE.W      #$0044,$C0680050
                
                MOVE.W      #$0742,$C0680052        * BCHG.L    D3,D2
                
                MOVE.W      #$0843,$C0680054        * BCHG.L    #AAAAAAAA,D3
                MOVE.W      #$AAAA,$C0680056
                MOVE.W      #$AAAA,$C0680058

                
              * 0001 0100 0011 1100   = binary for MOVE.B immediate data to D2
*--------------------------------------------------------------------------
                
BEGIN_OP_IDENT  MOVE.L      HEXSTARTADDR,A2         * A2 is RESERVED for walking through the target code.

OP_IDENT        MOVE.L      HEXENDADDR,D0
                MOVE.L      A2,D1
                CMP.L       D0,D1
                BGT         END                     * Branch to end if current address is greater than ending address.

                MOVE.L      A2,D1                   * Generate ASCII of current address
                MOVE.L      #8,D2
                JSR         HEX_TO_ASCII
                
                LEA         ASCII_RESULT,A1            * Print current address
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         TAB_MSG,A1
                MOVE.B      #14,D0
                TRAP        #15

                MOVE.B      (A2)+,D7       
                ROL.W       #8,D7
                MOVE.B      (A2)+,D7                * D7 storing 16 bits of Machine Code into D7. Only WORD data is relevant.
                
                MOVE.W      #$F000,D2                
                AND.W       D7,D2                   * D2 storing the nibble representing opcode.
                ROR.L       #8,D2
                ROR.L       #4,D2
                
                MOVE.B      #OPCODE_0,D3            * ANDI,SUBI,EORI,CMPI,BCHG
                CMP.B       D2,D3
                BEQ         PARSE_OP_0
                
                MOVE.B      #OPCODE_1,D3            * MOVE BYTE
                CMP.B       D2,D3
                BEQ         PARSE_OP_1
                
                MOVE.B      #OPCODE_2,D3            * MOVE LONG
                CMP.B       D2,D3
                BEQ         PARSE_OP_2                

                MOVE.B      #OPCODE_3,D3            * MOVE WORD
                CMP.B       D2,D3
                BEQ         PARSE_OP_3
                
                MOVE.B      #OPCODE_4,D3            * CLR,RTS,JSR,MOVEM,LEA
                CMP.B       D2,D3
                BEQ         PARSE_OP_4
                
                MOVE.B      #OPCODE_5,D3            * ADDQ
                CMP.B       D2,D3
                BEQ         PARSE_OP_5
                
                MOVE.B      #OPCODE_6,D3            * BCC
                CMP.B       D2,D3
                BEQ         PARSE_OP_6                

                MOVE.B      #OPCODE_7,D3            * MOVEQ
                CMP.B       D2,D3
                BEQ         PARSE_OP_7

                MOVE.B      #OPCODE_8,D3            * DIVS
                CMP.B       D2,D3
                BEQ         PARSE_OP_8
                
                MOVE.B      #OPCODE_9,D3            * SUB,SUBA
                CMP.B       D2,D3
                BEQ         PARSE_OP_9
                
                MOVE.B      #OPCODE_B,D3            * EOR,CMP,CMPA
                CMP.B       D2,D3
                BEQ         PARSE_OP_B                

                MOVE.B      #OPCODE_C,D3            * AND,MULS
                CMP.B       D2,D3
                BEQ         PARSE_OP_C

                MOVE.B      #OPCODE_D,D3            * ADD,ADDA
                CMP.B       D2,D3
                BEQ         PARSE_OP_D
                
                MOVE.B      #OPCODE_E,D3            * ASL,ASR,LSL,LSR,ROL,ROR
                CMP.B       D2,D3
                BEQ         PARSE_OP_E
                                
                
                *CASE where nothing matched, bad data. report to user. Skip to next 16 bit code
NO_OP_MATCH     LEA         INVALID_OP_MSG,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.W      D7,D1
                MOVE.L      #4,D2
                JSR         HEX_TO_ASCII
                
                LEA         ASCII_RESULT,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         CR_LF_MSG,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                BRA         OP_IDENT
 
****************************************************************************
*--------------------------------------------------------------------------*
****************************************************************************
               
* USABLE REGISTERS FOR THIS SECTION:  D0-D6, A3-A6 (A0, A1, A7 usable if necessary, but refrain)
* Before branching to HANDLE_OPERAND, put Register in D6, Mode in D5 and size in OP_SIZE.                

****************************************************************************
*--------------------------------Parse Operations--------------------------*
****************************************************************************

* ANDI,SUBI,EORI,CMPI,BCHG
PARSE_OP_0      MOVE.W      D7,D3                   * D6 stores replicate of 16 bits stored in D7
                MOVE.W      #$01C0,D2               * First Case: BitMask to check if BCHG Dn,<EA>
                AND.W       D2,D3
                
                MOVE.W      D7,D6                   * EA for ANDI,SUBI,BCHG,EORI,CMPI
                MOVE.W      #$003F,D5
                AND.W       D5,D6
                
                MOVE.W      #%000111,D5
                AND.W       D6,D5
                LSR.W       #3,D6
                
                MOVE.W      D6,D4                   * Temp memory for swap
                MOVE.W      D5,D6                   * D6 stores Register
                MOVE.W      D4,D5                   * D5 stores Mode
                
                LSR.W       #6,D3                   * Shift the BitMask to compare if BCHG Dn,<EA>
                CMPI.W      #%0101,D3
                BEQ         BCHG_DN
                
                MOVE.W      D7,D3                   * Check for other cases
                MOVE.W      #$0F00,D4               * BitMask to check other cases
                AND.W       D4,D3
                LSR.W       #8,D3                   * Shift the BitMask to compare
                
PARSE_OF_0_CMP  CMPI.W      #%1000,D3               * BCHG #<data>,<EA>
                BEQ         PARSE_0_BCHG

                CMPI.W      #%0010,D3               * ANDI #<data>,<EA>
                BEQ         PARSE_0_ANDI
                
                CMPI.W      #%0100,D3               * SUBI #<data>,<EA>
                BEQ         PARSE_0_SUBI
                
                CMPI.W      #%1010,D3               * EORI #<data>,<EA>
                BEQ         PARSE_0_EORI
                
                CMPI.W      #%1100,D3               * CMPI #<data>,<EA>
                BEQ         PARSE_0_CMPI
                
                BRA         NO_OP_MATCH             * BRANCH if No Match
                
PARSE_0_ANDI    LEA         PRINT_ANDI,A1           * Print ANDI
                MOVE.B      #14,D0
                TRAP        #15
                BRA         PARSE_0_SIZE

PARSE_0_SUBI    LEA         PRINT_SUBI,A1           * Print SUBI
                MOVE.B      #14,D0
                TRAP        #15
                BRA         PARSE_0_SIZE

PARSE_0_EORI    LEA         PRINT_EORI,A1           * Print EORI
                MOVE.B      #14,D0
                TRAP        #15
                BRA         PARSE_0_SIZE

PARSE_0_CMPI    LEA         PRINT_CMPI,A1           * Print CMPI
                MOVE.B      #14,D0
                TRAP        #15
                BRA         PARSE_0_SIZE
                
PARSE_0_SIZE    MOVE.W      D7,D2                   * Need to check for size
                MOVE.W      #$00C0,D1               * BitMask to check size
                AND.W       D2,D1
                LSR.W       #6,D1                   * Shift the BitMask to compare
                
                CMPI.B      #%0000,D1               * Byte size
                BEQ         PARSE_0_SIZE_B
                
                CMPI.B      #%0001,D1               * Word size
                BEQ         PARSE_0_SIZE_W
                
                CMPI.B      #%0010,D1               * Long size
                BEQ         PARSE_0_SIZE_L
                
PARSE_0_SIZE_B  MOVE.B      #$01,OP_SIZE            * Sets OP_SIZE to word
                LEA         PRINT_B,A1              * Print .B
                MOVE.B      #14,D0
                TRAP        #15
                BRA         PARSE_0_IMMDATA 
                
PARSE_0_SIZE_W  MOVE.B      #$01,OP_SIZE            * Sets OP_SIZE to word
                LEA         PRINT_W,A1              * Print .W
                MOVE.B      #14,D0
                TRAP        #15               
                BRA         PARSE_0_IMMDATA 
                
PARSE_0_SIZE_L  MOVE.B      #$02,OP_SIZE            * Sets OP_SIZE to long
                LEA         PRINT_L,A1              * Print .L
                MOVE.B      #14,D0
                TRAP        #15
                
PARSE_0_IMMDATA MOVE.W      #$0007,D5               * Set immediate data mode
                MOVE.W      #$0004,D6               * Set immediate data register

                JSR         HANDLE_OPERAND          * Enter Subroutine to print out immediate data
                
PARSE_0_EA      LEA         PRINT_COMMA,A1          * Print comma
                MOVE.B      #14,D0
                TRAP        #15   

                MOVE.W      D7,D6                   * EA for ANDI,SUBI,BCHG,EORI,CMPI
                MOVE.W      #$003F,D5
                AND.W       D5,D6
                
                MOVE.W      #%000111,D5
                AND.W       D6,D5
                LSR.W       #3,D6
                
                MOVE.W      D6,D4                   * Temp memory for swap
                MOVE.W      D5,D6                   * D6 stores Register
                MOVE.W      D4,D5                   * D5 stores Mode
                
                JSR         HANDLE_OPERAND          * Enter subroutine for source handling
                
                LEA         CR_LF_MSG,A1            * Print New Line
                MOVE.B      #14,D0
                TRAP        #15

                BRA         OP_IDENT
* Parse_0 for BCHG.x #<data>,<ea>                

                *MOVE.W      #$085C,$C068004C        * BCHG.B    #$44,(A4)+
                *MOVE.W      #$0044,$C068004E
                * 0000 1000 01 01 1-100
                * 0000 0000 11 00 0000
PARSE_0_BCHG    MOVE.W      D7,D2                   * Need to check if the rest of the op code ends in 01
                MOVE.L      #$00C0,D1               * BitMask to check 
                AND.W       D1,D2
                LSR.W       #6,D2                   * Shift the BitMask to compare
                
                CMPI.B      #%01,D2               * Is the rest of the op code 01?
                BNE         NO_OP_MATCH             * If not equal: ERROR
                
                CMPI.B      #DR_DIRECT,D5           * Check if EA is Dn
                BEQ         PARSE_0_BCHG_L          * If so, BCHG is long
                
                MOVE.B      #$01,OP_SIZE            * Special case: BCHG.B immediate data should always be WORD size 
                LEA         PRINT_BCHG_B,A1         * Print BCHG.B
                MOVE.B      #14,D0
                TRAP        #15
                BRA         PARSE_BCHG_DATA

PARSE_0_BCHG_L  LEA         PRINT_BCHG_L,A1         * Print BCHG.L
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #$02,OP_SIZE            * Set OP_SIZE to be long
                
PARSE_BCHG_DATA MOVE.W      #$0007,D5               * Set immediate data mode
                MOVE.W      #$0004,D6               * Set immediate data register
                JSR         HANDLE_OPERAND          * Enter Subroutine to print out immediate data
                BRA         PARSE_0_EA
* Parse_0 for BCHG.x Dn,<ea> case:         
BCHG_DN         CMPI.B      #DR_DIRECT,D5           * Check if EA is Dn
                BEQ         BCHG_PRINT_L            * If so, BCHG is long
                
BCHG_PRINT_B    LEA         PRINT_BCHG_B,A1         * Print BCHG.B
                MOVE.B      #14,D0
                TRAP        #15
                BRA         BCHG_PRINT_D        
                
BCHG_PRINT_L    LEA         PRINT_BCHG_L,A1         * Print BCHG.L
                MOVE.B      #14,D0
                TRAP        #15

BCHG_PRINT_D    LEA         PRINT_D,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.L      D7,D1                   * Move target register to D1
                MOVE.L      #$0E00,D4
                AND.L       D4,D1
                
                LSR.L       #8,D1                   * Shift 9 to get target register
                LSR.L       #1,D1
                
                MOVE.L      #1,D2
                JSR         HEX_TO_ASCII            * Convert register to ASCII
                
                LEA         ASCII_RESULT,A1         * Print register
                MOVE.B      #14,D0
                TRAP        #15

                BRA         PARSE_0_EA              * Branch to print parse 0 EA



* MOVE.B
PARSE_OP_1      LEA         PRINT_MOVE_B,A1
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.B      #$00,OP_SIZE            * Sets OP_SIZE to byte.
                
                MOVE.W      D7,D6                   * D6 stores replicate of 16 bits stored in D7
                MOVE.W      #$003F,D5
                AND.W       D5,D6                   * D6 stores Source information
                
                MOVE.W      #%000111,D5             * BitMask for Source register
                AND.W       D6,D5                   * D5 stores Source Register
                LSR.W       #3,D6                   * D6 stores Source Mode
                
                MOVE.W      D6,D4                   * Temp memory for swap
                MOVE.W      D5,D6                   * D6 stores Source Register
                MOVE.W      D4,D5                   * D5 stores Source Mode
                
                JSR         HANDLE_OPERAND          * Enter Subroutine for Source Handling
                
                LEA         PRINT_COMMA,A1          * Print comma
                MOVE.B      #14,D0
                TRAP        #15         
                
               
                MOVE.W      D7,D6                   * D6 stores replicate of 16 bits stored in D7
                MOVE.W      #$0FC0,D5
                AND.W       D5,D6                   * D6 stores only Destination information, not shifted.
                LSR.W       #6,D6                   * D6 stores Destination info
                
                MOVE.W      #%000111,D5             * BitMask for only mode
                AND.W       D6,D5                   * D5 stores Destination Mode
                
                LSR.W       #3,D6                   * D6 stores Destination Register
                
                JSR         HANDLE_OPERAND
                
                LEA         CR_LF_MSG,A1            * Print New Line
                MOVE.B      #14,D0
                TRAP        #15
                
                BRA         OP_IDENT


* MOVE.L
PARSE_OP_2      
                BRA         OP_IDENT
* MOVE.W
PARSE_OP_3
                BRA         OP_IDENT
* CLR,RTS,JSR,MOVEM,LEA
PARSE_OP_4
                BRA         OP_IDENT
* ADDQ
PARSE_OP_5
                BRA         OP_IDENT
* BCC
PARSE_OP_6
                BRA         OP_IDENT
* MOVEQ
PARSE_OP_7
                BRA         OP_IDENT
* DIVS
PARSE_OP_8
                BRA         OP_IDENT
* SUB,SUBA
PARSE_OP_9      MOVE.W      #$01C0,D2       * Bitmask for retrieving Opmode.
                AND.W       D7,D2           * D2 stores the opmode, unshifted
                LSR.W       #6,D2           * D2 stores the opmode
                
                CMPI.B      #$03,D2         * If opmode is 011, parse as SUBA.W
                BEQ         SUB_A_WORD      
                
                CMPI.B      #$07,D2         * If opmode is 111, parse as SUBA.L
                BEQ         SUB_A_LONG
                
                CMPI.B      #$02,D2         * If opmode <= 010, parse as SUB <ea>,Dn
                BLE         SUB_EA_DN
                
                CMPI.B      #06,D2          * If opmode <= 110, parse as SUB Dn,<ea>
                BLE         SUB_DN_EA
                
                BRA         EXIT_PARSE_OP_9
                
SUB_A_WORD      LEA         PRINT_SUB_A_W,A1    * Print: SUBA.W
                MOVE.B      #14,D0
                TRAP        #15

                MOVE.W      #$0007,D6       * Store the <ea> register into D6
                AND.W       D7,D6
                
                MOVE.W      #$0038,D5       * Store the <ea> mode into D5
                AND.W       D7,D5
                LSR.W       #3,D5
                
                MOVE.B      #$01,OP_SIZE    * Set OP_SIZE to Word (%01)
                
                JSR         HANDLE_OPERAND  * Print operand (D5 stores mode, D6 stores register)
                
                LEA         PRINT_COMMA,A1  * Print: comma (between operands)
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         PRINT_A,A1      * Print:  A
                MOVE.B      #14,D0
                TRAP        #15
                
                CLR.L       D1              * Clear D1
                MOVE.W      #$0E00,D1
                AND.W       D7,D1           * D1 stores the destination address register, unshifted
                LSR.W       #8,D1
                LSR.W       #1,D1           * D1 stores the destination address register, shifted
                
                MOVE.L      #1,D2           
                JSR         HEX_TO_ASCII    * Convert destination address register to ASCII
                
                LEA         ASCII_RESULT,A1 * Print the destination address register
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         CR_LF_MSG,A1    * Print new line, carriage return
                MOVE.B      #14,D0
                TRAP        #15             
                
                BRA         EXIT_PARSE_OP_9

SUB_A_LONG      LEA         PRINT_SUB_A_L,A1      * Print: SUBA.L
                MOVE.B      #14,D0
                TRAP        #15

                MOVE.W      #$0007,D6
                AND.W       D7,D6           * D6 stores the EA register
                
                MOVE.W      #$0038,D5
                AND.W       D7,D5           * D5 stores the EA Mode, unshifted
                LSR.W       #3,D5           * D5 stores the EA Mode
                
                MOVE.B      #$02,OP_SIZE    * Set OP_SIZE to Long (%10)
                
                JSR         HANDLE_OPERAND
                
                LEA         PRINT_COMMA,A1  * Print comma
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         PRINT_A,A1      * Print:  A
                MOVE.B      #14,D0
                TRAP        #15
                
                CLR.L       D1              * Clear D1
                MOVE.W      #$0E00,D1       * Bitmask for destination address register
                AND.W       D7,D1           * D1 stores the destination address register, unshifted
                LSR.W       #8,D1
                LSR.W       #1,D1           * D1 stores the destination address register, shifted
                
                MOVE.L      #1,D2           
                JSR         HEX_TO_ASCII    * Convert the destination address register to ASCII
                
                LEA         ASCII_RESULT,A1 * Print the destination address register
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         CR_LF_MSG,A1    * Print new line, carriage return
                MOVE.B      #14,D0
                TRAP        #15   
                
                BRA         EXIT_PARSE_OP_9

SUB_EA_DN       CMPI.B      #$00,D2
                BEQ         SUB_EA_DN_BYTE
                
                CMPI.B      #$01,D2
                BEQ         SUB_EA_DN_WORD
                
                CMPI.B      #$02,D2
                BEQ         SUB_EA_DN_LONG
                
SUB_EA_DN_BYTE  LEA         PRINT_SUB_B,A1      * Print:  SUB.B
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #$00,OP_SIZE        * Set OP_SIZE to byte
                BRA         RET_SUB_EA_DN       * Merge
                
SUB_EA_DN_WORD  LEA         PRINT_SUB_W,A1      * Print:  SUB.W
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #$01,OP_SIZE        * Set OP_SIZE to word
                BRA         RET_SUB_EA_DN       * Merge
                
SUB_EA_DN_LONG  LEA         PRINT_SUB_L,A1
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #$02,OP_SIZE        * Set OP_SIZE to long
                BRA         RET_SUB_EA_DN       * Merge
                
                
RET_SUB_EA_DN   MOVE.W      #$0007,D6           * Bitmask for EA Register
                AND.W       D7,D6               * D6 stores EA Register
                
                MOVE.W      #$0038,D5
                AND.W       D7,D5               * D5 stores EA Mode, unshifted
                LSR.W       #3,D5               * D5 stores EA Mode
                
                JSR         HANDLE_OPERAND
                
                LEA         PRINT_COMMA,A1      * Print comma
                MOVE.B      #14,D0
                TRAP        #15
                
                LEA         PRINT_D,A1          * Print:  D
                MOVE.B      #14,D0
                TRAP        #15
                
                MOVE.W      #$0E00,D1
                AND.W       D7,D1               * D1 stores the destination register, unshifted
                LSR.W       #8,D1
                LSR.W       #1,D1               * D1 stored the destination register
                
                MOVE.L      #1,D2
                JSR         HEX_TO_ASCII
                
                LEA         ASCII_RESULT,A1
                MOVE.B      #14,D0
                TRAP        #15                 * Print destination register
                
                LEA         CR_LF_MSG,A1        * Print new line/carriage return
                MOVE.B      #14,D0
                TRAP        #15                
                
                BRA         EXIT_PARSE_OP_9

SUB_DN_EA       CMPI.B      #$04,D2
                BEQ         SUB_DN_EA_BYTE
                
                CMPI.B      #$05,D2
                BEQ         SUB_DN_EA_WORD
                
                CMPI.B      #$06,D2
                BEQ         SUB_DN_EA_LONG
                
SUB_DN_EA_BYTE  LEA         PRINT_SUB_B,A1      * Print:  SUB.B
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #$00,OP_SIZE        * Set OP_SIZE to byte
                BRA         RET_SUB_DN_EA       * Merge
                
SUB_DN_EA_WORD  LEA         PRINT_SUB_W,A1      * Print:  SUB.W
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #$01,OP_SIZE        * Set OP_SIZE to word
                BRA         RET_SUB_DN_EA       * Merge
                
SUB_DN_EA_LONG  LEA         PRINT_SUB_L,A1
                MOVE.B      #14,D0
                TRAP        #15
                MOVE.B      #$02,OP_SIZE        * Set OP_SIZE to long
                BRA         RET_SUB_DN_EA       * Merge
                
                
RET_SUB_DN_EA   MOVE.W      #$0007,D6           * Bitmask for EA Register
                AND.W       D7,D6               * D6 stores EA Register
                
                MOVE.W      #$0038,D5
                AND.W       D7,D5               * D5 stores EA Mode, unshifted
                LSR.W       #3,D5               * D5 stores EA Mode
                
                LEA         PRINT_D,A1          * Print:  D
                MOVE.B      #14,D0
                TRAP        #15
                
                CLR.L       D1                  * Clear D1
                MOVE.W      #$0E00,D1
                AND.W       D7,D1               * D1 stores the data register, unshifted
                LSR.W       #8,D1
                LSR.W       #1,D1               * D1 stored the data register
                
                MOVE.L      #1,D2
                JSR         HEX_TO_ASCII
                
                LEA         ASCII_RESULT,A1
                MOVE.B      #14,D0
                TRAP        #15                 * Print destination register
                
                LEA         PRINT_COMMA,A1      * Print comma
                MOVE.B      #14,D0
                TRAP        #15
                
                JSR         HANDLE_OPERAND      * Print EA
                
                LEA         CR_LF_MSG,A1        * Print new line/carriage return
                MOVE.B      #14,D0
                TRAP        #15             
                BRA         EXIT_PARSE_OP_9
                
                
EXIT_PARSE_OP_9 BRA         OP_IDENT

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
* D6 holds register.  
* D5 holds mode.  
* OP_SIZE holds size of operation: $00 = Byte, $01 = Word, $02 = Long
HANDLE_OPERAND          MOVEM.L     D7,-(SP)
                        
                        MOVE.B      #DR_DIRECT,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_0             * Branch to Data Register Direct: Dn
                        
                        MOVE.B      #AR_DIRECT,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_1             * Branch to Address Register Direct: An
                        
                        MOVE.B      #AR_INDIRECT,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_2             * Branch to Address Register Indirect: (An)
                        
                        MOVE.B      #AR_INDIRECT_POST,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_3             * Branch to Address Register Indirect w/Post-Incrementing: (An)+
                        
                        MOVE.B      #AR_INDIRECT_PRE,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_4             * Branch to Address Register Indirect w/Pre-Decrimenting: -(An)
                        
                        MOVE.B      #ABS_ADDR,D0
                        CMP.B       D0,D5
                        BEQ         OPERAND_MODE_7             * Branch to Absolute Addressing: 3 cases (xxx).W (xxx).L #<data>

* Invalid Destination Mode Handling                        
INVALID_OPERAND_MODE    LEA         INVALID_OPERAND_MODE_MSG,A1        
                        MOVE.B      #14,D0
                        TRAP        #15                        * Print error message for Destination Mode
                        
                        MOVE.W      D7,D1
                        MOVE.L      #4,D2
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1
                        MOVE.B      #14,D0
                        TRAP        #15                        * Print the problematic instruction
                        
                        LEA         CR_LF_MSG,A1
                        MOVE.B      #14,D0
                        TRAP        #15                        * Print carriage return/new line
                        
                        
EXIT_HANDLE_OPERAND     MOVEM.L     (SP)+,D7                   * Exit HANDLE_DESTINATION subroutine
                        RTS

* Complex part of destination handling

* Data Register Direct                        
OPERAND_MODE_0          LEA         PRINT_D,A1                 * Print D
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1                      * Convert target Register
                        MOVE.L      #1,D2
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        
* Code goes here
                        BRA         EXIT_HANDLE_OPERAND

* Address Register Direct
OPERAND_MODE_1          LEA         PRINT_A,A1                  * Prints: A
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1                       * Converts register to ASCII
                        MOVE.L      #1,D2
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1             * Prints Register
                        MOVE.B      #14,D0
                        TRAP        #15
   
                        BRA         EXIT_HANDLE_OPERAND 

* Address Register Indirect
OPERAND_MODE_2          LEA         PRINT_A_INDIRECT,A1         * Prints: (A
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1                       * Converts Register to ASCII
                        MOVE.L      #1,D2
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1             * Prints Register
                        MOVE.B      #14,D0
                        TRAP        #15

                        
                        LEA         PRINT_END_PAREN,A1          * Prints: )
                        MOVE.B      #14,D0
                        TRAP        #15       

                        BRA         EXIT_HANDLE_OPERAND

* Address Register Indirect w/Post-Incrementation
OPERAND_MODE_3          LEA         PRINT_A_INDIRECT,A1         * Prints: (A
                        MOVE.B      #14,D0
                        TRAP        #15

                        MOVE.L      D6,D1                       * Converts Register to ASCII
                        MOVE.L      #1,D2
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1             * Prints Register
                        MOVE.B      #14,D0
                        TRAP        #15

                        
                        LEA         PRINT_END_PAREN_PLUS,A1     * Prints: )+
                        MOVE.B      #14,D0
                        TRAP        #15                           

                        BRA         EXIT_HANDLE_OPERAND
                        
* Address Register Indirect w/Pre-Decrementation
OPERAND_MODE_4          LEA         PRINT_MINUS_A_INDIRECT,A1   * Prints: -(A
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D6,D1                       * Converts Register to ASCII
                        MOVE.L      #1,D2
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1             * Prints Register
                        MOVE.B      #14,D0
                        TRAP        #15

                        
                        LEA         PRINT_END_PAREN,A1          * Prints: )
                        MOVE.B      #14,D0
                        TRAP        #15

                        BRA         EXIT_HANDLE_OPERAND
                        
* Absolute Addressing
OPERAND_MODE_7          MOVE.B      #ABS_ADDR_WORD_REG,D0       * Load %000 to D0
                        CMP.B       D0,D6
                        BEQ         HANDLE_ABS_ADDR_WORD
                        
                        MOVE.B      #ABS_ADDR_LONG_REG,D0       * Load %001 to D0
                        CMP.B       D0,D6
                        BEQ         HANDLE_ABS_ADDR_LONG
                        
                        MOVE.B      #IMMEDIATE_DATA,D0          * Load %100 to D0
                        CMP.B       D0,D6
                        BEQ         HANDLE_IMMED_DATA

* The address register stored in D6 is invalid.                        
INVALID_ABS_ADDR_REG    LEA         INVALID_ABS_ADDR_REG_MSG,A1 * Print error message
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.L      D7,D1                       
                        MOVE.L      #4,D2
                        JSR         HEX_TO_ASCII                * Convert instruction to ASCII
                        
                        LEA         ASCII_RESULT,A1             * Print invalid instruction
                        MOVE.B      #14,D0
                        TRAP        #15 
                        
                        LEA         CR_LF_MSG,A1                * Print new Line
                        MOVE.B      #14,D0
                        TRAP        #15  
                                                

EXIT_OPERAND_MODE_7     BRA         EXIT_HANDLE_OPERAND 


HANDLE_ABS_ADDR_WORD    LEA         PRINT_DOLLAR,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.B      (A2)+,D4            * D4 stores a byte of the absolute address.
                        LSL.W       #8,D4               * Shift D4 left 8 bits
                        MOVE.B      (A2)+,D4            * D4 stores word absolute address
                        
                        MOVE.L      D4,D1               * Convert absolute address to ASCII
                        MOVE.L      #4,D2
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1     * Print absolute address word
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        BRA         EXIT_OPERAND_MODE_7

HANDLE_ABS_ADDR_LONG    LEA         PRINT_DOLLAR,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        MOVE.B      (A2)+,D4            * D4 stores a byte of the absolute address.
                        LSL.L       #8,D4               * Shift D4 left 8 bits
                        MOVE.B      (A2)+,D4
                        LSL.L       #8,D4
                        MOVE.B      (A2)+,D4            * D4 stores a byte of the absolute address.
                        LSL.L       #8,D4               * Shift D4 left 8 bits
                        MOVE.B      (A2)+,D4            * D4 stores long absolute address

                        MOVE.L      D4,D1               * Convert absolute address to ASCII
                        MOVE.L      #8,D2
                        JSR         HEX_TO_ASCII        
                        
                        LEA         ASCII_RESULT,A1     * Print absolute address long
                        MOVE.B      #14,D0
                        TRAP        #15

                        BRA         EXIT_OPERAND_MODE_7
                        
HANDLE_IMMED_DATA       LEA         PRINT_NUM_DOLLAR,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        CLR.L       D1                  * Clears D1
                        MOVE.B      OP_SIZE,D1          * Set D1 to OP_SIZE ($00 = Byte, $01 = Word, $02 = Long)
                        
                        CMPI.B      #$00,D1
                        BEQ         IMMED_DATA_BYTE
                        
                        CMPI.B      #$01,D1
                        BEQ         IMMED_DATA_WORD
                        
                        CMPI.B      #$02,D1
                        BEQ         IMMED_DATA_LONG
                        
                        
EXIT_HANDLE_IMMED_DATA  BRA         EXIT_OPERAND_MODE_7

IMMED_DATA_BYTE         MOVE.B      (A2)+,D1            * load byte of filler immediate data and move A2
                        LSL.W       #8,D1               * Shift D1 left 8 bits
                        MOVE.B      (A2)+,D1            * load byte of immediate data and move A2
                        
                        MOVE.L      #2,D2               * Convert byte of immediate data to ASCII
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1     * Print byte of immediate data
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        BRA         EXIT_HANDLE_IMMED_DATA

IMMED_DATA_WORD         MOVE.B      (A2)+,D1            * D1 stores a byte of the immediate data
                        LSL.W       #8,D1               * Shift D1 left 8 bits
                        MOVE.B      (A2)+,D1            * D1 stores immediate data word
                        
                        MOVE.L      #4,D2               * Convert immediate data word to ASCII
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1     * Print immediate data word
                        MOVE.B      #14,D0
                        TRAP        #15
                        
                        BRA         EXIT_HANDLE_IMMED_DATA

IMMED_DATA_LONG         MOVE.B      (A2)+,D1            * D1 stores a byte of the immediate data
                        LSL.L       #8,D1               * Shift D1 left 8 bits
                        MOVE.B      (A2)+,D1            * D1 stores a word of the immediate data
                        LSL.L       #8,D1               * Shift D1 left 8 bits
                        MOVE.B      (A2)+,D1            * D1 stores a word and a byte of the immediate data
                        LSL.L       #8,D1               * Shift D1 left 8 bits
                        MOVE.B      (A2)+,D1            * D1 stores immediate data long
                        
                        MOVE.L      #8,D2              * Convert immediate data long to ASCII
                        JSR         HEX_TO_ASCII
                        
                        LEA         ASCII_RESULT,A1
                        MOVE.B      #14,D0
                        TRAP        #15
                        BRA         EXIT_HANDLE_IMMED_DATA
                     
*********************************************************************************
*-------------------------------------------------------------------------------*
*********************************************************************************

* -----------------------------------------------
* Register Summary
*     D0: Loop counter (Decrements from value in D2)
*     D1: Value to be converted from hex to ASCII
*     D2: Number of nibble values to be converted (000000ABF)
*     D3: Resulting value in ASCII
*     D7: Stores isolated LSB
*
* Concerns: Limited 4 ASCII character result (change to variable instead of D3?)
*           Should I print the contents of D3 immediately or try and return it?
*                Or store it into a variable as well? What about yucky 0's?
* -----------------------------------------------

HEX_TO_ASCII        MOVEM.L   A1/D0-D3/D7,-(SP) * Push registers onto the stack
                    CLR.L     D0                * Clear loop counter register
                    CLR.L     D3                * Clear result value register
                    CLR.L     D7                * Clear isolated LSB register
                    LEA       ASCII_RESULT,A4   * Load memory location of result to A4

INIT_H2A_LOOP	    MOVE.W    D2,D0             * Rotate until MSB is LSB 0000ABCD -> BCD0000A
                    SUBI.W    #2,D0             * Subtract 2 from counter (1 for dumb loop, 1 to leave extra char)
MINI_LOOP           ROR.L     #4,D1
                    DBRA      D0,MINI_LOOP

                    MOVE.W    D2,D0             * Initialize loop counter to number of values to convert
                    BRA       TEST              * Branch to TEST to deal with extra loop iteration

H2A_LOOP		    MOVE.W    #$0000000F,D7		* Move bit mask to isolate LSB into D7
					AND.L     D1,D7         	* Store isolated LSB into D7  
					ROL.L     #4,D1         	* Shift value that's being converted by 4 bits

					CMPI.L    #9,D7         	* Compare isolated LSB to highest value number
					BGT       CONVERT_H2A_LETTER	* If greater than 9, branch to convert letter logic
CONVERT_H2A_NUMBER  ADDI.B    #48,D7        	* Add 48 to convert from hex to ASCII number
	                BRA       STORE_VALUE		* Branch to store resulting value

CONVERT_H2A_LETTER	ADDI.B    #55,D7	    	* Add 55 to convert from hex to ASCII letter
	                BRA       STORE_VALUE		* Branch to store resulting value

STORE_VALUE	        MOVE.B    D7,(A4)+          * Push the ASCII value onto the A4 stack

TEST                DBRA      D0,H2A_LOOP       * Continue looping if counter is not -1

H2A_LOOP_FINISH     MOVE.B    #$00,(A4) 
                    
                    * load ASCII chars directly into A1 to prep for printing
                    

                    MOVEM.L   (SP)+,A1/D0-D3/D7    * Pop registers back off the stack

                    RTS                         * Return from sub-routine



END 
                    
                              
    SIMHALT             ; halt simulator

* Put variables and constants here
stack               EQU             $7000   * Stack pointer start location

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
INVALID_OPERAND_MODE_MSG   DC.B 'The operand mode is invalid for instruction: ',0
INVALID_ABS_ADDR_REG_MSG   DC.B 'The following absolute address register is invalid: ',0

PRINT_D             DC.B        'D',0
PRINT_COMMA         DC.B        ',',0
PRINT_A             DC.B        'A',0
PRINT_A_INDIRECT    DC.B        '(A',0
PRINT_END_PAREN     DC.B        ')',0
PRINT_END_PAREN_PLUS    DC.B    ')+',0
PRINT_MINUS_A_INDIRECT  DC.B    '-(A',0
PRINT_DOLLAR        DC.B        '$',0
PRINT_NUM_DOLLAR    DC.B        '#$',0


BUGFIXMESSAGE       DC.B        'This message is loaded to resolve a bug, and should never be printed.',CR,LF,0
INVALID_OP_MSG      DC.B        'Invalid Operation Code for Instruction: ',0
CR_LF_MSG           DC.B        CR,LF,0
TAB_MSG             DC.B        HT,0

PRINT_MOVE_B        DC.B        'MOVE.B',HT,0
PRINT_SUB_A_W       DC.B        'SUBA.W',HT,0
PRINT_SUB_A_L       DC.B        'SUBA.L',HT,0
PRINT_SUB_B         DC.B        'SUB.B',HT,0
PRINT_SUB_W         DC.B        'SUB.W',HT,0
PRINT_SUB_L         DC.B        'SUB.L',HT,0
PRINT_BCHG_B        DC.B        'BCHG.B',HT,0
PRINT_BCHG_L        DC.B        'BCHG.L',HT,0
PRINT_ANDI          DC.B        'ANDI',0
PRINT_SUBI          DC.B        'SUBI',0
PRINT_EORI          DC.B        'EORI',0
PRINT_CMPI          DC.B        'CMPI',0
PRINT_B             DC.B        '.B',HT,0
PRINT_W             DC.B        '.W',HT,0
PRINT_L             DC.B        '.L',HT,0

STARTADDRSTRING1    DS.L        1
STARTADDRSTRING2    DS.L        1
HEXSTARTADDR        DS.L        1

ENDADDRSTRING1      DS.L        1
ENDADDRSTRING2      DS.L        1
HEXENDADDR          DS.L        1

OP_SIZE             DS.B        1
ASCII_RESULT        DS.B        9
                    END     START           ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
