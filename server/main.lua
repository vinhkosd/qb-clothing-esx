ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Code

RegisterCommand("skin", function(source, args)
    local player = ESX.GetPlayerFromId(source)
    if player.getGroup() == 'admin' then
        TriggerClientEvent("qb-clothing:client:openMenu", source)
    end
end, false)

RegisterServerEvent("qb-clothing:saveSkin")
AddEventHandler('qb-clothing:saveSkin', function(model, skin, oldEsxSkin)
    local decodedSkin = json.decode(skin)
    local esxSkin = {}
    esxSkin = Config.ConvertFromQbusToESX(decodedSkin, oldEsxSkin)
    -- print("esxSkin")
    -- print(json.encode(esxSkin))
    -- TriggerEvent('esx_skin:save', esxSkin)
end)

RegisterServerEvent("qb-clothes:saveOutfit")
AddEventHandler("qb-clothes:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local data = {identifier = Player.identifier, license = GetPlayerIdentifiers(src)[1]}
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
       
    end
end)

RegisterServerEvent("qb-clothing:server:removeOutfit")
AddEventHandler("qb-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
	local data = {identifier = Player.identifier, license = GetPlayerIdentifiers(src)[1]}
    TriggerEvent('esx_datastore:getDataStore', 'property', Player.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		for k, v in pairs(dressing) do
            if(v.label == outfitName) then
                table.remove(dressing, v.label)
		        store.set('dressing', dressing)
                break
            end
        end

		store.save()
	end)
end)

ESX.RegisterServerCallback('qb-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local anusVal = {}
    TriggerEvent('esx_datastore:getDataStore', 'property', Player.identifier, function(store)
		local dressing = store.get('dressing')

        if dressing == nil then
			dressing = {}
		end

		for k, v in pairs(dressing) do         
            v.skin = Config.ConvertFromESXToQbus({}, v.skin)
            v.outfitname = v.label

            table.insert(anusVal, v)
        end
        cb(anusVal)
	end)
end)

RegisterServerEvent('qb-clothing:print')
AddEventHandler('qb-clothing:print', function(data)
    print(data)
end)