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
             
             EOR.B      D3,(A6)
             EOR.W      D4,(A2)+
             EOR.L      D5,$1234
             
             CMP.B      D5,D2
             CMP.W      A3,D2
             CMP.L      (A6),D1
             
             CMPA.W     #$9999,A2
             CMPA.L     (A3),A3

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
