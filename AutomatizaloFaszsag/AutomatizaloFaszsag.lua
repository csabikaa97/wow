print("Elindult az AutomatizaloFaszsag addon!")

spellek = {"Whirlwind", "Bloodthrist", "Bloodrage", "Berserker Rage", "Death Wish", "Recklessness"}
spellidk = {1680, 23881, 2687, 18499, 12292, 1719}

rageszintek = {12,15,20,25,37,70,80}
ragekodok = {65536, 131072, 262144, 524288, 1048576, 256, 512}

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

    --Whirlwind CD                              1
    --Bloodthirst CD                            2
    --Bloodrage CD                              4
    --Berserker rage CD                         8
    --Death Wish CD                             16
    --Recklessness CD                           32
    --Slam buff                                 64
    --(empty)                                   128
    --70 rage /run print(UnitHealth("targ et")) 256
    --80 rage                                   512
    --Battle Shout UP                           1024
    --UnitAffectingCombat("player") - InCombat  2048
    --van enemy target                          4096
    --IsSpellInRange("Bloodthirst", "target")   8192
    --Sunder Armor stack not 5                  16384
    --Sunder Armor duration below 3 sec         32768
    --12 rage                                   65536
    --15 rage                                   131072
    --20 rage                                   262144
    --25 rage                                   524288
    --37 rage                                   1048576
    --enemy more than 210k hp                   2097152
    --WW CD 0.5 secen belül                     4194304
    --ReUP                                      8388608
    --DWUP                                      16777216




    --CD RÉSZ
    for i = 1,6,1 
    do
        start, duration, inactive = GetSpellCooldown( spellidk[i] );
        if start > 0 and duration > 0 then

        else
            naez = naez + 2^(i-1)
        end
    end

    --WW CD
    start, duration, inactive = GetSpellCooldown( 1680 );
    toUsable = GetTime() - start - duration
    if toUsable > -1.0 then
        naez = naez + 4194304
    end


    

    --RAGE RÉSZ
    if true then
        local ragi = UnitPower("player" , ragi)
        for i=1,7,1 do
            if ragi >= rageszintek[i] then
                naez = naez + ragekodok[i]
            end
        end
    end


    --BUFF RÉSZ
    for i=1,40 do 
        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player",i); 
        if name == "Slam!" then
            naez = naez + 64
        end
        if name == "Battle Shout" or name == "Blessing of Might" or name == "Greater Blessing of Might" then
            naez = naez + 1024
        end

        if name == "Recklessness" then
            naez = naez + 8388608
            --print("REKCLESSNESS UP!!!")
        end

        if name == "Death Wish" then
            naez = naez +  16777216
            --print("DEATH WISH UP")
        end
    end



    --ENEMY DEBUFF RÉSZ
    vanotstack = 0
    for i=1,40 do 
        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("target",i); 
        if name == "Sunder Armor" and count == 5 then 
            if expirationTime - GetTime() < 4.5 then
                naez = naez + 32768
            end
            vanotstack = 1
        end
    end
    if vanotstack == 0 then
        naez = naez + 16384
    end



    --egyéb RÉSZ
    if UnitAffectingCombat("player") == 1 then
        naez = naez + 2048
    end
    
    if UnitExists("target") and UnitCanAttack("player", "target") == 1 then
        naez = naez + 4096
    end
    
    if IsSpellInRange("Bloodthirst", "target") == 1 then
        naez = naez + 8192
    end
    
    if (UnitHealth("target")/meret) > 160000 then
        naez = naez + 2097152
    end
end