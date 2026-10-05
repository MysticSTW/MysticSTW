; Arrow keys without Fn (AutoHotkey v2)
; Fn can't be held from software (the keyboard handles it in hardware and
; never tells Windows about it), so this turns normal keys into arrow keys.
; They stay arrows the whole time the script is running:
;   W = Up   A = Left   S = Down   D = Right
;   Ctrl+Alt+Q = turn the script off (or right-click the tray icon > Exit)
; Change the letters below if you'd rather use other keys.
#Requires AutoHotkey v2.0
#SingleInstance Force

w::Up
a::Left
s::Down
d::Right

^!q::ExitApp
