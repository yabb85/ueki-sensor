-- Check wifi connection after 1 second
print('\nAll About Circuits ueki.lua\n')
tmr.alarm(0, 1000, 1, function()
	if wifi.sta.getip() == nil then
		print("Connecting to AP...\n")
		print("status: ", wifi.sta.status())
	else
		ip, nm, gw=wifi.sta.getip()
		print("IP Info: \nIP Address: ",ip)
		print("Netmask: ",nm)
		print("Gateway Addr: ",gw,'\n')
		wifi.sta.eventMonReg(wifi.STA_IDLE)
		tmr.stop(0)
		tmr.alarm(1, 2000, tmr.ALARM_SINGLE, update)
		tmr.alarm(2, 7000, tmr.ALARM_SINGLE, sleep)
	end
end)

-- Configure GPIO
pindht = 4


name = wifi.sta.getmac()
address = 'https://plante.hory.me/sensors/'..name
content = 'Content-Type: application/json\r\n'

function display(code, data)
	if (code <0) then
		print("HTTP request failed")
		print(code, data)
	else
		print(code, data)
	end
end

function update()
	status, temp, humi, _, _ = dht.read(pindht)
	data = '{"temp":"'..temp..'","humidity":"'..humi..'"}'
	print(address)
	print(data)
	http.post(address,
		content,
		data,
		display)
end

function sleep()
	node.dsleep(15 * 60 * 1000000)
end
