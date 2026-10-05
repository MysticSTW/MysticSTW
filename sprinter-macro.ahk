; Sprinter arrow-key masher (AutoHotkey v2)
;   1 = start / stop
;   2 = slower (use if the runner trips)
;   3 = faster
;   4 = quit the script
;
; Number-row keys are used so laptop / 60% keyboard users don't need Fn.
;
; Maximum speed without tripping: the game can only read one key change per
; frame. Two changes in the same frame look like both arrows at once (or the
; same arrow twice) and the runner trips. So this locks every stride to the
; screen's refresh (DwmFlush waits for the next frame): exactly one stride per
; frame, never two, never both arrows held. That's the fastest the game can
; register. If the game runs at a lower fps than your monitor (e.g. 60 fps on
; a 144 Hz screen), press 2 to use one stride every 2 or 3 frames.
#Requires AutoHotkey v2.0
#SingleInstance Force
ProcessSetPriority "High"
SendMode "Event"
SetKeyDelay -1, -1

FramesPerStride := 1      ; 1 = one stride every screen frame (max speed)
running := false

1:: {
    global running
    running := !running
    if running
        SetTimer Spam, -1
    Show(running ? "ON" : "OFF")
}

2:: {
    global FramesPerStride
    FramesPerStride += 1
    Show("1 stride every " FramesPerStride " frames")
}

3:: {
    global FramesPerStride
    FramesPerStride := Max(1, FramesPerStride - 1)
    Show(FramesPerStride = 1 ? "max speed (1 stride per frame)" : "1 stride every " FramesPerStride " frames")
}

4:: {
    Send "{Left up}{Right up}"
    ExitApp
}

Spam() {
    global running, FramesPerStride
    key := "Left"
    WaitFrame()
    Send "{Left down}"
    while running {
        loop FramesPerStride
            WaitFrame()
        other := (key = "Left") ? "Right" : "Left"
        Send "{" key " up}{" other " down}"   ; release first, never both down
        key := other
    }
    Send "{" key " up}"
}

; Block until the next screen refresh.
WaitFrame() {
    if DllCall("dwmapi\DwmFlush") != 0     ; desktop compositor off: ~60 fps fallback
        DllCall("Sleep", "UInt", 16)
}

Show(msg) {
    ToolTip "Sprinter macro: " msg
    SetTimer () => ToolTip(), -1200
}
