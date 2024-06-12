local QBCore = exports["qb-core"]:GetCoreObject()
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local Teleport = {
	["TRAFICO01"] = {
		positionFrom = { ['x'] = -3033.40, ['y'] = 3333.93, ['z'] = 10.27, ['perm'] = "entrada.permissao" },
		positionTo = { ['x'] = 894.49, ['y'] = -3245.88, ['z'] = -98.25, ['perm'] = "entrada.permissao" }
	}
}

Citizen.CreateThread(function()
	while true do
		sleep = 1000
		for k,v in pairs(Teleport) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.positionFrom.x,v.positionFrom.y,v.positionFrom.z)
			local distance = GetDistanceBetweenCoords(v.positionFrom.x,v.positionFrom.y,cdz,x,y,z,true)
			local bowz,cdz2 = GetGroundZFor_3dCoord(v.positionTo.x,v.positionTo.y,v.positionTo.z)
			local distance2 = GetDistanceBetweenCoords(v.positionTo.x,v.positionTo.y,cdz2,x,y,z,true)

			if distance <= 10 then
				sleep = 5
				DrawMarker(1,v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-1,0,0,0,0,0,0,1.0,1.0,1.0,255,255,255,50,0,0,0,0)
				if distance <= 1.5 then
					if IsControlJustPressed(0,38) then
                        QBCore.Functions.TriggerCallback("g5_trafico:server:checkPermission", function(result)
                            if result then
                                SetEntityCoords(PlayerPedId(),v.positionTo.x,v.positionTo.y,v.positionTo.z-0.50)
                            end
                        end, v.positionTo.perm)
					end
				end
			end

			if distance2 <= 10 then
				sleep = 5
				DrawMarker(1,v.positionTo.x,v.positionTo.y,v.positionTo.z-1,0,0,0,0,0,0,1.0,1.0,1.0,255,255,255,50,0,0,0,0)
				if distance2 <= 1.5 then
					if IsControlJustPressed(0,38) then
                        QBCore.Functions.TriggerCallback("g5_trafico:server:checkPermission", function(result)
                            if result then
						        SetEntityCoords(PlayerPedId(),v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-0.50)
                            end
                        end, v.positionFrom.perm)
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local locais = {

	-- // ÁCIDOS
	--{ ['id'] = 1, ['x'] = -521.28, ['y'] = -1738.52, ['z'] = 17.20, ['text'] = "PRODUZIR ANFETAMINAS", ['perm'] = "acidos.permissao" },
	{ ['id'] = 1, ['x'] = -531.84, ['y'] = -1737.65, ['z'] = 16.72, ['text'] = "ACIDIFICAR ANFETAMINA", ['perm'] = "acidos.permissao" },
	{ ['id'] = 2, ['x'] = -530.18, ['y'] = -1795.80, ['z'] = 21.60, ['text'] = "PRODUZIR ECSTASY", ['perm'] = "acidos.permissao" },
	{ ['id'] = 3, ['x'] = -535.07, ['y'] = -1793.75, ['z'] = 21.60, ['text'] = "DISTRIBUIR ECSTASY", ['perm'] = "acidos.permissao" },
	{ ['id'] = 4, ['x'] = -538.52, ['y'] = -1793.83, ['z'] = 21.60, ['text'] = "DISTRIBUIR MDMA", ['perm'] = "acidos.permissao" },

	-- // ERVA
	--{ ['id'] = 6, ['x'] = 1752.50, ['y'] = -1601.01, ['z'] = 112.65, ['text'] = "PLANTAR E COLHER A ERVA", ['perm'] = "weed.permissao" },
	{ ['id'] = 5, ['x'] = 1769.93, ['y'] = -1619.60, ['z'] = 113.63, ['text'] = "TRATAR CANÁBIS", ['perm'] = "weed.permissao" },
	{ ['id'] = 6, ['x'] = 1408.52, ['y'] = 3667.55, ['z'] = 34.02, ['text'] = "PROCESSAR ERVA", ['perm'] = "weed.permissao" },

	-- // MONEY WASH
	--{ ['id'] = 7, ['x'] = 1048.18, ['y'] = -1918.73, ['z'] = 30.65, ['text'] = "LAVAR O DINHEIRO", ['perm'] = "lavagem.permissao" },

	-- // PEÇA DE ARMAS
	{ ['id'] = 7, ['x'] = 588.13, ['y'] = -3281.16, ['z'] = 6.06, ['text'] = "PRODUZIR PEÇA DE ARMA", ['perm'] = "armamento.permissao" },
}

Citizen.CreateThread(function()
	while true do
		sleep = 1000
		for k,v in pairs(locais) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 1.2 and not processo then
				sleep = 5
				drawTxt("PRESSIONA  ~b~E~w~  PARA "..v.text,4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) and func.checkPermission(v.perm) then
                    QBCore.Functions.TriggerCallback("g5_trafico:server:checkPermission", function(result)
                        if result then
                            QBCore.Functions.TriggerCallback("g5_trafico:server:checkPayment", function(result)
                                if result then
                                    TriggerEvent('cancelando',true)
						            processo = true
						            segundos = 10
                                end
                            end, v.id)
                        end
                    end, v.perm)
				end
			end
		end
		if processo then
			sleep = 5
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR O PROCESSO",4,0.5,0.93,0.50,255,255,255,180)
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if segundos > 0 then
			segundos = segundos - 1
			if segundos == 0 then
				processo = false
				TriggerEvent('cancelando',false)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(true)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end