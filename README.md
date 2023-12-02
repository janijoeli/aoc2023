# aoc2023
Advent of Code 2023 solutions in Commodore 64 Kick Assembler

My attempts to complete as many AoC 2023 challenges as possible in 6502 assembler, targeted for stock Commodore 64.

https://adventofcode.com/2023/about

Computer specs:
- CPU: MOS 6510 (fully 6502 compatible) @ 0.985 MHz (PAL version). Fully 8-bit, including all (three!) CPU registers. The only 16-bit thing is the width of memory bus.
- RAM: 64KB
- ROM: 20KB (~8KB kernal, ~8KB BASIC, 4KB character ROM)
- Screen: max 320×200 pixels, 16 colour fixed palette
- Data storage: 170K floppy drive or C-cassette

Goals for completing every challenge (where possible):
- Input file is included as-is. That is, all reading, interpreting and massaging of input data is done on the C64, at runtime, rather than preparing the data into more suitable form either pre-compilation by using higher level languages, or at compile time in assembler macros. I may (have to) not follow this goal for every challenge, but I'll try my best.
- Focus is on code size where speed doesn't play a big factor, on speed where challenge requires lots of calculations. Of course with 985KHz CPU and 64KB of RAM, compromises may have to be taken, or challenges may prove to be impossible to implement on such hardware in the first place.

## How to compile and run these solutions

I use and recommend the following dev setup (use your favourite IDE or otherwise adapt to your needs):
- Kick Assembler: http://theweb.dk/KickAssembler
- Java 11, e.g. https://adoptium.net/temurin/releases/?version=11 (was OpenJDK 11)
- VS Code: https://code.visualstudio.com
- Paul Hocker's Kick Assembler extension (get via extensions in VS Code)
- VICE C64 emulator: https://vice-emu.sourceforge.io/index.html#download
- For the curious, Retro Debugger. Get latest from https://csdb.dk/scener/?id=28820

Insallations and configurations (see each application's installation guide for detailed info):
- Install and configure Java
- Unzip Kick Assembler to some convenient location
- Install VICE (and optionally Retro Debugger)
- Install VS Code and Paul's KickAss extension
- In extension's settings, tell it where your KickAss.jar and java (e.g. /usr/bin/java), emulator (e.g. x64sc.app or exe) and debugger (e.g. C64 Debugger.app or exe) runtimes are

Running the solutions:
- Open any .asm file from this repo and press F6 to compile and run it in Vice, or Shift-F6 to compile and run in the debugger. That's it!

At bare minimum, you'll need Java, KickAss.jar and an emulator to run the compiled .prg files on.