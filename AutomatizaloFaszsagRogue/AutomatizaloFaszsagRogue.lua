print("Elindult az AutomatizaloFaszsagRogue addon!")

spellek = {"Sinister Strike", "Blade Flurry"}
spellidk = {1752, 13877}
spellekszama = 2
--legelso spell lesz hasznalva range check-re

buffok = { "Slice and Dice" }
buffokszama = 1

naez = 69696969

meret = 1

function meretszamitas()
    raidmeret = GetNumRaidMembers()
    groupmeret = GetNumPartyMembers() + 1
    if raidmeret > groupmeret then
        meret = raidmeret
    else
        meret = groupmeret
    end
end


function teszt ()
    naez = 0

    --egyéb RÉSZ
    if UnitAffectingCombat("player") == 1 then
        naez = naez + 1
    end
    
    if UnitExists("target") and UnitCanAttack("player", "target") == 1 and not(UnitIsDead("target")==1) then
        naez = naez + 2
    end
    
    if IsSpellInRange(spellek[1], "target") == 1 then
        naez = naez + 4
    end
    
    if (UnitHealth("target")/meret) > 160000 then
        naez = naez + 8
    end

    if GetComboPoints("player","target") >= 3 then
        naez = naez + 16
    end

    if GetComboPoints("player","target") == 5 then
        naez = naez + 32
    end



    --CD RÉSZ
    for i = 1,spellekszama,1 
    do
        start, duration, inactive = GetSpellCooldown( spellidk[i] );
        if start > 0 and duration > 0 then

        else
            naez = naez + 2^(i-1+6)
        end
    end


    --BUFF RÉSZ
    for i=1,40 do 
        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player",i); 
        for j = 1,buffokszama,1
        do
            if name == buffok[j] then
                naez = naez + 2^(j-1+6+spellekszama)
            end
        end
    end



    --ENEMY DEBUFF RÉSZ
    --vanotstack = 0
    --for i=1,40 do 
    --    name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("target",i); 
    --    if name == "Sunder Armor" and count == 5 then 
    --        if expirationTime - GetTime() < 4.5 then
    --            naez = naez + 32768
    --        end
    --        vanotstack = 1
    --    end
    --end
    --if vanotstack == 0 then
    --    naez = naez + 16384
    --end
end