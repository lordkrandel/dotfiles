#!/usr/bin/nimscript

import std/[os, strutils, times, re]

const
    MonthCodes = [
        "XX", "jan", "feb", "mar", "apr", "may", "jun",
        "jul", "aug", "sept", "oct", "nov", "dec"
    ]

proc spawnRofi() =
    let
        ora = now()
        topBarDate = ora.format("HH:mm    dd MMM yyyy")
        oggi = $ora.monthday
        tmpFile = "/tmp/cal_tmp.txt"

    discard execShellCmd("cal -n 1 > " & tmpFile)
    var calRighe: seq[string] = @[]

    if fileExists(tmpFile):
        let righe = readFile(tmpFile).strip().splitLines()
        for i in 1 ..< righe.len:
            let rigaFiltrata = righe[i].replace(re(r"\b" & oggi & r"\b"), oggi & "<")
            calRighe.add(rigaFiltrata)

    let calFinale = calRighe.join("\n")

    let launchCmd = "~/projects/scripts/rofi_choice.nim" &
        " -theme \"~/projects/scripts/rofi_choice_calendar.rasi\"" &
        " Calendario" &
        " \" \"" &
        " \"" & topBarDate & "\"" &
        " \" \"" &
        " \"" & calFinale & "\"" &
        " &"

    discard execShellCmd(launchCmd)

proc echoDate() =
    let now = now()
    let ds = (now.hour * 3600) + (now.minute * 60) + now.second
    let mIdx = int(now.month)
    let mc = if mIdx >= 1 and mIdx <= 12: MonthCodes[mIdx] else: "XX"
    echo align($ds, 5, '0') & "  ·  " & align($now.monthday, 2, '0') & " " & mc

when isMainModule:
    if getEnv("BLOCK_BUTTON") != "":
        spawnRofi()
    echoDate()
