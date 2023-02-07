#imports
import os
import posix
import strutils
import strformat

#functions
proc crimsonPatch(drive: string) =
    echo "is '" & drive & "' the drive with flex (will have 12 partitions!)"
    let fs = readLine(stdin)
    case fs
    of "y":
        echo "Patching grub..."
        if "*" in drive:
            let bootPart = drive.replace("*", "")
            createDir("/mnt/crimson")
            let mount = execShellCmd(fmt("sudo mount {bootPart} /mnt/crimson"))
            if mount == 32:
                echo fmt("Mount failed probably, use dd to flash the contents of {bootPart} to a usb drive\nthen specify that usb drive when you re-run this command")
                removeDir("/mnt/crimson")
            else:
                let grubFile = readFile("/mnt/crimson/efi/boot/grub.cfg")
                let fixedGrub = grubFile.replace("noresume", "noresume cros_debug")
                removeFile("/mnt/crimson/efi/boot/grub.cfg")
                writeFile("/mnt/crimson/efi/boot/grub.cfg", fixedGrub)
                echo "Grub has been patched, now do what you did to get the boot part data onto the usb, but reverse if= and of=\nIt'll output a storage error but don't worry it likely flashed fine"

        elif "nvme" in drive:
            let bootPart = fmt("{drive}p12")
            createDir("/mnt/crimson")
            let mount = execShellCmd(fmt("sudo mount {bootPart} /mnt/crimson"))
            if mount == 32:
                echo fmt("Mount failed probably, use dd to flash the contents of {bootPart} to a usb drive\nthen specify that usb drive when you re-run this command")
                removeDir("/mnt/crimson")
            else:
                let grubFile = readFile("/mnt/crimson/efi/boot/grub.cfg")
                let fixedGrub = grubFile.replace("noresume", "noresume cros_debug")
                removeFile("/mnt/crimson/efi/boot/grub.cfg")
                writeFile("/mnt/crimson/efi/boot/grub.cfg", fixedGrub)
                echo "Grub has been patched, feel free to reboot safely and boot back into ChromeOS"

        elif "sd" in drive:
            let bootPart = fmt("{drive}12")
            createDir("/mnt/crimson")
            let mount = execShellCmd(fmt("sudo mount {bootPart} /mnt/crimson"))
            if mount == 32:
                echo fmt("Mount failed probably, use dd to flash the contents of {bootPart} to a usb drive\nthen specify that usb drive when you re-run this command")
                removeDir("/mnt/crimson")
            else:
                let grubFile = readFile("/mnt/crimson/efi/boot/grub.cfg")
                let fixedGrub = grubFile.replace("noresume", "noresume cros_debug")
                removeFile("/mnt/crimson/efi/boot/grub.cfg")
                writeFile("/mnt/crimson/efi/boot/grub.cfg", fixedGrub)
                echo "Grub has been patched, feel free to reboot safely and boot back into ChromeOS"
    else:
        echo "ok then ig..."
        quit(0)

proc crewInstall() =
    if fileExists("/usr/local/bin/crew"):
        echo "ChromeBrew is already installed"
        quit(0)
    else:
        echo "Installing..."
        discard execShellCmd("curl -Ls git.is/vddgY | bash")
    
proc crimsonInit() =
    #checks if grub needs patched
    let grubFile = readFile("/boot/efi/boot/grub.cfg")
    if "cros_debug" in grubFile:
        echo "Grubs fine :)"
    else:
        let fixedGrub = grubFile.replace("noresume", "noresume cros_debug")
        removeFile("/boot/efi/boot/grub.cfg")
        writeFile("/boot/efi/boot/grub.cfg", fixedGrub)
        echo "Grub needed to be fixed but its all good now"
    #checks if any updates happened
    let update = fileExists("/usr/share/chromeos-assets/Crimson-Check.dont.delete")
    if not update:
        echo "This is either your first run or an update has happened recently :(, re-apply your boot animation if you set one"
        writeFile("/usr/share/chromeos-assets/Crimson-Check.dont.delete", "Just putting sum here for funzies")
    else:
        echo "No updates recently :)"
    #remounts / as rw for fun :)
    discard execShellCmd("sudo mount -o remount,rw /")

proc bootAnimBackup() =
    let backupDir = joinPath(getHomeDir(), ".backup") 
    echo "Checking for backup directory..."
    if dirExists(backupDir):
        echo "Dir found"
    else:
        echo "Making backup dir @ " & backupDir
        createDir(backupDir)
    let oneBackup = joinPath(backupDir, "bootanimation-100")
    let twoBackup = joinPath(backupDir, "bootanimation-200")
    createDir(oneBackup)
    createDir(twoBackup)
    echo "Backing up current bootanimation..."
    copyDir("/usr/share/chromeos-assets/images_100_percent", oneBackup)
    copyDir("/usr/share/chromeos-assets/images_200_percent", twoBackup)
    copyFile("/etc/init/boot-splash.conf", joinPath(backupDir, "boot-splash.conf"))

proc bootAnimSet() =
        let frameInterval = open(joinPath(paramStr(2), "frame-interval"))
        let configFile = readFile("/etc/init/boot-splash.conf")
        let newConfig = configFile.replace("25", fmt("<{frameInterval.readLine()} * 1000>"))
        removeFile("/etc/init/boot-splash.conf")
        writeFile("/etc/init/boot-splash.conf", newConfig)
        for kind, file in walkDir("/usr/share/chromeos-assets/images_100_percent"):
            if "boot" in $file:
                removeFile($file)
        for kind, file in walkDir("/usr/share/chromeos-assets/images_200_percent"):
            if "boot" in $file:
                removeFile($file)
        for kind, file in walkDir(paramStr(2)):
            if "boot" in $file:
                copyFileToDir($file, "/usr/share/chromeos-assets/images_100_percent")
                copyFileToDir($file, "/usr/share/chromeos-assets/images_200_percent")

#main
var isRoot = geteuid() == 0
let help = """crimsonMoon [OPTION] [DIR] <-- (if aplicable)
-bb             Backs up boot animation currently set
-sb             Sets boot animation, requires arg pointing to the folder with the files
-i              Does init work, sould be put into ~/bashrc for best effect
--install       Installs given script/program. possible programs: (chromebrew)
-h              this menu :P"""

case paramCount()
of 0:
    echo help
of 1:
    case paramStr(1)
    of "-bb":
        bootAnimBackup()
    of "-i":
        if not isRoot:
            echo "run as root bruh"
            quit(0)
        crimsonInit()
    of "-h", "--help":
        echo help
    else:
        echo "idk what that means --> " & paramStr(1)
of 2:
    case paramStr(1)
    of "-p":
        if not isRoot:
            echo "run as root bruh"
            quit(0)
        crimsonPatch(paramStr(2))
    of "-sb":
        if not isRoot:
            echo "run as root bruh"
            quit(0)
        bootAnimSet()
    of "--install":
        if not isRoot:
            echo "run as root bruh"
            quit(0)
        case paramStr(2)
        of "chromebrew", "crew":
            crewInstall()
        else:
            echo "Not a valid program name"
    else:
        echo "idk what that means --> " & paramStr(2)
else:
    echo $paramCount() & " is to many args its confusing me ;("
    echo help
