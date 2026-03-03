Process, Priority, , High
SetBatchLines, -1
ListLines, Off
SetKeyDelay, -1, -1
SetMouseDelay, 10
SendMode, Event
CoordMode, Pixel, Window  
CoordMode, Mouse, Window  
CoordMode, ToolTip, Window 


tLimite := 0
if(FileExist("settings.ini")){
	tLimite := cargarSetting("global", "secondsToRestart", default:=0)
}

if(tLimite = 0){
	tLimite := 390 
	registrarSetting("global", "secondsToRestart", 390)
}

mainWin := 0, holesContainerX := 0, holesContainerY := 0
WinGet, mainWin, ID, ahk_class UnityWndClass
if(!mainWin){
	MsgBox, Start the game first
	ExitApp
}

GetClientSize(mainWin, clientWidth, clientHeigth)
cX := Round(clientWidth * 0.159375)
cY := Round(clientHeigth * 0.1840) 
ClientToScreen(holesContainerX, holesContainerY, cX, cY, mainWin)
ScreenToWindow(holesContainerX, holesContainerY, holesContainerX,  holesContainerY, mainWin)

holeWidth := Round(clientWidth * 0.071), holeHeight := Round(clientHeigth * 0.201822), marginRigth := Round(clientWidth * 0.0021961932650073), holeMarginBotton := Round(clientHeigth * 0.01171875) 

sx := clientWidth * 0.2864583333333333
sy := clientHeigth * 0.9259259259259259
ClientToScreen(sx, sy, sx, sy, mainWin)
ScreenToWindow(sx, sy, sx,  sy, mainWin)
startButton := crearRegion( sx, sy, sx + 80, sy + 30)


hole := []
x1 := holesContainerX
y1 := holesContainerY
n := 1
loop, 3 {
	
	Loop, 5 {
		
		hole[n] := crearRegion(x1, y1, (x1 + holeWidth), ((y1 - 1) + holeHeight))
		x1 := hole[n].x2 + marginRigth
		n++
	}

	y1 := y1 - 1 + holeHeight + holeMarginBotton
	x1 := holesContainerX
}


side := Round( holeWidth * 0.134020)
top := Round( holeHeight * 0.458064)
bottom := Round( holeHeight * 0.116129)
potatoPixel := []
innerHole := []
loop, % hole.Count(){

	region := hole[A_Index]
	pX := (region.x1 +region.x2)//2
	pY := (region.y1 + region.y2)//2
	potatoPixel.push(new _Pixel(pX, pY))

	x1 := region.x1 + side, x2 := region.x2 - side, y1 := region.y1 + top, y2 := region.y2 - bottom
	innerHole.push(crearRegion(x1, y1, x2, y2))

}


regiones := []
regiones.push(startButton)
regiones.push(hole*)
regiones.push(innerHole*)

idGrafico := []

