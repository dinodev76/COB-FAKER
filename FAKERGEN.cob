       IDENTIFICATION DIVISION.
      *========================

       PROGRAM-ID.             FAKERGEN.
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
           SELECT GNRTFILE             ASSIGN 'Data\FAKERGEN Output.txt'
                                       ORGANIZATION LINE SEQUENTIAL. 
      /
       DATA DIVISION.
      *==============

       FILE SECTION.
      *-------------

       FD  GNRTFILE.

       01  GNRTFILE-REC.
           05  G-PERSON-PREFIX     PIC X(10).
           05  G-PERSON-FIRST-NAME PIC X(25). 
           05  G-PERSON-LAST-NAME  PIC X(35). 
           05  G-PERSON-SUFFIX     PIC X(10).
           05  G-SSN               PIC X(10).
           05  G-ADDRESS-STREET    PIC X(35).
           05  G-ADDRESS-CITY      PIC X(25).
           05  G-ADDRESS-STATE     PIC X(10).
           05  G-ADDRESS-POSTCODE  PIC X(10).

       WORKING-STORAGE SECTION.
      *------------------------

       01  W-REC-CNT               PIC 9(4)   COMP VALUE 0.
       01  W-TEST-CNT              PIC 9(6)   COMP.
       01  W-FAKER-PROG            PIC X(08)       VALUE 'FAKER'.

       01  W-ERROR-MSG             PIC X(21)       VALUE
           '**** FAKERGEN error: '.

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

           PERFORM SUB-2000-PROCESS THRU SUB-2000-EXIT
               1000 TIMES

           PERFORM SUB-3000-SHUT-DOWN THRU SUB-3000-EXIT
           .
       MAIN-EXIT.
           STOP RUN.
      /
       SUB-1000-START-UP.
      *------------------

           MOVE FUNCTION WHEN-COMPILED 
                                   TO W-COMPILED-DATE

           DISPLAY 'FAKERGEN Compiled = '
               W-COMPILED-DATE-YYYY '/'
               W-COMPILED-DATE-MM   '/'
               W-COMPILED-DATE-DD   ' '
               W-COMPILED-TIME-HH   ':'
               W-COMPILED-TIME-MM   ':'
               W-COMPILED-TIME-SS

           DISPLAY ' '

           OPEN OUTPUT GNRTFILE
           .
       SUB-1000-EXIT.
           EXIT.
      /
       SUB-2000-PROCESS.
      *-----------------

           SET  PERSON-NAME        TO TRUE
           ADD  1                  TO W-REC-CNT
      *    MOVE W-REC-CNT          TO FAKER-SEED-NO

           PERFORM SUB-2100-CALL-FAKER THRU SUB-2100-EXIT

           MOVE FAKER-PERSON-PREFIX
                                   TO G-PERSON-PREFIX
           MOVE FAKER-PERSON-FIRST-NAME
                                   TO G-PERSON-FIRST-NAME
           MOVE FAKER-PERSON-LAST-NAME
                                   TO G-PERSON-LAST-NAME
           MOVE FAKER-PERSON-SUFFIX
                                   TO G-PERSON-SUFFIX   
           MOVE SPACES             TO G-SSN             

           SET  ADDRESS-ADDRESS    TO TRUE
           
           PERFORM SUB-2100-CALL-FAKER THRU SUB-2100-EXIT

           MOVE FAKER-ADDRESS-STREET
                                   TO G-ADDRESS-STREET  
           MOVE FAKER-ADDRESS-CITY TO G-ADDRESS-CITY    
           MOVE FAKER-ADDRESS-STATE
                                   TO G-ADDRESS-STATE   
           MOVE FAKER-ADDRESS-POSTCODE
                                   TO G-ADDRESS-POSTCODE

           PERFORM SUB-9100-WRITE-GNRTFILE THRU SUB-9100-EXIT
           .
       SUB-2000-EXIT.
           EXIT.
      /
       SUB-2100-CALL-FAKER.
      *--------------------

           CALL W-FAKER-PROG    USING W-FAKER-PARAMETER 

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
      
           CLOSE GNRTFILE

           DISPLAY ' '

           DISPLAY 'FAKERGEN Successfully Completed'
           .
       SUB-3000-EXIT.
           EXIT.
      /
       SUB-9100-WRITE-GNRTFILE.
      *------------------------
      
           WRITE GNRTFILE-REC
           .
       SUB-9100-EXIT.
           EXIT.
