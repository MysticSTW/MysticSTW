; Sprinter arrow-key masher (AutoHotkey v2)
;   F1  = start / stop spamming Left, Right, Left, Right...
;   Esc = quit the script
;
; If the game misses presses, raise HoldMs and/or GapMs a little (e.g. 10-20).
#Requires AutoHotkey v2.0
#SingleInstance Force
ProcessSetPriority "High"
SendMode "Event"          ; games read Event mode reliably
SetKeyDelay -1, -1        ; no built-in delay; we control timing ourselves
DllCall("Winmm\timeBeginPeriod", "UInt", 1)  ; 1 ms timer resolution

HoldMs := 5               ; how long each key is held down
GapMs  := 0               ; pause after releasing a key

running := false

F1:: {
    global running
    running := !running
    if running
        SetTimer Spam, -1
    ToolTip running ? "Sprinter macro: ON" : "Sprinter macro: OFF"
    SetTimer () => ToolTip(), -800
}

Esc::ExitApp

Spam() {
    global running, HoldMs, GapMs
    while running {
        Tap("Left")
        Tap("Right")
    }
}

Tap(key) {
    global HoldMs, GapMs
    Send "{" key " down}"
    DllCall("Sleep", "UInt", HoldMs)   ; ms-accurate sleep (AHK's Sleep rounds to ~15 ms)
    Send "{" key " up}"
    if GapMs
        DllCall("Sleep", "UInt", GapMs)
}
