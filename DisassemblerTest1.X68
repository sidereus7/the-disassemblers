*-----------------------------------------------------------
* Title      :  Test Code for 68K Disassembler
* Written by :  Chance O'Day
* Date       :  3/12/15
* Description:  This code is meant to be simultaneously loaded into memory
*               with Disassembler.X68. It tests various instructions.
*               Starts at $5000
*-----------------------------------------------------------
    ORG    $5000
START:       MOVE.B     D7,D1
             MOVE.B     #$17,D2
             MOVE.B     #$33,(A5)
             
             SUB.B      (A4),D4
             SUB.W      D4,D2
             SUB.L      D2,(A4)
             
             SUBA.W     (A4)+,A1
             SUBA.L     A7,A4
             
             ADD.B      (A4),D4             * ADD/ADDA Tests
             ADD.W      D4,D2
             ADD.L      D2,(A4)
             
             ADDA.W     (A4)+,A1
             ADDA.L     A7,A4
             
             ANDI.B     #$33,D4
             ANDI.W     #$8888,(A3)
             ANDI.L     #$AAAAAAAA,(A3)+
             
             SUBI.B     #$AA,(A4)
             SUBI.W     #$8888,D4
             SUBI.L     #$AAAAAAAA,D4
             
             EORI.B     #$33,-(A4)
             EORI.W     #$AAAA,D4
             EORI.L     #$12345678,D4
             
             CMPI.B     #$11,D3
             CMPI.W     #$1234,D6
             CMPI.L     #$AAAAAAAA,D4
             
             BCHG.B     D4,(A3)
             BCHG.B     #$44,(A4)+
             BCHG.L     D3,D2
             BCHG.L     #$AAAAAAAA,D3

             MOVE.B     D7,D1
             MOVE.B     #$17,D2
             MOVE.B     #$33,(A5)
             
             MOVE.W     -(A3),$5555
             MOVE.W     D1,D2
             MOVE.W     #$5555,A1
             MOVE.W     (A6)+,D4
             
             MOVE.L     (A1),D4
             MOVE.L     A6,(A3)+
             MOVE.L     #$01234567,D5
             
             SUB.B      (A4),D4
             SUB.W      D4,D2
             SUB.L      D2,(A4)
             
             SUBA.W     (A4)+,A1
             SUBA.L     A7,A4
                          
             EOR.B      D3,(A6)
             EOR.W      D4,(A2)+
             EOR.L      D5,$1234
             
             CMP.B      D5,D2
             CMP.W      A3,D2
             CMP.L      (A6),D1
             
             CMPA.W     #$9999,A2
             CMPA.L     (A3),A3
             
             ADD.B      D1,D2
             ADD.W      D2,D3
             ADD.L      D4,D5
             
             ADDA.W     #$1234,A2
             ADDA.L     D3,A3
             
             BGT        TEST_BGT_POS
             BLE        TEST_BLE_POS
             
TEST_BGT_NEG ADDQ.B     #4,D2
TEST_BLE_POS ADDQ.W     #1,(A5)
             ADDQ.L     #8,$C007
             
TEST_BGT_POS BGT        TEST_BGT_NEG

            MOVEM.W     A0-A3/A7,-(A7)
            MOVEM.L     A1/A3-A4/A6,-(A7)
            
            
            MOVE.L      #$FFFF0456,D1
            DIVS.W      #$1000,D1
            DIVS.W      D1,D3
            
            MULS.W      #$1000,D1
            MULS.W      (A3),D2
            
            AND.B       #$01,D1
            AND.W       #$1234,D2
            AND.L       D3,D4
             

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
