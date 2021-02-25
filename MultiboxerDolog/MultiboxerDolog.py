import pymem
import time
import win32com.client as comclt
import win32api as wapi
import os
from ahk import AHK
from ahk.window import Window
from getkeys import key_check

from ahk.directives import NoTrayIcon
from ahk.directives import NoEnv

print("starting...")

ahk = AHK(directives=[NoTrayIcon, NoEnv]) 

wsh = comclt.Dispatch("WScript.Shell")

#priest
pid4        = 0x7bc
address4    = 0x25615A18

#hunter
pid1        = 0x3be0
address1    = 0x23224A18

#mage
pid2        = 0xec8
address2    = 0x2198DA18

#rogue
pid3        = 0x1ec0
address3    = 0x22E8EA18




kibekapcsologomb = 145
aoekapcsologomb = 118
# 145       - Scroll lock
# 112-123   - F1-F12

billentyuLetiltas = 0.25

osszestulajdonsagMage = 15
osszestulajdonsagPriest = 20
osszestulajdonsagRogue = 8
osszestulajdonsagHunter = 16
#a tenylegestol 1-el kisebbnek kell lennie :D

tulajdonsagnevekHunter = ["combat", 
                          "attackable",
                          "range",
                          "burst",
                          "arcaneshotcd",
                          "aimedshotcd",
                          "chimerashotcd",
                          "rapidfirecd",
                          "drink",
                          "trueshotauraup",
                          "aspectoftheviperup",
                          "aspectofthehawkup",
                          "oom",
                          "90mana",
                          "serpentstingup",
                          "huntersmarkup",
                          "petsummoned"]

tulajdonsagnevekMage = ["combat", "attackable", "range", "burst",
                        "fireballcd", "fireblastcd", "combustioncd",
                        "frostarmor", "arcaneintellect", "drink", "hotstreakup",
                        "oom", "90mana",
                        "fireballup", "livingbombup", "improvedscorchup"]
tulajdonsagnevekRogue = ["combat", "attackable", "range", "burst", "3combo", "5combo", "sinistercd", "bladeflurrycd", "sliceanddiceup"]

tulajdonsagnevekPriest = ["combat", "attackable", "range", "burst",
                          "p1", "p2", "p3", "p4", "self",
                          "drink", "divinespirit",
                          "oom", "90mana", "tankincombat", "amicasting",
                          "p1magic", "p2magic", "p3magic", "p4magic", "selfmagic", "serendipity3"]


tulajdonsagertekekHunter = []
tulajdonsagertekekMage = []
tulajdonsagertekekRogue = []
tulajdonsagertekekPriest = []


wowHunter = pymem.open_process(pid1)
wowMage = pymem.open_process(pid2)
wowRogue = pymem.open_process(pid3)
wowPriest = pymem.open_process(pid4)

winRogue = ahk.find_window(title=b'Rogue')
winHunter = ahk.find_window(title=b'Hunti')
winPriest = ahk.find_window(title=b'Priest')
winMage = ahk.find_window(title=b'Mage')


lasttime = 0

def HolvanHunter(szoveg):
    for i in range(0,osszestulajdonsagHunter+1):
        if tulajdonsagnevekHunter[osszestulajdonsagHunter - i] == szoveg:
            return i
    return -1

def HolvanPriest(szoveg):
    for i in range(0,osszestulajdonsagPriest+1):
        if tulajdonsagnevekPriest[osszestulajdonsagPriest - i] == szoveg:
            return i
    return -1

def HolvanMage(szoveg):
    for i in range(0,osszestulajdonsagMage+1):
        if tulajdonsagnevekMage[osszestulajdonsagMage - i] == szoveg:
            return i
    return -1

def HolvanRogue(szoveg):
    for i in range(0,osszestulajdonsagRogue+1):
        if tulajdonsagnevekRogue[osszestulajdonsagRogue - i] == szoveg:
            return i
    return -1





def HHunter(szoveg):
    if tulajdonsagertekekHunter[HolvanHunter(szoveg)]:
        return True
    else:
        return False

def HMage(szoveg):
    if tulajdonsagertekekMage[HolvanMage(szoveg)]:
        return True
    else:
        return False

def HPriest(szoveg):
    if tulajdonsagertekekPriest[HolvanPriest(szoveg)]:
        return True
    else:
        return False

def HRogue(szoveg):
    if tulajdonsagertekekRogue[HolvanRogue(szoveg)]:
        return True
    else:
        return False




