snd = manager:machine().devices[":soundcpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

dofile("notes.lua")

Addresses = {
--Percussion
0xF960,0xF988,
0xF9B0,0xF9D8,
0xFA00,

--Voices
0xF820,0xF848,0xF870,0xF898,
0xF8C0,0xF8E8,0xF910,0xF938

}

--[[
Percussion
"Hi-Hat1","Tom 2  ","Snare 1","Hi-Hat2","0x05   ",
"0x06   ","Tom 1  ","Tom 3  ","0x09   ","Crash  ",
]]

colorpads1 = {
0xFFFF0000,--0x00
0xFF00FF00,--0x01
0xFF0000FF,--0x02
0xFFFF00FF,--0x03
0xFFFFFF00,--0x04
}

colorpads2 = {
0xFF660000,--0x00
0xFF006600,--0x01
0xFF000066,--0x02
0xFF660066,--0x03
0xFF666600,--0x04
}

padx = {
0,8,16,24,32,
0,8,16,24,32
}

pady = {
0,0,0,0,0,0,
8,8,8,8,8,8,
}

--[[
Notes

+0x14 Left Volume
+0x15 Right Volume

+0x1B Instrument
+0x1C Play Left
+0x1D Play Right


]]

function main()
control = 0xF000
--gui:draw_box(0,0,50,28,0xC0EE00DD,0xFFFFFFFF)
pad(0,0)

playkeyboard(5,8,32)
playkeyboard(6,8,42)
playkeyboard(7,8,52)
playkeyboard(8,8,62)
playkeyboard(9,8,72)
playkeyboard(10,8,82)
playkeyboard(11,8,92)
playkeyboard(12,8,102)

end

function playkeyboard(id,x,y)
local addr = Addresses[id+1]
note = mem:read_u8(addr+0x12)

gui:draw_box(x,y,x+280,y+10,0x800000FF,0x80FFFF00)
gui:draw_text(x + 02,y + 2,string.format("%01X",id-5))
gui:draw_text(x + 10,y + 2,string.format("%04X",addr))
gui:draw_text(x + 34,y + 2,string.format("%01X",note))
drawkeyboard(x+48,y+2,8)
if note < 0x61 and note > 0 then
	drawplaynote(note,x+48,y+2,0xFFFF0000,0xFF880000)
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

function drawprecpad(pdx,pdy,xa,ya)
for h = 0,ya,1 do
	for w = 0,xa,1 do
	gui:draw_box(4 + (pdx + w*8),4 + (pdy + h*8),12 + (pdx + w*8),12 + (pdy + h*8),0xFFAAAAAA,0xFF666666)
	end
end

end


function pad(x,y)
local addr = 0xF960
local volr = addr+0x14
local voll = addr+0x15

local instrument = addr+0x1B
local playr = addr+0x1C
local playl = addr+0x1D

local volr1 = mem:read_u8(playr)
local volr2 = mem:read_u8(playr+0x38)
local volr3 = mem:read_u8(playr+(0x38*2))
local volr4 = mem:read_u8(playr+(0x38*3))
local volr5 = mem:read_u8(playr+(0x38*4))

--gui:draw_box(x  ,y   ,x+64,y+64,0xFF666666,0xFF444444)
drawprecpad(4,4,4,1)
padhit(0,8,8)
padhit(1,8,8)
padhit(2,8,8)
padhit(3,8,8)
padhit(4,8,8)
end

function padhit(id,px,py)
local addr = Addresses[id+1]
local volumel = mem:read_u8(addr + 0x14)
local volumer = mem:read_u8(addr + 0x15)
local instrument = mem:read_u8(addr + 0x1B)
local playl = mem:read_u8(addr + 0x1C)
local playr = mem:read_u8(addr + 0x1D)
if playl ~= 0 then 
drawplayperc(px,py,instrument,colorpads1[id+1],colorpads2[id+1])
end

end

function percussion(id,x,y)
local addr = Addresses[id+1]
local volumel = mem:read_u8(addr + 0x14)
local volumer = mem:read_u8(addr + 0x15)
local instrument = mem:read_u8(addr + 0x1B)
local playl = mem:read_u8(addr + 0x1C)
local playr = mem:read_u8(addr + 0x1D)

--gui:draw_box(x,y,x+50,y+32,0xCC0000EE,0xFFFFFF00)
gui:draw_text(x + 2,y +  0,string.format("%0X | %04X",id,addr))
gui:draw_text(x + 2,y + 10,string.format("%0X",instrument))
gui:draw_text(x + 2,y + 20,string.format("VOL: %0X|%0X",volumel,volumer))



end

function drawplayperc(x,y,inst,color1,color2)
x1 = x + padx[inst]
y1 = y + pady[inst]
x2 = 8 + x1
y2 = 8 + y1

gui:draw_box(x1,y1,x2,y2,color1,color2)

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

emu.sethook(main,"frame")
