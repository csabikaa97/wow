print("Elindult az AutomatizaloFaszsagMage addon!")

spellek = {"Fireball", "Fire Blast", "Combustion"}
spellidk = {133, 2137, 11129}
spellekszama = 3
--legelso spell lesz hasznalva range check-re

buffok = { "Mage Armor", "Arcane Intellect", "Drink", "Hot Streak" }
buffokszama = 4

debuffok = { "Fireball", "Living Bomb", "Improved Scorch" }
debuffokszama = 3

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
    
    if IsSpellInRange(spellek[2], "target") == 1 then
        naez = naez + 4
    end
    
    if (UnitHealth("target")/meret) > 160000 then
        naez = naez + 8
    end





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
                naez = naez + 2^(4+spellekszama+j-1)
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
    for j=1,debuffokszama do
        for i=1,40 do 
            name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("target",i); 
            if name == debuffok[j] then
                naez = naez + 2^(4+spellekszama+buffokszama+1+j)
            end
        end
    end
end