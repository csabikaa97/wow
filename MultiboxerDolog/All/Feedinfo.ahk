SetTitleMatchMode, 2
#SingleInstance Force
loop
{
	Controlsend,, {F1}, Hunti
	Controlsend,, {F1}, Rogue
	Controlsend,, {F1}, Priest
	Controlsend,, {F1}, Mage

	Controlsend,, {F3}, Hunti
	Controlsend,, {F3}, Rogue
	Controlsend,, {F3}, Priest
	Controlsend,, {F3}, Mage

	Sleep, 8
}

Return

F5:: ExitApp

