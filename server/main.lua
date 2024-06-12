local QBCore = exports["qb-core"]:GetCoreObject()

local function itemAdd(source, item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if (amount > 0) then
        Player.Functions.AddItem(item, amount, false)
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], "add")
    end
end

QBCore.Functions.CreateCallback("g5_trafico:server:checkPermission", function(source, cb, permission)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = Player and ((Player.PlayerData.job and Player.PlayerData.job.name == permission) or (Player.PlayerData.gang and Player.PlayerData.gang.name == permission))
    cb(result)
end)

local src = {
	--[1] = { ['re1'] = "quimicoA",['re2'] = "quimicoB",['re3'] = nil,
	--		['reqtd1'] = 1, ['reqtd2'] = 1, ['reqtd3'] = 0,
	--		['item1'] = "anfetamina", ['item2'] = nil, ['item3'] = nil,
	--		['itemqtd1'] = 1, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

	[1] = { ['re1'] = "anfetamina",['re2'] = "quimicoC",['re3'] = nil,
			['reqtd1'] = 3, ['reqtd2'] = 1, ['reqtd3'] = 0,
			['item1'] = "MDMA", ['item2'] = nil, ['item3'] = nil,
			['itemqtd1'] = 2, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

	[2] = { ['re1'] = "MDMA",['re2'] = "quimicoB",['re3'] = nil,
			['reqtd1'] = 1, ['reqtd2'] = 1, ['reqtd3'] = 0,
			['item1'] = "ecstasy", ['item2'] = nil, ['item3'] = nil,
			['itemqtd1'] = 1, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

	[3] = { ['re1'] = "ecstasy",['re2'] = "saquinhos",['re3'] = nil,
			['reqtd1'] = 1, ['reqtd2'] = 20, ['reqtd3'] = 0,
			['item1'] = "sacoecstasy", ['item2'] = nil, ['item3'] = nil,
			['itemqtd1'] = 20, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

	[4] = { ['re1'] = "MDMA",['re2'] = "saquinhos",['re3'] = nil,
			['reqtd1'] = 1, ['reqtd2'] = 20, ['reqtd3'] = 0,
			['item1'] = "sacomdma", ['item2'] = nil, ['item3'] = nil,
			['itemqtd1'] = 20, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

			------------- ERVA

	--[6] = { ['re1'] = "fertilizante",['re2'] = "adubo",['re3'] = "sementes",
	--		['reqtd1'] = 1, ['reqtd2'] = 1, ['reqtd3'] = 2,
	--		['item1'] = "canabis", ['item2'] = nil, ['item3'] = nil,
	--		['itemqtd1'] = 1, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

	[5] = { ['re1'] = "canabis",['re2'] = nil,['re3'] = nil,
			['reqtd1'] = 3, ['reqtd2'] = 0, ['reqtd3'] = 0,
			['item1'] = "blocoerva", ['item2'] = nil, ['item3'] = nil,
			['itemqtd1'] = 2, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

	[6] = { ['re1'] = "blocoerva",['re2'] = "saquinhos",['re3'] = nil,
			['reqtd1'] = 1, ['reqtd2'] = 20, ['reqtd3'] = 0,
			['item1'] = "sacoerva", ['item2'] = nil, ['item3'] = nil,
			['itemqtd1'] = 20, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

			------------- LAVAGEM DINHEIRO

	--[7] = { ['re1'] = "fatura",['re2'] = "scanner",['re3'] = nil,
	--		['reqtd1'] = 5, ['reqtd2'] = 1, ['reqtd3'] = 0,
	--		['item1'] = "faturafalsificada", ['item2'] = nil, ['item3'] = nil,
	--		['itemqtd1'] = 5, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },

			------------- PEÇAS DE ARMA

	[7] = { ['re1'] = "sucata",['re2'] = "scanner",['re3'] = nil,
			['reqtd1'] = 3, ['reqtd2'] = 1, ['reqtd3'] = 0,
			['item1'] = "gun_piece", ['item2'] = nil, ['item3'] = nil,
			['itemqtd1'] = 2, ['itemqtd2'] = 0, ['itemqtd3'] = 0 },
}

local function checkPayment(source, id)
    local Player = QBCore.Functions.GetPlayer(source)

	if Player then
        local backpackCapacity = exports["qb-inventory"]:GetBackPackCapacity() --> Essa export tem que ser adicionada. Ver README.md
        local playerItemsWeight = exports["qb-inventory"]:GetTotalWeight(Player.PlayerData.items)
		if src[id].re1 == nil then
			if playerItemsWeight + QBCore.Shared.Items[src[id].item1].weight * src[id].itemqtd1 <= backpackCapacity then
				itemAdd(source, src[id].item1, src[id].itemqtd1)
				return true
			end
		else
			local tem1 = false
            if exports['qb-inventory']:GetItemCount(source, src[id].re1) >= src[id].reqtd1 then
				tem1 = true
			else
				return false
			end

			local tem2 = false
			if src[id].re2 ~= nil then
				if (exports['qb-inventory']:GetItemCount(source, src[id].re2) >= src[id].reqtd2) then
					tem2 = true
				else
					return false
				end
			end

			local tem3 = false
			if src[id].re3 ~= nil then
				if (exports['qb-inventory']:GetItemCount(source, src[id].re3) >= src[id].reqtd3) then
					tem3 = true
				else
					return false
				end
			end

			local peso = QBCore.Shared.Items[src[id].item1].weight*src[id].itemqtd1
			if src[id].item2 ~= nil then
				peso = peso + QBCore.Shared.Items[src[id].item2].weight*src[id].itemqtd2
			end

			if src[id].item3 ~= nil then
				peso = peso + QBCore.Shared.Items[src[id].item3].weight*src[id].itemqtd3
			end

			if playerItemsWeight+peso <= backpackCapacity then
				itemAdd(source, src[id].item1, src[id].itemqtd1)
				if src[id].item2 ~= nil then
					itemAdd(source,src[id].item2,src[id].itemqtd1)
				end
				if src[id].item3 ~= nil then
					itemAdd(source,src[id].item3,src[id].itemqtd1)
				end

                Player.Functions.RemoveItem(src[id].re1,src[id].reqtd1, false)
				if src[id].re2 ~= nil then
                    Player.Functions.RemoveItem(src[id].re2, src[id].reqtd2, false)
				end
				if src[id].re3 ~= nil then
                    Player.Functions.RemoveItem(src[id].re3, src[id].reqtd3, false)
				end

				return true
			end
		end
	end
end

QBCore.Functions.CreateCallback("g5_trafico:server:checkPayment", function(source, cb, id)
    cb(checkPayment(source, id))
end)
