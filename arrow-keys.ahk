; Arrow keys without Fn (AutoHotkey v2)
; Fn can't be held from software (the keyboard handles it in hardware and
; never tells Windows about it), so this turns normal keys into arrow keys:
;   W = Up   A = Left   S = Down   D = Right
;   CapsLock = turn the remap on/off (so you can type normally)
; Change the letters below if you'd rather use other keys.
#Requires AutoHotkey v2.0
#SingleInstance Force

w::Up
a::Left
s::Down
d::Right

#SuspendExempt
CapsLock:: {
    Suspend
    ToolTip A_IsSuspended ? "Arrow keys: OFF" : "Arrow keys: ON"
    SetTimer () => ToolTip(), -1000
}
