print("Elindult az AutomatizaloFaszsagPriest addon!")

spellek = { "Lesser Heal" }
spellidk = { 2050 }
spellekszama = 0
--legelso spell lesz hasznalva range check-re

buffok = { "Drink", "Divine Spirit" }
buffokszama = 2

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
    
    if IsSpellInRange(spellek[1], "party1") == 1 then
        naez = naez + 4
    end
    
    if (UnitHealth("target")/meret) > 160000 then
        naez = naez + 8
    end

    if (UnitHealth("party1") / UnitHealthMax("party1")) < 0.75 then
        if not(UnitIsDead("party1")) then
            naez = naez + 16
        end
    end

    if (UnitHealth("party2") / UnitHealthMax("party2")) < 0.6 then
        if not(UnitIsDead("party2")) then
            naez = naez + 32
        end
    end

    if (UnitHealth("party3") / UnitHealthMax("party3")) < 0.6 then
        if not(UnitIsDead("party3")) then
            naez = naez + 65
        end
    end

    if (UnitHealth("party4") / UnitHealthMax("party4")) < 0.6 then
        if not(UnitIsDead("party4")) then
            naez = naez + 128
        end
    end

    if (UnitHealth("player") / UnitHealthMax("player")) < 0.6 then
        if not(UnitIsDead("player")) then
            naez = naez + 256
        end
    end

    


    --CD RÉSZ
    for i = 1,spellekszama,1 
    do
        start, duration, inactive = GetSpellCooldown( spellidk[i] );
        if start > 0 and duration > 0 then

        else
            naez = naez + 2^(i-1+9)
        end
    end


    --BUFF RÉSZ
    for i=1,40 do 
        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player",i); 
        for j = 1,buffokszama,1
        do
            if name == buffok[j] then
                naez = naez + 2^(9+spellekszama+j-1)
            end
        end
    end


    if (UnitPower("player") / UnitPowerMax("player")) < 0.6 then
        naez = naez + 2^(9+spellekszama+buffokszama)
    end

    if (UnitPower("player") / UnitPowerMax("player")) > 0.9 then
        naez = naez + 2^(9+spellekszama+buffokszama+1)
    end

    if UnitAffectingCombat("party1") then
        naez = naez + 2^(9+spellekszama+buffokszama+2)
    end

    spell, rank, displayName, icon, startTime, endTime, isTradeSkill, castID, interrupt = UnitCastingInfo("player")
    if not(endTime == nil) then
        naez = naez + 2^(9+spellekszama+buffokszama+3)
    end
    

    --PARTY DEBUFF RÉSZ
    for j=1,5 do
        for i=1,40 do
            name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("target",i);
            if j == 1 then name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("party1",i); end
            if j == 2 then name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("party2",i); end
            if j == 3 then name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("party3",i); end
            if j == 4 then name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("party4",i); end
            if j == 5 then name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("player",i); end
            if debuffType == "Magic" then
                naez = naez + 2^(9+spellekszama+buffokszama+3+j)
            end
        end
    end

    for i=1,40 do 
        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player",i); 
        if name == "Serendipity" and count == 3 then
            naez = naez + 2^(9+spellekszama+buffokszama+3+5+1)
            print(count, "stack")
        end
    end
end