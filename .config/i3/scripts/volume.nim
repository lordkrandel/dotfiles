#!/usr/bin/nimscript

import std/[os, osproc, strutils, options]
import nre

const Space = "&#8201;"

proc pactlGetMute(): Option[bool] =
    let (outStr, code) = execCmdEx("pactl get-sink-mute @DEFAULT_SINK@")
    if code == 0: some(outStr.contains("yes")) else: none(bool)

proc pactlGetVolume(): Option[int] =
    let (outStr, code) = execCmdEx("pactl get-sink-volume @DEFAULT_SINK@")
    if code == 0:
        let match = outStr.find(re r"(\d+)%")
        if match.isSome:
            try: some(parseInt(match.get.captures[0])) except ValueError: none(int)
        else: none(int)
    else:
        none(int)

proc isSystemMuted(): bool =
    pactlGetMute().get(false)

proc getSystemVolume(): int =
    pactlGetVolume().get(0)

proc adjustVolume(delta: string) =
    if not isSystemMuted():
        discard execCmd("pactl set-sink-volume @DEFAULT_SINK@ " & delta)

proc handleClicks() =
    case getEnv("BLOCK_BUTTON")
    of "1": discard execCmd("pavucontrol &")
    of "3": discard execCmd("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    of "4": adjustVolume("+5%")
    of "5": adjustVolume("-5%")
    else: discard

# --- Output Rendering ---
proc renderStatus(volume: int, isMuted: bool) =
    let label = "vol"
    if isMuted:
        stdout.write("muted")
    else:
        stdout.write(label & Space & $volume)
    stdout.flushFile()

# --- Main Entry Point ---
proc main() =
    handleClicks()
    renderStatus(getSystemVolume(), isSystemMuted())

when isMainModule:
    main()
