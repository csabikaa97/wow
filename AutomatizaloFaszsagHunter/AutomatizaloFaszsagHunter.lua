print("Elindult az AutomatizaloFaszsagHunter addon!")

spellek = {"Arcane Shot", "Aimed Shot", "Chimera Shot", "Rapid Fire"}
spellidk = {3044, 19434, 53209, 3045}
spellekszama = 4
--legelso spell lesz hasznalva range check-re

buffok = { "Drink", "Trueshot Aura", "Aspect of the Viper", "Aspect of the Hawk" }
buffokszama = 4

debuffok = { "Serpent Sting", "Hunter's Mark" }
debuffokszama = 2

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
    
    if UnitExists("target") and UnitCanAttack("player", "target") == 1 and not(UnitIsDead("target")==1)  then
        naez = naez + 2
    end
    
    if IsSpellInRange(spellek[1], "target") == 1 then
        naez = naez + 4
    end
    
    if (UnitHealth("target")/meret) > 160000 then
        naez = naez + 8
    end

    --az elso helyre megy az osszes CD
    --




    --CD RÉSZ
    for i = 1,spellekszama,1 
    do
        start, duration, inactive = GetSpellCooldown( spellidk[i] );
        if start > 0 and duration > 0 then

        else
            naez = naez + 2^(i-1+4)
        end
    end


    --BUFF RÉSZ
    for i=1,40 do 
        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player",i); 
        for j = 1,buffokszama,1
        do
            if name == buffok[j] then
                naez = naez + 2^(j-1+4+spellekszama)
            end
        end
    end


    --mana
    if (UnitPower("player") / UnitPowerMax("player")) < 0.3 then
        naez = naez + 2^(4+spellekszama+buffokszama)
    end

    if (UnitPower("player") / UnitPowerMax("player")) > 0.9 then
        naez = naez + 2^(4+spellekszama+buffokszama+1)
    end



    --ENEMY DEBUFF RÉSZ
    vanotstack = 0
    for j=1,debuffokszama do
        for i=1,40 do 
            name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("target",i); 
            if name == debuffok[j] then
                naez = naez + 2^(4+spellekszama+buffokszama+2+j-1)
                --if expirationTime - GetTime() < 4.5 then
                --    naez = naez + 
                --end
            end
        end
    end

    if UnitExists("pet") then
        naez = naez + 2^(4+spellekszama+buffokszama+debuffokszama+2)
    end
end