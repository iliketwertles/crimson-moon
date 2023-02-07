# Crimson Moon:full_moon:
### This project is designed to fix/improve the chromeos flex experience for the more advanced users

idk what else to put here but if you break your device its not my fault

## Requirements
### Patching (enable dev mode)
* Live linux usb (if you can acces `CTRL + ALT + T` then typing `shell`, this is not needed)
* ChromeOS flex installed
## 
### How to patch
1. Boot live linux usb after installing ChromeOS flex
2. Ensure you have a internet connection
3. Download latest binary from releases tab
4. Run `sudo crimsonMoon -p /dev/sdX` replace sdX with your drive, might also be nvme0nX **NOT THE PARTITION, THE DRIVE ITSELF**
5. Assuming no issues, patching success

### Now, if there *were* issues:
* if it tells you to dd partition 12's data onto a usb, do it... e.g:`sudo dd if=/dev/sda12 of=/dev/sdb bs=4M`
* take into consideration that `sda12` and `sdb` will be replaced by the actual 12th partition and the actual usb
* **READ THIS FOR THIS ISSUE**
* when you goto re-run the command, regardless of the usb's numbering or name, but a * after it with no spaces, that tells the program to work stuff a little differently and output different stuff. it will *not* work if you do not do this
* I personally do not know the exact root of this issue nor what devices it will affect, i know for sure the MacBook Air 7,1 is affected if your using the stock ssd

## Installing
* Requires dev mode enabled
### How to install
1. Boot into chromeOS if not already
2. Ensure you have access to the shell (`CTRL + ALT + T` then typing `shell`)
3. Download latest binary from releases
4. Move it to `/usr/local/bin`
5. Run `sudo crimsonMoon -i` to run init for the first time, will get some warnings but everything should resolve itself 
6. Have fun!

## Commands
`-bb` Backs up current boot animation currently set

`-sb` Sets boot animation, requires arg pointing to the folder with the files

`-i`  Does init work, should be put into ~/.bashrc for best effect

`--install` Installs the given script/program. possible programs: (chromebrew)

`-p` Patches ChromeOS boot partition to enable dev mode

`-h` Help menu

## Boot animations
### Existing examples
stock chromeos flex [here](https://cdn.discordapp.com/attachments/1071876668370714654/1071878202051539024/cros_flex.zip)

troll face (static): [here](https://cdn.discordapp.com/attachments/1071876668370714654/1071876693016449094/trollboot.zip)

troll face (animated): Coming soon?

### Making your own
1. Make folder for the animation files (required)
2. Put animation files/frames/pictures into the folder
3. Name the files as `boot_splash_frameXX.png`, XX being the number, starting at 00, then 01 etc, (must be 31 frames as of chromeos 109, if older check)
4. Make text file called `frame-interval` and put the frame interval in there (3 is generally safe but adjust if you dont know and it looks weird)
5. Run `sudo crimsonMoon -sb /path/to/folder`

## Building
1. who buildin this? :skull:
2. its nim, `nim c FILE`

## TODO
grub changes? (theme, menu, etc)
