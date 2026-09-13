#!/usr/bin/nimscript

import std/[os, osproc, strutils]

const HalfSpace = "\u2009"

proc main() =
    let blockButton = getEnv("BLOCK_BUTTON")
    if blockButton == "4":
        discard execShellCmd("brightnessctl set 10%+ >/dev/null 2>&1")
    elif blockButton == "5":
        discard execShellCmd("brightnessctl set 10%- >/dev/null 2>&1")

    let (currStr, currCode) = execCmdEx("brightnessctl get")
    let (maxStr, maxCode) = execCmdEx("brightnessctl max")
    if currCode == 0 and maxCode == 0:
        try:
            let current = currStr.strip().parseInt()
            let maximum = maxStr.strip().parseInt()
            if maximum > 0:
                let percent = (current * 100) div maximum
                stdout.write("sun " & $percent & "\n")
                stdout.flushFile()
        except ValueError:
            discard

when isMainModule:
    main()
