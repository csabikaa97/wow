--GetAuctionItemClasses()
    --kiadja a ketgoriakat

--QueryAuctionItems("Dreadstone", nil, nil, 0, 0, 0, <PAGENUMBER>, )
    --rákeres az adott itemre, 1 oldal

--local name, texture, count, quality, canUse, level, levelColHeader, LegkisebbBid, LegkisebbIncrement, buyoutPrice, bidAmount, highBidder, owner, saleStatus = GetAuctionIteLegkisebbfo("list", <INDEX>);

--GetAuctionIteLegkisebbfo("list", <INDEX>)
    --reszltes info

--N name
--C count
--B Legkisebbbid
--U buyoutprice

print("Aukcioszetrombolokurvaisten betoltott")

local canQuery,canQueryAll 
local N,a,C,b,c,d,F,v,U,j,k,f,g
numofitems = 0
osszesenmennyivan = 0
local p = 69000
legnagyobb = 69000
JelenlegiOldalSzam = 1
tomb = {}

funkcio = 1

function aukciosdolog(itemneve)
    canQuery,canQueryAll = CanSendAuctionQuery()
    
    if JelenlegiOldalSzam <= legnagyobb then
        if funkcio == 0 then
            funkcio = 1

            N,a,C,b,c,d,F,v,U,j,k,f,g=GetAuctionItemInfo("list", 1)
            if N==nil then
                print("DEBUG: Auction data not available yet")
            else
                print("DEBUG: Auction data scanning...")

                if p == 69000 then
                    p, legnagyobb = GetNumAuctionItems("list")
                    legnagyobb = math.ceil(legnagyobb)
                    print("DEBUG: setting p to ", legnagyobb)
                end

                for i=1,50 do
                    N,a,C,b,c,d,F,v,U,j,k,f,g=GetAuctionItemInfo("list", i)
                    if (N==itemneve) and not((U==0) or (F==0)) then
                        numofitems = numofitems + 1
                        tomb[numofitems] = { C, F, U, F/C, U/C, f }
                        --print(numofitems, " - \"", N, "\"", tomb[numofitems][1], "db - ", tomb[numofitems][4]/10000, "G /", tomb[numofitems][5]/10000, "G")
                        osszesenmennyivan = osszesenmennyivan + 1
                    end
                end
                JelenlegiOldalSzam = JelenlegiOldalSzam + 1
            end
            haditerv()
        else
            funkcio = 0
            QueryAuctionItems(itemneve, nil, nil, 0, 0, 0, JelenlegiOldalSzam)
        end
    end
end

function haditerv()
    Legkisebbcounter = 0
    Legkisebb2counter = 0
    Legkisebb = 6910010101
    Legkisebbitem = 0
    Legkisebb2 = 69321873721
    Legkisebbitem2 = 0

    for i=1,numofitems do
        if tomb[i][5] < Legkisebb then
            Legkisebb = tomb[i][5]
            Legkisebbitem = tomb[i] 
        end
    end

    for i=1,numofitems do
        if (tomb[i][5] < Legkisebb2) and (tomb[i][5] > Legkisebb) then
            Legkisebb2 = tomb[i][5]
            Legkisebbitem2 = tomb[i]
        end
    end

    for i=1,numofitems do
        if tomb[i][5] == Legkisebb then
            Legkisebbcounter = Legkisebbcounter + 1
        end
        if tomb[i][5] == Legkisebb2 then
            Legkisebb2counter = Legkisebb2counter + 1
        end
    end

    

    print(Legkisebbcounter, "db - ", Legkisebbitem[4]/10000, "G /", Legkisebbitem[5]/10000, "G - ", Legkisebbitem2[6])
    print(Legkisebb2counter, "db - ", Legkisebbitem2[4]/10000, "G /", Legkisebbitem2[5]/10000, "G - ", Legkisebbitem2[6])
    print("Osszesen ", osszesenmennyivan, "hirdetes van")
end