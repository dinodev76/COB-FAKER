       IDENTIFICATION DIVISION.
      *========================

       PROGRAM-ID.             FAKTXID.
      *AUTHOR.                 BRIAN D PEAD.
      *DATE-WRITTEN.           2020-01-04.

       ENVIRONMENT DIVISION.
      *=====================

       CONFIGURATION SECTION.
      *----------------------

       SOURCE-COMPUTER.
           IBM-Z15.
      *    IBM-Z15 DEBUGGING MODE.

       INPUT-OUTPUT SECTION.
      *---------------------

       FILE-CONTROL.
      /
       DATA DIVISION.
      *==============

       FILE SECTION.
      *-------------

       WORKING-STORAGE SECTION.
      *------------------------

       COPY FAKERWS1.

       01  W-EIN-SEQUENCE          PIC 9(7).
       01  W-AREA                  PIC 9(03).
       01  W-GROUP                 PIC 9(02).
       01  W-SERIAL                PIC 9(04).
       01  W-FAKRAND-PROG          PIC X(8)        VALUE 'FAKRAND'.

       01  W-ERROR-MSG             PIC X(20)       VALUE
           '**** FAKTXID error: '.

       01  W-FAKRAND-PARAMETER.    COPY FAKRANDL.

       COPY FAKTXIDW.
      /
       LINKAGE SECTION.
      *----------------

       01  L-PARAMETER.            COPY FAKERLNK.
      /
       PROCEDURE DIVISION USING L-PARAMETER.
      *==================

       MAIN.
      *-----

           PERFORM SUB-1000-START-UP THRU SUB-1000-EXIT

           PERFORM SUB-2000-PROCESS THRU SUB-2000-EXIT

           PERFORM SUB-3000-SHUT-DOWN THRU SUB-3000-EXIT
           .
       MAIN-EXIT.
           GOBACK.
      /
       SUB-1000-START-UP.
      *------------------

           MOVE FAKER-SEED-TEXT    IN L-PARAMETER
             TO FAKRAND-SEED-TEXT

           IF      W-NOT-FIRST-CALL
               GO TO SUB-1000-EXIT
           END-IF

           SET W-NOT-FIRST-CALL    TO TRUE
           MOVE FUNCTION WHEN-COMPILED 
                                   TO W-COMPILED-DATE

           DISPLAY 'FAKTXID Compiled = '
               W-COMPILED-DATE-YYYY '/'
               W-COMPILED-DATE-MM   '/'
               W-COMPILED-DATE-DD   ' '
               W-COMPILED-TIME-HH   ':'
               W-COMPILED-TIME-MM   ':'
               W-COMPILED-TIME-SS

           DISPLAY ' '
           .
       SUB-1000-EXIT.
           EXIT.
      /
       SUB-2000-PROCESS.
      *-----------------

           MOVE 0                  TO FAKER-INFO-CNT
           SET  FI-DX              TO FAKER-INFO-CNT
           MOVE LOW-VALUES         TO FAKER-INFO-OCCS

           EVALUATE TRUE
             WHEN TAXID-EIN
               PERFORM SUB-9010-EIN THRU SUB-9010-EXIT

               MOVE FORMAT-EIN     TO FAKER-RESULT

             WHEN TAXID-EIN-HYPHEN
               PERFORM SUB-9010-EIN THRU SUB-9010-EXIT

               MOVE FORMAT-EIN-HYPHEN
                                   TO FAKER-RESULT

             WHEN TAXID-ITIN
               PERFORM SUB-9020-ITIN THRU SUB-9020-EXIT

               MOVE FORMAT-ITIN    TO FAKER-RESULT

             WHEN TAXID-ITIN-HYPHEN
               PERFORM SUB-9020-ITIN THRU SUB-9020-EXIT

               MOVE FORMAT-ITIN-HYPHEN
                                   TO FAKER-RESULT

             WHEN TAXID-SSN
               PERFORM SUB-9030-SSN THRU SUB-9030-EXIT

               MOVE FORMAT-SSN     TO FAKER-RESULT

             WHEN TAXID-SSN-HYPHEN
               PERFORM SUB-9030-SSN THRU SUB-9030-EXIT

               MOVE FORMAT-SSN-HYPHEN
                                   TO FAKER-RESULT

             WHEN OTHER
               DISPLAY W-ERROR-MSG
                       'Unknown function ignored: '
                       FAKER-PROVIDER-FUNCTION
                                   IN L-PARAMETER
               GO TO SUB-2000-EXIT
           END-EVALUATE

           SET  FAKER-INFO-CNT     TO FI-DX 
           .
       SUB-2000-EXIT.
           EXIT.
      /
       SUB-3000-SHUT-DOWN.
      *-------------------

      D    DISPLAY ' '

      D    DISPLAY 'FAKTXID Successfully Completed'
           .
       SUB-3000-EXIT.
           EXIT.
      /
       SUB-9010-EIN.
      *-------------

      **** EIN PREFIX:

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-RANDOM-SUB    =  FAKRAND-RANDOM-NO
                                      * EIN-PREFIX-CNT
                                      + 1

           SET  FI-DX           UP BY 1
           MOVE 'EIN-PREFIXES'     TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)
           MOVE W-RANDOM-SUB       TO FAKER-TABLE-ENTRY(FI-DX)

           MOVE EIN-PREFIX(W-RANDOM-SUB)
                                   TO FORMAT-EIN-PREFIX
                                      FORMAT-EIN-HYPHEN-PREFIX

      **** EIN SEQUENCE:

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-EIN-SEQUENCE  =  FAKRAND-RANDOM-NO
                                      * (EIN-SEQUENCE-MAX 
                                         - EIN-SEQUENCE-MIN
                                         + 1)
                                      + EIN-SEQUENCE-MIN  

           SET  FI-DX           UP BY 1
           MOVE 'EIN-SEQUENCE'     TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)

           MOVE W-EIN-SEQUENCE     TO FORMAT-EIN-SEQUENCE
                                      FORMAT-EIN-HYPHEN-SEQUENCE
           .
       SUB-9010-EXIT.
           EXIT.
      /
       SUB-9020-ITIN.
      *--------------

      **** ITIN AREA:

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-AREA          =  FAKRAND-RANDOM-NO
                                      * (ITIN-AREA-MAX 
                                         - ITIN-AREA-MIN
                                         + 1)
                                      + ITIN-AREA-MIN  

           SET  FI-DX           UP BY 1
           MOVE 'ITIN-AREA'        TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)

           MOVE W-AREA             TO FORMAT-ITIN-AREA
                                      FORMAT-ITIN-HYPHEN-AREA

      **** ITIN GROUP:

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-RANDOM-SUB    =  FAKRAND-RANDOM-NO
                                      * ITIN-GROUP-CNT
                                      + 1

           SET  FI-DX           UP BY 1
           MOVE 'ITIN-GROUPS'      TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)
           MOVE W-RANDOM-SUB       TO FAKER-TABLE-ENTRY(FI-DX)

           MOVE ITIN-GROUP(W-RANDOM-SUB)
                                   TO FORMAT-ITIN-GROUP
                                      FORMAT-ITIN-HYPHEN-GROUP

      **** ITIN SERIAL:

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-SERIAL        =  FAKRAND-RANDOM-NO
                                      * (ITIN-SERIAL-MAX 
                                         - ITIN-SERIAL-MIN
                                         + 1)
                                      + ITIN-SERIAL-MIN  

           SET  FI-DX           UP BY 1
           MOVE 'ITIN-SERIAL'      TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)

           MOVE W-SERIAL           TO FORMAT-ITIN-SERIAL
                                      FORMAT-ITIN-HYPHEN-SERIAL
           .
       SUB-9020-EXIT.
           EXIT.
      /
       SUB-9030-SSN.
      *-------------

      **** SSN AREA:

           MOVE SSN-AREA-EXCL      TO W-AREA

           PERFORM UNTIL W-AREA NOT = SSN-AREA-EXCL
               PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

               COMPUTE W-AREA      =  FAKRAND-RANDOM-NO
                                      * (  SSN-AREA-MAX 
                                         - SSN-AREA-MIN
                                         + 1)
                                      + SSN-AREA-MIN
           END-PERFORM  

           SET  FI-DX           UP BY 1
           MOVE 'SSN-AREA'         TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)

           MOVE W-AREA             TO FORMAT-SSN-AREA
                                      FORMAT-SSN-HYPHEN-AREA

      **** SSN GROUP:

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-GROUP         =  FAKRAND-RANDOM-NO
                                      * (SSN-GROUP-MAX 
                                         - SSN-GROUP-MIN
                                         + 1)
                                      + SSN-GROUP-MIN  

           SET  FI-DX           UP BY 1
           MOVE 'SSN-GROUP'        TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)

           MOVE W-GROUP            TO FORMAT-SSN-GROUP
                                      FORMAT-SSN-HYPHEN-GROUP

      **** SSN SERIAL:

           PERFORM SUB-9901-CALL-FAKRAND THRU SUB-9901-EXIT

           COMPUTE W-SERIAL        =  FAKRAND-RANDOM-NO
                                      * (SSN-SERIAL-MAX 
                                         - SSN-SERIAL-MIN
                                         + 1)
                                      + SSN-SERIAL-MIN  

           SET  FI-DX           UP BY 1
           MOVE 'SSN-SERIAL'      TO FAKER-TABLE(FI-DX)
           MOVE FAKRAND-RANDOM-NO  TO FAKER-RANDOM-NO-SUB(FI-DX)

           MOVE W-SERIAL           TO FORMAT-SSN-SERIAL
                                      FORMAT-SSN-HYPHEN-SERIAL
           .
       SUB-9030-EXIT.
           EXIT.
      /
       SUB-9901-CALL-FAKRAND.
      *----------------------

           CALL W-FAKRAND-PROG  USING W-FAKRAND-PARAMETER 
           .
       SUB-9901-EXIT.
           EXIT.
