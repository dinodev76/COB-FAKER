      *========================== COB-FAKER ===========================*
      * Authors: Brian D Pead
      *
      * License: MIT
      *
      * Date        Version  Description
      * ----        -------  -----------
      * 2020-01-12  0.1      First release
      *================================================================*

       IDENTIFICATION DIVISION.
      *========================

       PROGRAM-ID.             FAKERTST.

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
           SELECT TESTFILE             ASSIGN 'Data\FAKERTST Input.txt'
                                       ORGANIZATION LINE SEQUENTIAL. 
      /
       DATA DIVISION.
      *==============

       FILE SECTION.
      *-------------

       FD  TESTFILE.

       01  TESTFILE-REC.
           05  TEST-PROVIDER-FUNCTION      PIC X(30).
           05  TEST-COUNT          PIC 9(6). 

       WORKING-STORAGE SECTION.
      *------------------------

       01  W-REC-CNT               PIC 9(4)   COMP VALUE 0.
       01  W-TEST-CNT              PIC 9(6)   COMP.
       01  W-FAKER-PROG            PIC X(08)       VALUE 'FAKER'.

       01  W-ERROR-MSG             PIC X(21)       VALUE
           '**** FAKERTST error: '.

       01  FILLER                  PIC X(01)       VALUE 'N'.
           88  W-EOF                               VALUE 'Y'.

       01  W-COMPILED-DATE.
           05  W-COMPILED-DATE-YYYY
                                   PIC X(04).
           05  W-COMPILED-DATE-MM  PIC X(02).
           05  W-COMPILED-DATE-DD  PIC X(02).
           05  W-COMPILED-TIME-HH  PIC X(02).
           05  W-COMPILED-TIME-MM  PIC X(02).
           05  W-COMPILED-TIME-SS  PIC X(02).
           05  FILLER              PIC X(07).

       01  W-FAKER-PARAMETER.      COPY FAKERLNK.
      /
       PROCEDURE DIVISION.
      *===================

       MAIN.
      *-----

           PERFORM SUB-1000-START-UP THRU SUB-1000-EXIT

           PERFORM SUB-9100-READ-TESTFILE THRU SUB-9100-EXIT

           PERFORM SUB-2000-PROCESS THRU SUB-2000-EXIT
               UNTIL W-EOF

           PERFORM SUB-3000-SHUT-DOWN THRU SUB-3000-EXIT
           .
       MAIN-EXIT.
           STOP RUN.
      /
       SUB-1000-START-UP.
      *------------------

           MOVE FUNCTION WHEN-COMPILED 
                                   TO W-COMPILED-DATE

           DISPLAY 'FAKERTST Compiled = '
               W-COMPILED-DATE-YYYY '/'
               W-COMPILED-DATE-MM   '/'
               W-COMPILED-DATE-DD   ' '
               W-COMPILED-TIME-HH   ':'
               W-COMPILED-TIME-MM   ':'
               W-COMPILED-TIME-SS

           DISPLAY ' '

           OPEN INPUT TESTFILE
           .
       SUB-1000-EXIT.
           EXIT.
      /
       SUB-2000-PROCESS.
      *-----------------

           MOVE TEST-PROVIDER-FUNCTION
                                   TO FAKER-PROVIDER-FUNCTION

           IF      TEST-COUNT NUMERIC
               MOVE TEST-COUNT     TO W-TEST-CNT
           ELSE
               MOVE 1              TO W-TEST-CNT
           END-IF
           
           PERFORM SUB-2100-CALL-FAKER THRU SUB-2100-EXIT
               W-TEST-CNT TIMES
           .
       SUB-2000-READ.

           PERFORM SUB-9100-READ-TESTFILE THRU SUB-9100-EXIT
           .
       SUB-2000-EXIT.
           EXIT.
      /
       SUB-2100-CALL-FAKER.
      *--------------------

           CALL W-FAKER-PROG    USING W-FAKER-PARAMETER 

           DISPLAY TEST-PROVIDER-FUNCTION
                   ': '
                   FAKER-RESULT

           IF      ADDRESS-ADDRESS
           OR      PERSON-NAME
           OR      PERSON-NAME-MALE
           OR      PERSON-NAME-FEMALE
               DISPLAY '                              '
                       ': '
                       FAKER-RESULT-FIELDS
           END-IF

      D    PERFORM VARYING FI-DX FROM 1 BY 1
      D              UNTIL FI-DX > FAKER-INFO-CNT
      D        DISPLAY '    INFO: '
      D                FAKER-TABLE(FI-DX)
      D                ': '
      D                FAKER-RANDOM-NO-SUB(FI-DX)
      D                ', '
      D                FAKER-TABLE-ENTRY(FI-DX)
      D    END-PERFORM
           .
       SUB-2100-EXIT.
           EXIT.
      /
       SUB-3000-SHUT-DOWN.
      *-------------------
      
           CLOSE TESTFILE

           DISPLAY ' '

           DISPLAY 'FAKERTST Successfully Completed'
           .
       SUB-3000-EXIT.
           EXIT.
      /
       SUB-9100-READ-TESTFILE.
      *-----------------------
      
           READ TESTFILE
               AT END
                   SET  W-EOF          TO TRUE
               NOT AT END
                   ADD  1              TO W-REC-CNT
           END-READ
           .
       SUB-9100-EXIT.
           EXIT.
