; personal project for anime defenders
#Requires AutoHotkey >=v2.0.12
#Include endys_utilities.ahk
loopFlag := false
SendMode "Event"

dir := A_ScriptDir
RegExMatch(dir, "((.*)lib)", &a)

config := a[2] "config.ini"

unit1 := IniRead(config, "config", "unit1")
unit2 := IniRead(config, "config", "unit2")
unit3 := IniRead(config, "config", "unit3")
unit4 := IniRead(config, "config", "unit4")
unit5 := IniRead(config, "config", "unit5")
unit6 := IniRead(config, "config", "unit6")

units := {}
counter := 1
for i, k in [unit1, unit2, unit3, unit4, unit5, unit6] {
    if k = 1 {
        units.%counter% := i
        counter += 1
    }
}

StartGameLoop(*)
{
    global loopFlag
    global units
    loopFlag := true


    While loopFlag ; i need to find a way to stop the loop halfway through
    {
        if ObjOwnPropCount(units) != 0 {
            ; thank you TheEndyy for the unit placement
            loop 3
            {
                for i in range(5) {
                    Sleep 250
                    Row1L(i, 1)
                    Sleep 250
                    Row1L(i, -1)
                }
            }
            Sleep 5000
            Sleep 500
            Loop 2
            {
                for i in range(5) {
                    Upg1L(i, 1) ; upgades units
                    Sleep 500
                    Upg1L(i, -1)
                    Sleep 150
                }
            }
            while loopFlag {
                loop 1
                {
                    for i in range(5) {
                        Sleep 250
                        Row1L(i, 1)
                        Sleep 250
                        Row1L(i, -1)
                    }
                }
                Sleep 5000
                Sleep 500
                Loop 3
                {
                    for i in range(5) {
                        Upg1L(i, 1) ; upgades units
                        Sleep 500
                        Upg1L(i, -1)
                        Sleep 150
                    }
                }
            }
        }
        else {
            Sleep(10000)
        }
    }
}

AlignPlayer(*)
{
    Send "{s down}"
    Sleep 400
    Send "{a down}"
    Sleep 3500
    Send "{s up}"
    Sleep 50
    Send "{a up}"
}

StartInf(*)
{
    MouseMove(548, 364, 5)
    Sleep 250
    Click
    Sleep 250
    MouseMove(850, 700, 5)
    Sleep 250
    Click
    Sleep 250
    MouseMove(983, 802, 5)
    Sleep 250
    Click
    Sleep 250
    MouseMove(1539, 642, 5)
    Sleep 250
    Click
}


PlaceUnit(*)
{
    global units
    randNum := Random(1, ObjOwnPropCount(units))
    randUnit := units.%randNum%
    Send "{" randUnit " down}"
    Sleep 50
    Send "{" randUnit " up}"
    Sleep 50
    Send "{e down}"
    Sleep 50
    Send "{e up}"
    Sleep 50
    Send "{c down}"
    Sleep 50
    Send "{c up}"
    Sleep 50
}

Upgrade(*)
{
    Sleep 50
    Click
    Sleep 250
    if ImageSearch(&aux, &auy, 0, 0, 1920, 1080, "*90 images\autouse.png") {
        MouseMove aux, auy, 5
        Sleep 50
        Click
        Sleep 50
    }
    if ImageSearch(&upx, &upy, 0, 0, 1920, 1080, "*90 images\upgrade_green.png") {
        MouseMove upx, upy, 5
        Sleep 50
        Click
        Sleep 50
        MouseMove 1920 / 2, 400, 5
        Sleep 50
        if ImageSearch(&upx, &upy, 0, 0, 1920, 1080, "*90 images\upgrade_green.png") {
            MouseMove upx, upy, 5
            Sleep 50
            Click
            Sleep 50
            MouseMove 1920 / 2, 400, 5
            Sleep 50
        }
        Click
        Sleep 50
    }
}
; thank you TheEndyy for the unit placement
Row1L(rowcount, minus) {
    Loop (3)
    {
        Sleep 200
        MouseMove(960 - (90 * A_Index * minus), 270 + 90 * rowcount, 5)
        PlaceUnit()
    }
}


; CALL UPGRADE() INSTEAD OF PLACEUNIT() UNDER THIS

Upg1L(rowcount, minus) {
    Loop (3)
    {
        Sleep 200
        MouseMove(960 - (90 * A_Index * minus), 270 + 90 * rowcount, 5)
        Upgrade()
    }
}

while true {
    Sleep 1000
    StartGameLoop()
}
