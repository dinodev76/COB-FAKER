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
        <other files>  
</pre>

3. If you do not already have VS Code, download and install it from here: https://code.visualstudio.com/download.

4. Download the COB-FAKER project, e.g. to C:\COB-FAKER.  Your folder structure should look something like this:

<pre>
    COB-FAKER  
        .git  
        .vscode  
        CopyBooks  
        Data  
        <other files>  
</pre>

5. Run VS Code and select File/Open Folder..., and open the above COB-FAKER folder to get started.

## Running the provided test programs

1. FAKERGEN: this program generates 1000 random names and addresses and outputs the results to "FAKERGEN Output.txt".  To compile and run it from VS Code, select Terminal/Run Task.../Compile and Run FAKERGEN.

2. FAKERTST: this program reads "FAKERTST Input.txt", calls FAKER for each of the specified commands, and displays the results.  To compile and run it from VS Code, select Terminal/Run Task.../Compile and Run FAKERTST.

## Authors

* **Brian Pead** - *Initial work*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Many thanks to those who developed the Python Faker and its predecessors - see https://github.com/joke2k/faker.
