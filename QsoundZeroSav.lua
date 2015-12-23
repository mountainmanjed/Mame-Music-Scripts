--for i,v in pairs(manager:machine().devices) do print(i) end;
snd = manager:machine().devices[":audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

keyboard = 1
cheats = 0
dofile("notes.lua")
Addresses = {
0xF700,0xF750,0xF7A0,0xF7F0,
0xF840,0xF890,0xF8E0,0xF930,
0xF980,0xF9D0,0xFA20,0xFA70,
0xFAC0,0xFB10,0xFB60,0xFBB0
}

--[[
trace bqsound.log,1,{tracelog "AF=%04X BC=%04X DE=%04X HL=%04X IX=%04X IY=%04X PC=",af,bc,de,hl,ix,iy}
Ken add 35EE to ST location

]]

function main()
--Cheats
if cheats == 1 then
--I should make a better way to mute them
--Just comment out the track you want to play
 mutech(0)
 mutech(1)
 mutech(2)
 mutech(3)
 mutech(4)
 mutech(5)
 mutech(6)
 mutech(7)
 mutech(8)
-- mutech(9)
-- mutech(10)
 mutech(11)
 mutech(12)
 mutech(13)
 mutech(14)
 mutech(15)

end
if keyboard == 1 then
playkeyboard(0x0,  8,  40)
playkeyboard(0x1,190,  40)
playkeyboard(0x2,  8,  50)
playkeyboard(0x3,190,  50)
playkeyboard(0x4,  8,  60)
playkeyboard(0x5,190,  60)
playkeyboard(0x6,  8,  70)
playkeyboard(0x7,190,  70)
playkeyboard(0x8,  8,  80)
playkeyboard(0x9,190,  80)
playkeyboard(0xA,  8,  90)
playkeyboard(0xB,190,  90)
playkeyboard(0xC,  8, 100)
playkeyboard(0xD,190, 100)
playkeyboard(0xE,  8, 110)
playkeyboard(0xF,190, 110)

else

--Main control 0xF000
control = 0xF000
tblstart = rd24bit(control + 0x17,control + 0x18)
tempo    = mem:read_u16(control + 0x0B)
tempoedt = mem:read_u16(control + 0x20)
--songvol  = mem:read_u8(control + 0x19)

gui:draw_box(300,0,384,32,0xC0EE00DD,0xFFFFFFFF)
gui:draw_text(302, 2,string.format("Tempo: %s,%X",tempoedt,tempoedt))
gui:draw_text(302,10,string.format("Table: %X",tblstart))

notetrack(  0,  0,0)
notetrack(  0, 32,1)
notetrack(  0, 64,2)
notetrack(  0, 96,3)
notetrack(  0,128,4)
notetrack(  0,160,5)
notetrack(  0,192,6)
notetrack(114, 64,7)
notetrack(114, 96,8)
notetrack(114,128,9)
notetrack(114,160,10)
notetrack(114,192,11)
notetrack(228, 96,12)
notetrack(228,128,13)
notetrack(228,160,14)
notetrack(228,192,15)

end
end

function notetrack(x,y,id)
addr = Addresses[id+1]
--rd24bit(ad1,ad2)
active = mem:read_u8(addr + 0x00)

pitch    = mem:read_u8(addr + 0x0B)
finetune = mem:read_u8(addr + 0x0C)

note1  = mem:read_u8(addr + 0x14)
note2  = mem:read_u8(addr + 0x16)

volume   = mem:read_u8(addr + 0x19)

pan = mem:read_u8(addr + 0x37)

--Draw graphics 0xAARRBBGG fill,outlin
if active == 0 then
gui:draw_box(x-2,y,x+112,y+32,0,0x80C0C000)
else
gui:draw_box(x-2,y,x+112,y+32,0xC0C00000,0x80C0C000)

gui:draw_text(x +  104,y +  0,string.format("%0X",id))

--gui:draw_text(x +  0,y +  0,string.format("%01X%04X",pointer))

gui:draw_text(x + 36,y +   8,string.format("PT: %2X",pitch))
gui:draw_text(x + 72,y +   8,string.format("FT: %2X",finetune))
gui:draw_text(x +  2,y +   8,string.format("VL: %2X",volume))

--Notes
gui:draw_text(x +  2,y +  16,"N1: " .. cps2notes[note1+1])
gui:draw_text(x +  2,y +  24,string.format("N2: %2X",note2))

--Pan
--pangraphic(x+48,y+4,pan)


end
end

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

function playkeyboard(id,x,y)
addr = Addresses[id+1]
note1  = mem:read_u8(addr + 0x14)
note2  = mem:read_u8(addr + 0x16)
active = mem:read_u8(addr + 0x00)
setting3 = mem:read_u8(addr + 0x33)
octave = mem:read_u8(addr+ 0x04)&0x07
notef1 = note1 - octave*12
notef2 = note2 - octave*12

if active ~= 0 then
gui:draw_box(x,y,x+180,y+10,0xFF0000FF,0xFFFFFF00)
gui:draw_text(x + 02,y + 2,string.format("%01X",id))
drawkeyboard(x+40,y+2,4)

if setting3 < 5 then
	gui:draw_text(x + 12,y + 2,cps2notes[note1+1])
	gui:draw_text(x + 22,y + 2,octave)
	gui:draw_text(x + 30,y + 2,notef1)
	drawplaynote(notef1,x+40,y+2,0xFFFF0000,0xFF880000)
	drawplaynote(notef2,x+40,y+2,0xFF00FF00,0xFF008800)
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

function rd24bit(adr8,adr16)
val8  = mem:read_u8(adr8)
val16 = mem:read_u16(adr16)

val = (val8*0x10000) + val16

return val
end

function mutech(id)
addr = Addresses[id+1]
mem:write_u8(addr + 0x19,00)
mem:write_u8(addr + 0x00,00)
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
