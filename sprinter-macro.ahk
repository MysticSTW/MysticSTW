; Sprinter arrow-key masher (AutoHotkey v2)
;   1 = start / stop spamming Left, Right, Left, Right...
;   2 = slower (use if the runner stutters or doesn't move)
;   3 = faster
;   4 = quit the script
;
; Number-row keys are used so laptop users don't need to hold Fn.
;
; Games read the keyboard once per frame (~16 ms at 60 fps). A key that is
; pressed and released inside one frame is never seen, so each key is held
; for at least a frame.
#Requires AutoHotkey v2.0
#SingleInstance Force
ProcessSetPriority "High"
SendMode "Event"
SetKeyDelay -1, -1
DllCall("Winmm\timeBeginPeriod", "UInt", 1)  ; 1 ms timer resolution

HoldMs := 20              ; how long each key is held down
running := false

1:: {
    global running
    running := !running
    if running
        SetTimer Spam, -1
    Show(running ? "ON" : "OFF")
}

2:: {
    global HoldMs
    HoldMs += 5
    Show("hold " HoldMs " ms")
}

3:: {
    global HoldMs
    HoldMs := Max(5, HoldMs - 5)
    Show("hold " HoldMs " ms")
}

4::ExitApp

Spam() {
    global running
    while running {
        Tap("Left")
        Tap("Right")
    }
}

Tap(key) {
    global HoldMs
    Send "{" key " down}"
    DllCall("Sleep", "UInt", HoldMs)
    Send "{" key " up}"
    DllCall("Sleep", "UInt", HoldMs)   ; released for a frame too, so the game sees the change
}

Show(msg) {
    ToolTip "Sprinter macro: " msg
    SetTimer () => ToolTip(), -1000
}
