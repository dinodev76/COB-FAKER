       IDENTIFICATION DIVISION.
      *========================

       PROGRAM-ID.             FAKER.
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

       01  W-FAKER-PROVIDER        PIC X(12).
       01  W-FAKADDR-PROG          PIC X(08)       VALUE 'FAKADDR'.
       01  W-FAKCOMP-PROG          PIC X(08)       VALUE 'FAKCOMP'.
       01  W-FAKPERS-PROG          PIC X(08)       VALUE 'FAKPERS'.
       01  W-FAKSSN-PROG           PIC X(08)       VALUE 'FAKSSN'.

       01  W-ERROR-MSG             PIC X(18)       VALUE
           '**** FAKER error: '.

       01  FILLER                  PIC X(01)       VALUE 'Y'.
           88  W-FIRST-CALL                        VALUE 'Y'.
           88  W-NOT-FIRST-CALL                    VALUE 'N'.

       01  W-COMPILED-DATE.
           05  W-COMPILED-DATE-YYYY
                                   PIC X(04).
           05  W-COMPILED-DATE-MM  PIC X(02).
           05  W-COMPILED-DATE-DD  PIC X(02).
           05  W-COMPILED-TIME-HH  PIC X(02).
           05  W-COMPILED-TIME-MM  PIC X(02).
           05  W-COMPILED-TIME-SS  PIC X(02).
           05  FILLER              PIC X(07).
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

           MOVE SPACES             TO FAKER-RESULT
                                      FAKER-RESULT-FIELDS
           MOVE 0                  TO FAKER-INFO-CNT
           MOVE LOW-VALUES         TO FAKER-INFO-OCCS

           IF      W-NOT-FIRST-CALL
               GO TO SUB-1000-EXIT
           END-IF

           SET W-NOT-FIRST-CALL    TO TRUE
           MOVE FUNCTION WHEN-COMPILED 
                                   TO W-COMPILED-DATE

           DISPLAY 'FAKER Compiled = '
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
           
           UNSTRING FAKER-PROVIDER-FUNCTION
                            DELIMITED '-'
                                 INTO W-FAKER-PROVIDER

           EVALUATE W-FAKER-PROVIDER
             WHEN 'ADDRESS'
               CALL W-FAKADDR-PROG
                                USING L-PARAMETER
             WHEN 'COMPANY'
               CALL W-FAKCOMP-PROG
                                USING L-PARAMETER
             WHEN 'PERSON'
               CALL W-FAKPERS-PROG
                                USING L-PARAMETER
             WHEN 'SSN'
               CALL W-FAKSSN-PROG
                                USING L-PARAMETER
             WHEN OTHER
               DISPLAY W-ERROR-MSG
                       'FAKER provider "'
                       W-FAKER-PROVIDER
                       '" not supported'
           END-EVALUATE
           .
       SUB-2000-EXIT.
           EXIT.
      /
       SUB-3000-SHUT-DOWN.
      *-------------------

      D    DISPLAY ' '

      D    DISPLAY 'FAKER Successfully Completed'
           .
       SUB-3000-EXIT.
           EXIT.
