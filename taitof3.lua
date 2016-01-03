--for i,v in pairs(manager:machine().devices) do print(i) end;
snd = manager:machine().devices[":audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

dofile("notes.lua")--musical notes
dofile("asciitable.lua")--hex2text

gtranspose = -23

Addresses = {
0x59CE,0x5996,0x595E,0x5926,
0x58EE,0x587E,0x5846,
0x580E,0x57D6,0x579E,0x5766,
0x5D4E

}



--[[
Notes
14bda6 Kazuya data

]]

function main()
measure = mem:read_u16(0xFFD0B0)
beat = mem:read_u16(0xFFD0B2)+1
tempo = mem:read_u16(0xFFD0E6)

ascii(0xFFD06C-1,15,0,0)--Songname
gui:draw_box(0,10,38,18,0xC00000EE,0xFFFFFFFF)
gui:draw_text(2,9,string.format("Metro: %d",beat))
gui:draw_box(38,10,88,18,0xC00000EE,0xFFFFFFFF)
gui:draw_text(40,9,string.format("Measure: %02d",measure))
gui:draw_box(0,18,46,26,0xC00000EE,0xFFFFFFFF)
gui:draw_text(2,18,string.format("Tempo: %d",tempo))

if 0xFFD06C ~= 0 then
playkeyboard(0x00,0, 100)
playkeyboard(0x01,0, 110)
playkeyboard(0x02,0, 120)
playkeyboard(0x03,0, 130)
playkeyboard(0x04,0, 140)
playkeyboard(0x05,0, 150)
playkeyboard(0x06,0, 160)
playkeyboard(0x07,0, 170)
end

end

function ascii(addr,length,x,y)
gui:draw_box(x,y,x+128,y+10,0xC0EE00DD,0xFFFFFFFF)
for text = 0,length,1 do
	addr = addr + 1
	textp1 = mem:read_u8(addr)
	ftext = asciitable[textp1+1]
	gui:draw_text(2+x+text*8,y,ftext)
	end
end

function drawkeyboard(kbx,kby,octaves)
WKeysC1,WKeysC2 = 0xFFFFFFFF,0xFFAAAAAA
BKeysC1,BKeysC2 = 0xFF000000,0xFF777777
--BG
for oct = 0,octaves,1 do
for wk = 0,6,1 do --WhiteKeys
gui:draw_box(oct*28+kbx+wk*4,kby,oct*28+kbx+3+wk*4,kby+7,WKeysC1,WKeysC2)
end

for bd = 0,1,1 do
gui:draw_box(oct*28+kbx+2+bd*4,kby,oct*28+kbx+5+bd*4,kby+4,BKeysC1,BKeysC2)
end

for bt = 0,2,1 do
gui:draw_box(oct*28+kbx+14+bt*4,kby,oct*28+kbx+17+bt*4,kby+4,BKeysC1,BKeysC2)
end
end
end

function playkeyboard(id,x,y)
addr = Addresses[id+1]
note1  = mem:read_u8(addr + 0x22)
play = mem:read_u16(addr + 0x24)

--if active ~= 0 then
gui:draw_box(x,y,x+240,y+10,0xFF0000FF,0xFFFFFF00)
gui:draw_text(x + 02,y + 2,string.format("%04X",addr))
drawkeyboard(x+40,y+2,6)

if play ~= 0 then
	--gui:draw_text(x + 20,y + 2,cps2notes[note1])
	drawplaynote(note1 + gtranspose,x+40,y+2,0xFFFF0000,0xFF880000)
end

end


function rd24bit(adr8,adr16)
val8  = mem:read_u8(adr8)
val16 = mem:read_u16(adr16)

val = (val8*0x10000) + val16

return val
end

function drawplaynote(mnote,x,y,color1,color2)
x1 = x + playkx[mnote]
y1 = y + playky[mnote]
x2 = 3 + x1
y2 = 3 + y1

gui:draw_box(x1,y1,x2,y2,color1,color2)

end

emu.sethook(main,"frame")
