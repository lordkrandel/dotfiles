#!/usr/bin/nimscript

import std/[os, osproc, strutils, sequtils, strformat]


proc getBatteryColor(percent: int): string =
    if percent < 10: getEnv("color_10", "#FFFFFF")
    elif percent < 20: getEnv("color_20", "#FF3300")
    elif percent < 40: getEnv("color_40", "#FF9900")
    elif percent < 60: getEnv("color_60", "#FFFF00")
    elif percent < 80: getEnv("color_80", "#FFFF66")
    else: getEnv("color_full", "#FFFFFF")


proc main() =
    let (status, code) = execCmdEx("acpi")
    var fulltext = ""
    var percentleft = 100

    let batteries = status.splitLines()
    var stateBatteries = newSeq[string]()
    var percentBatteries = newSeq[int]()

    for battery in batteries:
        if battery.len == 0: continue
        let parts = battery.split(": ")
        if parts.len < 2: continue

        let subParts = parts[1].split(", ")
        if subParts.len > 0:
            stateBatteries.add(subParts[0])

        if subParts.len > 1:
            let pStr = subParts[1].strip(chars = {'%', '\n', '\r', ' '})
            try:
                let p = parseInt(pStr)
                if p > 0:
                    percentBatteries.add(p)
            except ValueError:
                discard

    let state = if stateBatteries.len > 0: stateBatteries[0] else: "Unknown"
    if percentBatteries.len > 0:
        var sum = 0
        for p in percentBatteries: sum += p
        percentleft = sum div percentBatteries.len
    else:
        percentleft = 0

    let col = getBatteryColor(percentleft)
    fulltext = &"battery:<span color='{col}'>{percentleft}</span>"

    echo fulltext
    if percentleft < 10:
        quit(33)

when isMainModule:
    main()