MsgBox, Instructions`n`nCtrl + f11 Toggle On/Off script`nCtrl + f12 Shows/Hides overlay`nCtrl + f10 Reload`n`nYou can change the time to restart the whack minigame using the file settings.ini. Change the key secondsToRestart to the desire time in secods.`n`nThe game should be in 960x540, 1280x720, 1600x900 or 1920x1080. It can work in other sizes if these maintain the aspect ratio.`n`nThe script performs a perfect run almost 90`% of the time. It is programmed to fail between 1 - 3 times in a random run. This maintain reliability.

Hotkey, ^f12, showLayout
Hotkey, ^f11, toggleScript
Hotkey, ^f10, restart
Pause, On
return

restart:
	showNotificationMsg("Reloading..")
	Sleep, 500
	Reload
return

toggleScript:
	if(toggleScript:=!toggleScript){
		Pause, Toggle, 1
		setTimer, script, 10
		showNotificationMsg("Script On")
		return
	}
	Pause, Toggle, 1
	showNotificationMsg("Script Paused")
	Sleep, 2000
	Tooltip
return

showLayout:

	if (toggleLayout:=!toggleLayout){
		
		winActiva := WinExist("A")
		idGrafico := crearColeccionGraficos(regiones.Count())
		dibujarColeccionRectangulos(idGrafico, regiones, winActiva)

	}else{

		destruirColeccionGraficos(idGrafico)
		idGrafico := []
	}

return


script(){

	redo()

	potato := findPotato()
	if(potato = 0){
		;showNotificationMsg("Waiting Potato")
		return
	}

	whackPotato(potato, 10, 10)
	awaitPotatoDissapears(potato)

}


;#################### Script func

findPotato(){

	Global potatoPixel, innerHole

	static colorNormal := 0x4A96D1
	static colorYellish := 0x13BDFB
	static x1 := 0, x2 := 0, y1 := 0, y2 := 0
	;normal 0x4A96D1 
	;yellish 0x13BDFB, 0x16BFFD

	if(!x1){

		x1 := innerHole[1].x1
		x2 := innerHole[innerHole.MaxIndex()].x2
		y1 := innerHole[1].y1
		y2 := innerHole[innerHole.MaxIndex()].y2

	}

	PixelSearch, fx, fy, x1, y1, x2, y2, colorNormal, 0, fast
	if(fx){
		return pointToHole(fx, fy)
	}

	PixelSearch, fx, fy, x1, y1, x2, y2, colorYellish, 0, fast
	if(fx){
		return pointToHole(fx, fy)
	}

	return false

}


pointToHole(x, y){

	Global innerHole
	
	loop, % innerHole.MaxIndex() {

		if (x < innerHole[A_Index].x2 and y < innerHole[A_Index].y2){
			return innerHole[A_Index]
		}

	}

	return false
}


whackPotato(region, insetX:=0, insetY:=0){

    Random, rx, region.x1 +insetX, region.x2 -insetX
    Random, ry, region.y1 +insetY, region.y2 -insetY

    SetDefaultMouseSpeed, randomValue(2, 3)
    MouseMove, rx, ry
    randomSleep(20, 40) 

    SetMouseDelay, randomValue(40, 60)
    Click
    
    SetMouseDelay, 10
    
}

awaitPotatoDissapears(potato){

	static colorNormal := 0x4A96D1
	static colorYellish := 0x16BFFD
	
	endTime := A_TickCount + 600
	While (A_TickCount < endTime){

		PixelSearch, nx, ny, potato.x1, potato.y1, potato.x2, potato.y2, colorNormal, 0, fast
		PixelSearch, yx, yy, potato.x1, potato.y1, potato.x2, potato.y2, colorYellish, 0, fast
		if(!nx and !yx){
			break 
		}
	}

	randomSleep(20, 30)

}


redo(){

	Global tLimite, startButton
	static tInicial := 0
	
	if(tInicial = 0){
		clicRegion(startButton)
		tInicial := A_TickCount
		Sleep, 2000
	}


	tTranscurrido  := (A_TickCount - tInicial)
	if (tTranscurrido  >= (tLimite *1000)){
		clicRegion(startButton)
		tInicial := A_TickCount
		Sleep, 2000
	}

}


;#################### libreria func

class _Pixel {
	
	__New(x:=0, y:=0, color:=0xffffff){
		this.x := x
		this.y := y
		this.color := color
	}

	Is(color, variation){

		
		PixelSearch, fx, fy, this.x, this.y, this.x, this.y, color, variation, Fast

		if(ErrorLevel){
			return false
		}
		
		return true

	}


	Changed(){

		PixelGetColor, currentColor, this.x, this.y
		if(currentColor != this.color){
			return true
		}

		return false
	}

}



crearRegion(x1, y1, x2, y2){

	if (x1<0 or y1<0 or x2<0 or y2<0){
		return 0
	}

	if(x2 < x1){
		temp := x1
		x1 := x2
		x2 := temp
	}

	if(y2 < y1){
		temp := y1
		y1 := y2
		y2 := temp
	}

	return {"x1":x1, "y1":y1, "x2":x2, "y2":y2}

}


crearGrafico(cc:="0x3CFF3C") {

	Gui, New, +HwndGrafico  +AlwaysOnTop -Caption +E0x00000020 +E0x08000000
	Gui, Color, %cc%
	return Grafico

}

crearColeccionGraficos(cantidad){

	ids := []
	loop, %cantidad%
		ids[A_Index] := crearGrafico()
	
	return ids
}

ocultarGrafico(hwndGrafico){

	if (!hwndGrafico)
		return

	Gui, %hwndGrafico%:Hide

}

ocultarColeccionGraficos(ids){

	loop, % ids.Count()
		ocultarGrafico(ids[A_Index]) 
			
}

mostrarGrafico(hwndGrafico){

	if (!hwndGrafico)
		return

	Gui, %hwndGrafico%:Show, NA
}

mostrarColeccionGraficos(ids){
	
	loop, % ids.Count()
		mostrarGrafico(ids[A_Index]) 
	
}


dibujarRectangulo(winHwnd:=0, punto:=0, hwndGrafico:=0, x1:=0, y1:=0, x2:=0, y2:=0, borde:=2){
    
    if (!hwndGrafico or x1<0 or y1<0 or x2<0 or y2<0){
        return 1
    }

    addX := 0, addY := 0 
    if (winHwnd != 0){
        
        win := WinExist("ahk_id " winHwnd)
        if !win
            return 2
        
        WinGetPos, wx, wy, , , ahk_id %win%
      	addX := wx
       	addY := wy
    }

    if(punto != 0){
        addX += punto.x
        addY += punto.y
    }

    x1+=addX
    y1+=addY
    x2+=addX
    y2+=addY

    w := x2 - x1
    h := y2 - y1
    w2:= w - borde
    h2:= h - borde
  
    Gui, %hwndGrafico%: Show, w%w% h%h% x%x1% y%y1% NA
    WinSet, Transparent, 255
    WinSet, Region, 0-0 %w%-0 %w%-%h% 0-%h% 0-0 %borde%-%borde% %w2%-%borde% %w2%-%h2% %borde%-%h2% %borde%-%borde%, ahk_id %hwndGrafico%

    return 0
}

dibujarColeccionRectangulos(idGraficos, regiones, winHwnd:=0, punto:=0){

	loop, % idGraficos.Count(){
		dibujarRectangulo(winHwnd, punto, idGraficos[A_Index], regiones[A_Index].x1, regiones[A_Index].y1, regiones[A_Index].x2, regiones[A_Index].y2)
	}
	
}

destruirGrafico(hwndGrafico){
	
	if (!hwndGrafico)
		return

	Gui, %hwndGrafico%:Destroy
}

destruirColeccionGraficos(ids){
	
	loop, % ids.Count()
		destruirGrafico(ids[A_Index]) 
	
}

distribucionAlObjetivo(ini, objetivo, fin){
  
    Random, izq, ini, objetivo
    Random, der, objetivo, fin
    Random, cerca, izq, der
    Return cerca

}

showNotificationMsg(msg:=""){
    
    Tooltip, % msg , , , 1
    setTimer, quitarTooltip, -2000
    return

    quitarTooltip:
        Tooltip, , , , 1
    return

}

randomSleep(min, max){
    Sleep,  distribucionAlObjetivo(min, ((min+max)//2), max)
}

randomValue(min, max){
	Random, v, min, max
    return v
}

clicRegion(region, insetX:=0, insetY:=0){

    mex := (region.x1 + region.x2)//2
    rax := distribucionAlObjetivo((region.x1+insetX), mex, (region.x2-insetX))

    mey := (region.y1 + region.y2)//2
    ray := distribucionAlObjetivo((region.y1+insetY), mey, (region.y2-insetY))

    SetDefaultMouseSpeed, randomValue(2, 6)
    MouseMove, rax, ray
    randomSleep(80, 120) 

    SetMouseDelay, randomValue(60, 110)
    Click
    SetMouseDelay, 10

}

registrarSetting(seccion, key, valor){

    IniWrite, %valor%, settings.ini, %seccion%, %key%

}

cargarSetting(seccion, key, default:=0){   
    
    IniRead, OutputVar, settings.ini, %seccion%, %key% , %default%
    return OutputVar
}

GetClientSize(hWnd, ByRef w := "", ByRef h := ""){

	VarSetCapacity(rect, 16)
	DllCall("GetClientRect", "ptr", hWnd, "ptr", &rect)
	w := NumGet(rect, 8, "int")
	h := NumGet(rect, 12, "int")
}

ClientToScreen(ByRef x, ByRef y, x1, y1, hWnd:=""){
 
  if (!hWnd)
    WinGet, hWnd, ID, A
  VarSetCapacity(pt, 8, 0), NumPut(0, pt, "int64")
  DllCall("ClientToScreen", "Ptr", hWnd, "Ptr", &pt)
  x := x1 + NumGet(pt, "int"), y := y1 + NumGet(pt, 4, "int")

}

ScreenToWindow(ByRef x, ByRef y, x1, y1, id:=""){
  local
  WindowToScreen(dx,dy,0,0,id), x:=x1-dx, y:=y1-dy
}

WindowToScreen(ByRef x, ByRef y, x1, y1, id:=""){
  local
  WinGetPos, winx, winy,,, % id ? "ahk_id " id : "A"
  x:=x1+Floor(winx), y:=y1+Floor(winy)
}