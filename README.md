# Gameboy-Side-Scroller-Shooter
This is the repo for the Gameboy game I'm working on.
Currently I have the movement of the player, the player sprite, and the shooting functionality working

Next steps are to create the background of the game and to create enemies.

To play, run the main.gb file in an emulator.

To compile the .c file, use the following code after installing GBDK (GameBoy Development Kit)

C:\gbdk\bin\lcc -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG -c -o main.o main.c
C:\gbdk\bin\lcc -Wa-l -Wl-m -Wl-j -DUSE_SFR_FOR_REG -o main.gb main.o
