import pymem
import time
import win32com.client as comclt
import win32api as wapi
from getkeys import key_check

wsh = comclt.Dispatch("WScript.Shell")

pid = 0x2a48
address = 0x0BF2EA18

kibekapcsologomb = 145
aoekapcsologomb = 118
# 145       - Scroll lock
# 112-123   - F1-F12

billentyuLetiltas = 0.25

osszestulajdonsag = 25

osszestulajdonsag = osszestulajdonsag - 1

tulajdonsagnevek = ["WWCD", "BtCD", "BloodrageCD", "BRCD", "DWCD", "ReCD",
                    "SBuff", "empty", "R70", "R80", "BSUP", "Combat", "target",
                    "range", "SA5", "SA3sec", "R12", "R15", "R20", "R25",
                    "R37", "210K+", "WWCDWAIT", "ReUP", "DWUP"]

tulajdonsagertekek = []

wow = pymem.open_process(pid)

MULTI = False
SINGLE = True
lasttime = 0

def onoffswitch():
    global lasttime
    if wapi.GetAsyncKeyState(kibekapcsologomb) & (time.time() - lasttime > billentyuLetiltas):
        lasttime = time.time()
        wsh.AppActivate("World of Warcraft")
        wsh.SendKeys("{F6}")
        print("Szüneteltetve: Nyomd meg a \"Scroll lock\"-ot a folytatáshoz")
        time.sleep(billentyuLetiltas)
        pause = True
        while pause:
            aoeswitchListener()
            if wapi.GetAsyncKeyState(kibekapcsologomb):
                pause = False
                print("Folytatás...")
                wsh.AppActivate("World of Warcraft")
                wsh.SendKeys("{F5}")
                lasttime = time.time()

def aoeswitchListener():
    global lasttime
    global SINGLE
    global MULTI
    if wapi.GetAsyncKeyState(aoekapcsologomb) & (time.time() - lasttime > billentyuLetiltas):
        lasttime = time.time()
        if SINGLE == True:
            SINGLE = False
            MULTI = True
            print("SWITCHED TO MULTI MODE!!!")
        else:
            SINGLE = True
            MULTI = False
            print("SWITCHED TO SINGLE MODE!!!!")
    return

def Holvan(szoveg):
    for i in range(0,osszestulajdonsag+1):
        if tulajdonsagnevek[osszestulajdonsag - i] == szoveg:
            return i
    return -1

def H(szoveg):
    if tulajdonsagertekek[Holvan(szoveg)]:
        return True
    else:
        return False
    

print("Scroll lock - Stop")
print("F7 - AOE mód be / kikapcsolás")
print("Nyomd meg a \"Scroll lock\"-ot a starthoz")
pause = True
while pause:
    aoeswitchListener()
    if wapi.GetAsyncKeyState(kibekapcsologomb):
        pause = False
        print("Start...")
        wsh.AppActivate("World of Warcraft")
        wsh.SendKeys("{F5}")
        lasttime = time.time()

while 1:
    szam = int(pymem.read_double(wow, address))

    tulajdonsagertekek = []

    for i in range(0,osszestulajdonsag+1):
        if szam >= pow(2,(osszestulajdonsag-i)) & pow(2,(osszestulajdonsag-i)) != 128:
            szam = szam - pow(2,(osszestulajdonsag-i))
            tulajdonsagertekek.append(True)
        else:
            tulajdonsagertekek.append(False)
        

    ajanlat = '-'
    ajanlat2 = '-'

    # Out of range but in combat
    if H("Combat") & H("target") & (H("range") == False):
        if H("BRCD") & (H("R80") == False):                 ajanlat = 'r'
        if (H("BSUP") == False) & H("R12"):                 ajanlat = "{F4}"
        if (H("R80") == False) & H("BloodrageCD"):          ajanlat2 = 't'

    # SINGLE
    if H("Combat") & H("target") & H("range") & SINGLE:
        if (H("WWCD") == False) & (H("SBuff") == False) & (H("BtCD") == False):  ajanlat = 'U'
        if (H("SA5") | H("SA3sec")) & H("210K+"):           ajanlat = '0'
        if H("BRCD") & (H("R80") == False) & (H("R25")):    ajanlat = 'r'
        if H("R37") & (H("ReUP") == False):                 ajanlat2 = '1'
        if H("BtCD") & H("R20"):                            ajanlat = 'q'
        if H("WWCD") & H("R25"):                            ajanlat = '2'
        if H("SBuff") & H("R15"):                           ajanlat = 'e'
        if H("SA3sec") & H("R15"):                          ajanlat = '0'
        if H("R10") & H("ReCD") & H("BSUP") & H("DWUP") & (H("SA5") == False):   ajanlat = 'f'
        if H("R10") & H("DWCD") & H("BSUP") & (H("SA5") == False):   ajanlat = 'c'
        if (H("R37") == False):                             ajanlat2 = '9'
        if (H("BSUP") == False) & H("R12"):                 ajanlat = "{F4}"
        if (H("R80") == False) & H("BloodrageCD"):          ajanlat2 = 't'
        if H("ReUP") & (ajanlat2 != 't'):                   ajanlat2 = '9'

    # AOE - MULTI
    if H("Combat") & H("target") & H("range") & MULTI:
        if H("BRCD") & (H("R80") == False):                 ajanlat = 'r'
        if H("BtCD") & H("R20"):                            ajanlat = 'q'
        if H("SBuff") & H("R25"):                           ajanlat = 'e'
        if (H("BSUP") == False) & H("R12"):                 ajanlat = "{F4}"
        if H("SA3sec"):                                     ajanlat = '0'
        if H("WWCD") & H("R25"):                            ajanlat = '2'
        if H("R20"):                                        ajanlat2 = 'z'
        if H("210K+") & H("R10") & H("ReCD"):               ajanlat = 'f'
        if H("210K+") & H("R10") & H("DWCD"):               ajanlat = 'c'
        if (H("R80") == False) & H("BloodrageCD"):          ajanlat2 = 't'

    aoeswitchListener()
    onoffswitch()
    
    wsh.AppActivate("World of Warcraft") # select another application
    if ajanlat != '-':
        wsh.SendKeys(ajanlat) # send the keys you want
    if ajanlat2 != '-':
        wsh.SendKeys(ajanlat2)
    wsh.SendKeys("{F3}") # request new information about WoW through the addon
    time.sleep(0.004)
    #240 fps






























    
