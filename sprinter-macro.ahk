; Sprinter arrow-key masher (AutoHotkey v2)
;   1 = start / stop
;   2 = slower (use if the runner trips)
;   3 = faster
;   4 = quit the script
;
; Number-row keys are used so laptop / 60% keyboard users don't need Fn.
;
; How it avoids tripping: the two arrows are never held at the same time and
; never change twice inside one game frame. Each step releases one arrow and
; presses the other in the same instant (Left -> Right -> Left ...), one step
; per frame, on a precise fixed schedule. That's one stride every frame, which
; is the fastest the game can read, with no overlap and no doubled presses.
#Requires AutoHotkey v2.0
#SingleInstance Force
ProcessSetPriority "High"
SendMode "Event"
SetKeyDelay -1, -1
DllCall("Winmm\timeBeginPeriod", "UInt", 1)  ; 1 ms timer resolution
DllCall("QueryPerformanceFrequency", "Int64*", &Freq := 0)

StepMs := 17              ; time per stride; 17 ms = one frame at 60 fps
running := false

1:: {
    global running
    running := !running
    if running
        SetTimer Spam, -1
    Show(running ? "ON" : "OFF")
}

2:: {
    global StepMs
    StepMs += 1
    Show(StepMs " ms per stride")
}

3:: {
    global StepMs
    StepMs := Max(5, StepMs - 1)
    Show(StepMs " ms per stride")
}

4:: {
    Send "{Left up}{Right up}"
    ExitApp
}

Spam() {
    global running, StepMs, Freq
    key := "Left"
    Send "{Left down}"
    next := Now()
    while running {
        next += StepMs * Freq // 1000
        if Now() > next          ; fell behind (e.g. a lag spike): restart the
            next := Now()        ; schedule instead of bursting to catch up
        WaitUntil(next)
        other := (key = "Left") ? "Right" : "Left"
        Send "{" key " up}{" other " down}"   ; release first, so never both down
        key := other
    }
    Send "{" key " up}"
}

; Precise wait: sleep while far away, then spin for the last ~2 ms.
WaitUntil(t) {
    global Freq
    loop {
        remaining := t - Now()
        if remaining <= 0
            return
        if remaining * 1000 // Freq > 2
            DllCall("Sleep", "UInt", 1)
    }
}

Now() {
    DllCall("QueryPerformanceCounter", "Int64*", &t := 0)
    return t
}

Show(msg) {
    ToolTip "Sprinter macro: " msg
    SetTimer () => ToolTip(), -1000
}
