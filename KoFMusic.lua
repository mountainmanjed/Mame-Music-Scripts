snd = manager:machine().devices[":audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

dofile("notes.lua")

Addresses = {
0xFA24,0xFA4B,0xFA72,0xFA99,
0xFAC0,0xFae7,0xFB0E,0xFB35,
0xFB5C,0xFB83,0xFBAA

}
--[[
Apparently only 11 instruments play?
Known Insturment details
Size 0x27

Note adr+0x02
Resttime adr+0x05
Location pointer adr+0x0B
Starting pointer adr+0x0D
Volume 0x10

Games tested on and worked on
KoF 98,2000,2001,2002,2003,and SvC

Probably also works on KoF 96,97, and 99
doesn't work on 94 and 95
]]

function main()
tempo = mem:read_u8(0xFD89)--Actually 2 Bytes 0xFD89+0xFD8A
gui:draw_box(0,0,48,12,0x400000FF,0x40FFFF00)
gui:draw_text(4,2,string.format("Tempo: %03d",tempo))

instrument(8, 12,0)
instrument(8, 22,1)
instrument(8, 32,2)
instrument(8, 42,3)
instrument(8, 52,4)
instrument(8, 62,5)
instrument(8, 72,6)
instrument(8, 82,7)
instrument(8, 92,8)
instrument(8,102,9)
instrument(8,112,10)


end

function instrument(x,y,id)
adr = Addresses[id+1]

note = mem:read_u8(adr + 0x02)
play = mem:read_u8(adr + 0x05)
volume = mem:read_u8(adr + 0x10)

octave = octaveget(note)
notef = note-(octave*36)

gui:draw_box(x,y,x+170,y+10,0x800000FF,0x80FFFF00)
gui:draw_text(x + 02,y + 2,string.format("%01X",id))
gui:draw_text(x + 10,y + 2,string.format("%04X",adr))
drawkeyboard(x+48,y+2,2)
gui:draw_text(x + 30,y + 2,notef)
gui:draw_text(x + 160,y + 2,octave)
gui:draw_text(x + 140,y + 2,volume)

if play ~= 1 and notef < 96 and notef > 0 then
	drawplaynote(notef+1,x+48,y+2,0xFFFF0000,0xFF880000)
	--drawplaynote(notef1,x+40,y+2,0xFF00FF00,0xFF008800)
	else
	
	end 
end

function octaveget(val)
local oct = 0

repeat oct = oct + 1
val = val - 36
until val < 36

	return oct
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


function drawplaynote(mnote,x,y,color1,color2)
x1 = x + playkx[mnote]
y1 = y + playky[mnote]
x2 = 3 + x1
y2 = 3 + y1

gui:draw_box(x1,y1,x2,y2,color1,color2)

end

emu.sethook(main,"frame")
