#Include lib\OCR.ahk

f1:: {
    abc := OCR.FromRect(0, 1000, 500, 80, "en", 1)
    ToolTip abc.Text, 1600, 300
}

f2:: {
    Reload
}

f3:: {
    ExitApp
}