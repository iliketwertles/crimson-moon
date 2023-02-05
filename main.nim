#imports
import os
import posix
import strutils
import strformat

#functions
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
    var isRoot = geteuid() == 0
    if not isRoot:
        echo "run as root bruh"
        quit(0)
    else:
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
let help = "this will be a help message later :P"
case paramCount()
of 0:
    echo help
of 1:
    case paramStr(1)
    of "-bb", "--backupbootanim":
        bootAnimBackup()
    else:
        echo "idk what that means -->" & paramStr(1)
of 2:
    case paramStr(1)
    of "-sb", "--setbootanim":
        bootAnimSet()
else:
    echo $paramCount() & "is to many args its confusing me ;("