os.startfile("All\Feedinfo.exe")

print("megy")

prangeMage = False
prangePriest = False
prangeHunter = False
prieststop = False
mageDrinking = False
priestDrinking = False
hunterDrinking = False
pdrinkMage = False
priestStoppedForCombat = False

currentTimeIndex = 0
times = []

for i in range(0,10):
    times.append(0.016)

while 1:
    valami = False
    starttime = time.time()
    
    szam = int(pymem.read_double(wowHunter, address1))
    tulajdonsagertekekHunter = []

    for i in range(0,osszestulajdonsagHunter+1):
        if szam >= pow(2,(osszestulajdonsagHunter-i)):
            szam = szam - pow(2,(osszestulajdonsagHunter-i))
            tulajdonsagertekekHunter.append(True)
        else:
            tulajdonsagertekekHunter.append(False)

    szam = int(pymem.read_double(wowRogue, address3))
    tulajdonsagertekekRogue = []

    for i in range(0,osszestulajdonsagRogue+1):
        if szam >= pow(2,(osszestulajdonsagRogue-i)):
            szam = szam - pow(2,(osszestulajdonsagRogue-i))
            tulajdonsagertekekRogue.append(True)
        else:
            tulajdonsagertekekRogue.append(False)

    szam = int(pymem.read_double(wowMage, address2))
    tulajdonsagertekekMage = []

    for i in range(0,osszestulajdonsagMage+1):
        if szam >= pow(2,(osszestulajdonsagMage-i)):
            szam = szam - pow(2,(osszestulajdonsagMage-i))
            tulajdonsagertekekMage.append(True)
        else:
            tulajdonsagertekekMage.append(False)
    
    szam = int(pymem.read_double(wowPriest, address4))
    tulajdonsagertekekPriest = []

    for i in range(0,osszestulajdonsagPriest+1):
        if szam >= pow(2,(osszestulajdonsagPriest-i)):
            szam = szam - pow(2,(osszestulajdonsagPriest-i))
            tulajdonsagertekekPriest.append(True)
        else:
            tulajdonsagertekekPriest.append(False)



    
    #HUNTER
    #
    #
    if HHunter("petsummoned")==False:
        winHunter.send("-")
    if HHunter("attackable"):
        hunterDrinking = False
        if HHunter("range"):
            dolog = ''
            if prangeHunter == False:
                winHunter.send('wwwwwww')

            if HHunter("serpentstingup")==False:
                dolog = 'e'
            if HHunter("arcaneshotcd"):
                dolog = '1'
            if HHunter("aimedshotcd"):
                dolog = '3'
            if HHunter("chimerashotcd"):
                dolog = 'p'
            if HHunter("rapidfirecd"):
                dolog = '0'
            if HHunter("huntersmarkup")==False:
                winHunter.send('2')
            if HHunter("oom") & HHunter("aspectofthehawkup"):
                dolog = 'r'
            if HHunter("90mana") & HHunter("aspectoftheviperup"):
                dolog = 't'
            
            if dolog!='':
                winHunter.send(dolog)
                
        else:
            winHunter.send('.')
    else:
        if HHunter("combat") == False:
            if (  (HHunter("oom")) & (hunterDrinking==False)  ):
                winHunter.send("wwwwwwwwww")
                hunterDrinking = True
            if (  HHunter("90mana")  ):
                hunterDrinking = False

            if hunterDrinking & (HHunter("drink")==False):
                winHunter.send("v")
            

        if hunterDrinking == False:
            winHunter.send('{F2}')
            if HHunter("trueshotauraup") == False:
                winHunter.send("c")
            if (HHunter("aspectofthehawkup")==False) & HHunter("90mana"):
                winHunter.send("t")
                


    #Rogue
    #
    #
    if HRogue("attackable"):
        if HRogue("range"):
            dolog = '1'
            if (HRogue("3combo")):
                if (HRogue("sliceanddiceup")==False):
                    dolog = 't'
                else:
                    dolog = '3'
            if HRogue("bladeflurrycd"):
                dolog = 'r'
            dolog = dolog + '.'
            winRogue.send(dolog)
                
        winRogue.send('.')
    else:
        winRogue.send('{F2}')



    #Mage
    #
    #
    if HMage("attackable"):
        if HMage("range"):
            if prangeMage == False:
                winMage.send('wwwwwww')
            else:
                dolog = 'e'
                if HMage("fireblastcd"):
                    dolog = '2'
                if HMage("fireballup") == False:
                    dolog = '1'
                if HMage("hotstreakup"):
                    dolog = '3'
                if HMage("livingbombup") == False:
                    dolog = 'r'
                if HMage("combustioncd"):
                    dolog = 't'
                winMage.send(dolog)
                
        else:
            winMage.send('.')
    else:
        if HMage("combat") == False:
            if (  (HMage("oom")) & (mageDrinking==False)  ):
                winMage.send("wwwwwwwwww")
                mageDrinking = True
            if (  HMage("90mana")  ):
                mageDrinking = False

            if mageDrinking & (HMage("drink")==False):
                winMage.send("v")
            

        if mageDrinking == False:
            if HMage("arcaneintellect")==False:
                winMage.send("c")
            if HMage("frostarmor")==False:
                winMage.send("0")
            winMage.send('{F2}')


    #PRIEST
    #
    #
    
    if (HPriest("tankincombat")) & (priestStoppedForCombat == False):
        winPriest.send("wwwwwwww")
        priestStoppedForCombat = True
    
    dolog = ''
    if HPriest("p1") or HPriest("p2") or HPriest("p3") or HPriest("p4") or HPriest("self"):
        if prieststop:
            targetno = 0
            if HPriest("p4"):
                dolog = '{Numpad4}{Numpad4}{Numpad4}{Numpad4}{Numpad4}{Numpad4}{Numpad4}'
                targetno = 4
            if HPriest("p3"):
                dolog = '{Numpad3}{Numpad3}{Numpad3}{Numpad3}{Numpad3}{Numpad3}{Numpad3}'
                targetno = 3
            if HPriest("p2"):
                dolog = '{Numpad2}{Numpad2}{Numpad2}{Numpad2}{Numpad2}{Numpad2}{Numpad2}'
                targetno = 2
            if HPriest("self"):
                dolog = '{Numpad5}{Numpad5}{Numpad5}{Numpad5}{Numpad5}{Numpad5}{Numpad5}'
                targetno = 5
            if HPriest("p1"):
                dolog = '{Numpad1}{Numpad1}{Numpad1}{Numpad1}{Numpad1}{Numpad1}{Numpad1}'
                targetno = 1
                
            if HPriest("p1magic"):
                dolog = '{Numpad1}t'
                print("p1 magic")
            if HPriest("selfmagic"):    dolog = '{Numpad5}t'
            if HPriest("p2magic"):      dolog = '{Numpad2}t'
            if HPriest("p3magic"):      dolog = '{Numpad3}t'
            if HPriest("p4magic"):      dolog = '{Numpad4}t'        

            if HPriest("serendipity3") & (HPriest("p1") or HPriest("p2") or HPriest("p3") or HPriest("p4") or HPriest("self")):
                dolog = dolog + '3332'
            else:
                dolog = dolog + '1'

            dolog2 = ''

            if HPriest("amicasting")==False:
                dolog = dolog + dolog2
                winPriest.send(dolog)
        else:
            winPriest.send('wwwwwwww')
            prieststop = True

        
    else:
        prieststop = False
        if HPriest("tankincombat") == False:
            priestStoppedForCombat = False
            winPriest.send('{F2}')
            if priestDrinking == False:
                if HPriest("divinespirit")==False:
                    winPriest.send('-')
            if (  (HPriest("oom")) & (priestDrinking==False)  ):
                winPriest.send("wwwwwwwwww")
                priestDrinking = True
            if (  HPriest("90mana")  ):
                priestDrinking = False

            if priestDrinking & (HPriest("drink")==False):
                winPriest.send("v")
        else:
            winPriest.send('9')
            

        
    
    prangeMage = HMage("range")
    prangePriest = HPriest("range")
    prangeHunter = HHunter("range")
    pdrinkMage = HMage("drink")

    timetook = time.time()-starttime

    tickuzenet = False

    times[currentTimeIndex] = timetook

    if currentTimeIndex == 9:
        average = 0.0
        for i in range(0,9):
            average = average + times[i]
        average = average / 10
        if tickuzenet:
            print("tick: {}".format(timetook))
        currentTimeIndex = 0
    else:
        currentTimeIndex = currentTimeIndex + 1

    debug = False

    if debug:
        for i in range(0,osszestulajdonsagHunter+1):
            print( tulajdonsagnevekHunter[i], tulajdonsagertekekHunter[i] )
        time.sleep(1.0)
        print("\n\n\n")
    else:
        if timetook < 0.032:
            time.sleep(0.064 - timetook)






























    
