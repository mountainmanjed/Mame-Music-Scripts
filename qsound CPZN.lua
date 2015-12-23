--for i,v in pairs(manager:machine().devices) do print(i) end;
for i,v in pairs(manager:machine().screens) do print(i) end;
snd = manager:machine().devices[":audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":gpu:screen"]

dofile("notes.lua")

keyboard = 0
cheats = 0

Addresses = {
0xF880,0xF8E8,0xF950,0xF9B8,
0xFA20,0xFA88,0xFAF0,0xFB58,
0xFBC0,0xFC28,0xFC90,0xFCF8,
0xFD60,0xFDC8,0xFE30,0xFE98
}

--[[


]]

function main()
--Cheats
if cheats == 1 then
--I should make a better way to mute them
--Just comment out the track you want to play
-- mutech(0)
 mutech(1)
 mutech(2)
 mutech(3)
 mutech(4)
 mutech(5)
 mutech(6)
 mutech(7)
 mutech(8)
 mutech(9)
 mutech(10)
 mutech(11)
 mutech(12)
 mutech(13)
 mutech(14)
 mutech(15)

end

if keyboard == 1 then
playkeyboard(0x0,0,  60)
playkeyboard(0x1,0,  70)
playkeyboard(0x2,0,  80)
playkeyboard(0x3,0,  90)
--[[
playkeyboard(0x4,0, 100)
playkeyboard(0x5,0, 110)
playkeyboard(0x6,0, 120)
playkeyboard(0x7,0, 130)
playkeyboard(0x8,0, 140)
playkeyboard(0x9,0, 150)
playkeyboard(0xA,0, 160)
playkeyboard(0xB,0, 170)
playkeyboard(0xC,0, 180)
playkeyboard(0xD,0, 190)
playkeyboard(0xE,0, 200)
playkeyboard(0xF,0, 210)
]]
else

--9830+8000
--c193+8000
--Main control 0xF000
control = 0xF000
tblstart = rd24bit(control + 0x18,control + 0x19)
tempo    = mem:read_u16(control + 0x10)
tempoedt = mem:read_u16(control + 0x12) --Can edit
songvol  = mem:read_u8(control + 0x19)

gui:draw_box(400,0,512,32,0xC0EE00DD,0xFFFFFFFF)
--gui:draw_text(302, 2,string.format("Tempo: %s,%X",tempoedt,tempoedt))
--gui:draw_text(302,10,string.format("Volume: %s",songvol))
gui:draw_text(400,18,string.format("Table: %05X",tblstart))

notetrack(  0, 32, 0)
notetrack(  0, 64, 1)
notetrack(  0, 96, 2)
notetrack(  0,128, 3)
notetrack(  0,160, 4)
notetrack(  0,192, 5)


notetrack(132, 76, 6)
notetrack(132,108, 7)
notetrack(132,140, 8)
notetrack(132,172, 9)
notetrack(132,204,10)

notetrack(264, 76,11)
notetrack(264,108,12)
notetrack(264,140,13)
notetrack(264,172,14)
notetrack(264,204,15)


end

end


function notetrack(x,y,id)
addr = Addresses[id+1]
active =  mem:read_u8(addr + 0x00)
transpose = mem:read_i8(addr + 0x26)

note1 =  mem:read_u8(addr + 0x2C)
note2 =  mem:read_u8(addr + 0x2E)+transpose

volume = mem:read_u8(addr + 0x30)



--Draw graphics 0xAARRBBGG fill,outlin
if active == 0 then
gui:draw_box(x-2,y,x+130,y+32,0,0x80C0C000)
else
gui:draw_box(x-2,y,x+130,y+32,0xC0C00000,0x80C0C000)

gui:draw_text(x +  2,y +  0,string.format("%04X",addr))
gui:draw_text(x +  124,y +  0,string.format("%0X",id))

gui:draw_text(x +  2,y +   8,string.format("VL: %2X",volume))

--Notes
gui:draw_text(x +  2,y +  16,string.format("N1: %2X",note1))
gui:draw_text(x +  2,y +  24,string.format("N2: %2X",note2))

--gui:draw_text(x+ 36,y + 16,string.format("S1: %2X",setting1))
--gui:draw_text(x+ 72,y + 16,string.format("S2: %2X",setting2))
--gui:draw_text(x+ 36,y + 24,string.format("S3: %2X",setting3))

--Pan
--pangraphic(x+48,y+4,pan)

end
--Dividers
gui:draw_line(x- 2,y+ 8,x+130,y+ 8,0xFFFFFFFF)
gui:draw_line(x+42,y+ 8,x+ 42,y+32,0xFFFFFFFF)
gui:draw_line(x- 2,y+16,x+130,y+16,0xFFFFFFFF)

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

active =  mem:read_u8(addr + 0x00)
note1 =  mem:read_u8(addr + 0x2C)
note2 =  mem:read_u8(addr + 0x2E)

setting3 = mem:read_u8(addr + 0x25)
play = mem:read_u8(addr+ 0x03)
notef1 = note1 - (47 + 12)
notef2 = note2 - 42

if active ~= 0 then
gui:draw_box(x,y,x+220,y+10,0xFF0000FF,0xFFFFFF00)
gui:draw_text(x + 02,y + 2,string.format("%01X",id))
drawkeyboard(x+40,y+2,4)

if play > 0 then
	gui:draw_text(x + 12,y + 2,cps2notes[note1+2])
	gui:draw_text(x + 22,y + 2,octave)
	gui:draw_text(x + 30,y + 2,notef1)
	drawplaynote(notef1,x+40,y+2,0xFFFF0000,0xFF880000)
	--drawplaynote(notef1,x+40,y+2,0xFF00FF00,0xFF008800)
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

function insttrack(x,y,addr)
--Draw graphics 0xAARRBBGG fill,outline
gui:draw_text(x+12,y-12,string.format("Addr: %X",addr))

--memview
for row = 0,3,1 do
texty = y+row*12 
raddr = addr + row*16 
	for i = 0,15,1 do
	textx = x+i*12
	gui:draw_text(textx+8,texty,string.format("%02X",mem:read_u8(raddr + i)))
	end
end

end

function rd24bit(adr8,adr16)
val8  = mem:read_u8(adr8)
val16 = mem:read_u16(adr16)

val = (val8*0x10000) + val16

return val
end

function mutech(id)
addr = Addresses[id+1]
mem:write_u8(addr + 0x30,00)
mem:write_u8(addr + 0x00,00)
--mem:write_u8(addr + 0x25,00)
end

function pangraphic(x,y,val)

val = val-16

gui:draw_line(x-16,y,x+16,y,0xFFFFFFFF)
gui:draw_line(x,y+2,x,y-2,0xFF808080)
gui:draw_line(x-16,y+2,x-16,y-2,0xFF00FFFF)
gui:draw_line(x+16,y+2,x+16,y-2,0xFFFF00FF)

gui:draw_box(x,y+2,x+val,y-2,0xC000FF00,0xFFFFFFFF)


end

emu.sethook(main,"frame")
