snd = manager:machine().devices[":sub"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":gpu:screen"]

dofile("notes.lua")

Addresses = {
0x8A000,0x8A020,0x8A040,0x8A060,0x8A080,0x8A0A0,0x8A0C0,0x8A0E0,
0x8A100,0x8A120,0x8A140,0x8A160,0x8A180,0x8A1A0,0x8A1C0,0x8A1E0,
0x8A200,0x8A220,0x8A240,0x8A260,0x8A280,0x8A2A0,0x8A2C0,0x8A2E0,
0x8A300,0x8A320,0x8A340,0x8A360,0x8A380,0x8A3A0,0x8A3C0,0x8A3E0,
0x8A400,0x8A420,0x8A440,0x8A460,0x8A480,0x8A4A0,0x8A4C0,0x8A4E0,
0x8A500,0x8A520,0x8A540,0x8A560,0x8A580,0x8A5A0,0x8A5C0,0x8A5E0

}

--[[
Custom Namco Hardware being driven by a 
48 tracks possible as the address table above point out

Voices
Panning is either byte 0x03 or 0x04 
Volume is at 0xE. The baseline is 0x7F lower = louder
Notes, 0x1A the byte after might velocity or something else.

]]

function drawkeyboard(kbx,kby,octaves)
WKeysC1,WKeysC2 = 0xFFFFFFFF,0xFFAAAAAA
BKeysC1,BKeysC2 = 0xFF000000,0xFF777777

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

function main()
set = 0 --mem:read_u8(0x89EF0)--unused byte to edit since there is no hotkeys
gui:draw_box(0,0,48,12,0x800000FF,0x80FFFF00)

instrument(8,12,00 + set*8)
instrument(8,22,01 + set*8)
instrument(8,32,02 + set*8)
instrument(8,42,03 + set*8)
instrument(8,52,04 + set*8)
instrument(8,62,05 + set*8)
instrument(8,72,06 + set*8)
instrument(8,82,07 + set*8)

end

function instrument(x,y,id)
--gui:
adr = Addresses[id+1]

volume = mem:read_u8(adr + 0x0E)
note = mem:read_u8(adr + 0x1A)

gui:draw_box(x,y,x+200,y+10,0x800000FF,0x80FFFF00)
gui:draw_text(x + 02,y + 2,string.format("%01X",id))
--gui:draw_text(x + 10,y + 2,string.format("%04X",adr))
--gui:draw_text(x + 30,y + 2,note)
drawkeyboard(x+48,y+2,4)

if note < 0x7F and note > 0 then
	drawplaynote(note+1,x+48,y+2,0xFFFF0000,0xFF880000)
	
	end 
end

emu.sethook(main,"frame")
