# COB-FAKER

COBOL port (partial) of the Python Faker project - used to generate or anonymize test data requiring names, addresses, etc.

The project was ported to COBOL for use on platforms that don't support the currently available projects: primarily mainframes.  It was, however, developed and tested on a Windows 10 machine using GnuCOBOL and Visual Studio Code, but it should be very easy to upload to other platforms and compile and run there.

## Getting Started

These instructions will get you a copy of the project up and running on your local Windows machine for development and testing purposes.

### Prerequisites

1. GnuCOBOL
2. Your favorite IDE (mine is the free Visual Studio Code)

### Installing

1. Download GnuCOBOL:
    See the options at https://www.arnoldtrembley.com/GnuCOBOL.htm.
    For Windows 64 bit, a real easy way to go is https://www.arnoldtrembley.com/GC30B-64bit-rename-7z-to-exe.7z, and the following instructions assume this.

2. Rename the '.7z' to '.exe' and run it, or use 7-Zip to extract all folders/files to C:\GnuCOBOL (or your desired location).  Your folder structure should look like this:

<pre>
    GnuCOBOL   
        bin  
        etc  
        include  
        lib  
        share  
        x86_64-w64-mingw32 
</pre>

3. If you do not already have VS Code, download and install it from here: https://code.visualstudio.com/download.

4. Download the COB-FAKER project, e.g. to C:\COB-FAKER.  Your folder structure should look something like this:

<pre>
    COB-FAKER
        .vscode
        Bin
        CopyBooks
        Data
        Listings
</pre>

5. Run VS Code and select File/Open Folder..., and open the above COB-FAKER folder to get started.

## Compiling and Running the Provided Programs

1. **FAKER**: This subroutine generates random fake names, addresses, tax ids, etc. To compile it from VS Code, click on FAKER.cob and select Terminal/Run Task.../Compile Selected Subroutine. That will create FAKER.dll in the BIN folder. Use the parameter copybook FAKERLNK.cpy when calling FAKER.

    FAKER calls one or more of the following subroutines from this project, as appropriate:

    * **FAKADDR**
    * **FAKBANK**
    * **FAKCOMP**
    * **FAKPERS**
    * **FAKPHON**
    * **FAKRAND**
    * **FAKTXID**

    FAKER also uses the following subroutines from the GC-Utilities project (the DLLs have been copied to the BIN folder of this project):

    * **BITWISE**
    * **CRC32**

2. **FAKERGEN**: this program generates 1000 random names and addresses and outputs the results to "FAKERGEN Output.txt".  To compile and run it from VS Code, click on FAKERGEN.cob and select Terminal/Run Task.../Compile and Run Selected Main Program.

3. **FAKERTST**: this program reads "FAKERTST Input.txt", calls FAKER for each of the specified commands, and writes the results to "FAKERTST Output.txt".  To compile and run it from VS Code, click on FAKERTST.cob and select Terminal/Run Task.../Compile and Run Selected Main Program.

## Authors

* **Brian D Pead** - *Initial work*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Many thanks to the following:

* Arnold Trembley for the GnuCOBOL builds and instructions - see https://www.arnoldtrembley.com/.
* The many developers of GnuCOBOL and its predecessors - see https://sourceforge.net/projects/open-cobol/.
* Those who developed the Python Faker and its predecessors - see https://github.com/joke2k/faker.
