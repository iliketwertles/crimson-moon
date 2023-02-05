# Crimson Moon:full_moon:
right now it only has backup/changing of the boot animation, improvements to that and other features will come with time/suggestions

idk what else to put here but if you break your device its not my fault

## Requirements
the only requirements are dev mode and root access, on flex you have to do some hackery to get dev mode but it is possible

## Commands
-bb     backs up current boot animation to ~/.backups/

-sb     sets boot animation

## Making boot animation
1. Make folder for the animation files (required)
2. Put animation files/frames/pictures into the folder
3. Name the files as `boot_splash_frameXX.png`, XX being the number (starting at 00, then 01 etc, must be 31 frames as of chromeos 109, if older check)
4. Make text file called `frame-interval` and put the frame interval in there (3 is generally safe but adjust if you dont know)
5. Run crimson moon with `-sb /path/to/folder`

## Building
1. who buildin this? :skull:
2. its nim, `nim c FILE`

## TODO
maybe way to magicly get dev mode on chromeos flex?
grub changes?
