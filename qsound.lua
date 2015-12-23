--for i,v in pairs(manager:machine().devices) do print(i) end;
snd = manager:machine().devices[":audiocpu"]
mem = snd.spaces["program"]
gui = manager:machine().screens[":screen"]

dofile("notes.lua")

keyboard = 1
cheats = 0

Addresses = {
0xF600,0xF640,0xF680,0xF6C0,
0xF700,0xF740,0xF780,0xF7C0,
0xF800,0xF840,0xF880,0xF8C0,
0xF900,0xF940,0xF980,0xF9C0
}

--[[
Notes in the Memory
00 = C
01 = Db/C#
02 = D
03 = Eb/D#
04 = E
05 = F
06 = Gb/F#
07 = G
08 = Ab/G#
09 = A
0A = Bb/A#
0B = B
0C = C
0D = Db/C# 
0E = D
0F = Eb/D#
10 = E
11 = F
12 = Gb/F#
13 = G
14 = Ab/G#
15 = A
16 = Bb/A#
17 = B
18 = C
19 = Db/C# 
1A = D
1B = Eb/D#
1C = E
1D = F
1E = Gb/F#
1F = G
20 = Ab/G#
21 = A
22 = Bb/A#
23 = B
24 = C
25 = Db/C# 
27 = D
28 = Eb/D#
29 = E
2A = F
2B = Gb/F#
2C = G
2D = Ab/G#
2E = A
2F = Bb/A#
30 = B
31 = C
32 = Db/C# 
33 = D
34 = Eb/D#
35 = E
36 = F
37 = Gb/F#
38 = G
39 = Ab/G#
3A = A
3B = Bb/A#
3C = B
3D = C
3E = Db/C# 
3F = D
40 = Eb/D#
41 = E
42 = F
43 = Gb/F#
44 = G
45 = Ab/G#
46 = A
47 = Bb/A#
48 = B
49 = C
4A = Db/C# 
4B = D
4C = Eb/D#
4D = E
4E = F



trace bqsound.log,1,{tracelog "AF=%04X BC=%04X DE=%04X HL=%04X IX=%04X IY=%04X PC=",af,bc,de,hl,ix,iy}
ST Sound Engine
Sound FX Tracks
First Track F200
Size 40

0E Volume

20 Activate

Instrument Tracksa
First Track F600
Size 0x40 Bytes
Nothing controls which sample is loaded in the memory

000102 Pointer(add 0x8000 if using mame's :audiocpu) Deals with intruments as well
03
04 Octave (first 4 bits)
05

060708090A

0B Pitch
0C Fine Tune
0D 
0E Volume

0F101112

13 Note
14
15 Note(Slide too?)

161718191A1B1C1D1E1F(Pitch bend is around here)

20 Activate

21
22 
23

2425262728292A2B2C2D2E2F30313233343536

37 Pan  Left 01 ~ 1F Right(Only placed for debugging? since it has no effect while the music is playing)

38393A3B3C3D3E3F

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
-- mutech(7)
 mutech(8)
 mutech(9)
 mutech(10)
 mutech(11)
 mutech(12)
 mutech(13)
 mutech(14)
 mutech(15)

end
control = 0xF000
tblstart = rd24bit(control + 0x09,control + 0x0A)
tempo    = mem:read_u16(control + 0x10)
tempoedt = mem:read_u16(control + 0x12) --Can edit
songvol  = mem:read_u8(control + 0x19)

--gui:draw_box(300,0,384,32,0xC0EE00DD,0xFFFFFFFF)
gui:draw_text(302, 2,string.format("Tempo: %s,%X",tempoedt,tempoedt))
gui:draw_text(302,10,string.format("Volume: %s",songvol))
gui:draw_text(302,18,string.format("Table: %05X",tblstart))


if keyboard == 1 then

playkeyboard(0x0,0,  60)
playkeyboard(0x1,0,  70)
playkeyboard(0x2,0,  80)
playkeyboard(0x3,0,  90)
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

else

--9830+8000
--c193+8000
--Main control 0xF000
control = 0xF000
tblstart = rd24bit(control + 0x09,control + 0x0A)
tempo    = mem:read_u16(control + 0x10)
tempoedt = mem:read_u16(control + 0x12) --Can edit
songvol  = mem:read_u8(control + 0x19)

--gui:draw_box(300,0,384,32,0xC0EE00DD,0xFFFFFFFF)
gui:draw_text(302, 2,string.format("Tempo: %s,%X",tempoedt,tempoedt))
gui:draw_text(302,10,string.format("Volume: %s",songvol))
gui:draw_text(302,18,string.format("Table: %05X",tblstart))

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
note1  = mem:read_u8(addr + 0x13)
note2  = mem:read_u8(addr + 0x15)
active = mem:read_u8(addr + 0x20)
setting3 = mem:read_u8(addr + 0x25)
octave = mem:read_u8(addr+ 0x03)&0x07
notef1 = note1 - octave*12
notef2 = note2 - octave*12

if active ~= 0 then
gui:draw_box(x,y,x+220,y+10,0xFF0000FF,0xFFFFFF00)
gui:draw_text(x + 02,y + 2,string.format("%01X",id))
drawkeyboard(x+40,y+2,4)

if setting3 < 5 then
	gui:draw_text(x + 12,y + 2,cps2notes[note1+1])
	gui:draw_text(x + 22,y + 2,octave)
	gui:draw_text(x + 30,y + 2,string.format("%02X",note1))
	drawplaynote(notef2,x+40,y+2,0xFFFF0000,0xFF880000)
	drawplaynote(notef1,x+40,y+2,0xFF00FF00,0xFF008800)
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


function notetrack(x,y,id)
addr = Addresses[id+1]

pointerp1 = mem:read_u16(addr)
pointerp2 = mem:read_u8(addr+ 0x02)

track = rd24bit(pointerp1,pointerp2)

pitch    = mem:read_u8(addr + 0x0B)
finetune = mem:read_u8(addr + 0x0C)
volume   = mem:read_u8(addr + 0x0E)

note1  = mem:read_u8(addr + 0x13)
note2  = mem:read_u8(addr + 0x15)

--Pitch

active = mem:read_u8(addr + 0x20)

setting1 = mem:read_u8(addr + 0x23)
setting2 = mem:read_u8(addr + 0x24)
setting3 = mem:read_u8(addr + 0x25)

pan = mem:read_u8(addr + 0x37)


--Draw graphics 0xAARRBBGG fill,outlin
if active == 0 then
gui:draw_box(x-2,y,x+112,y+32,0,0x80C0C000)
else
gui:draw_box(x-2,y,x+112,y+32,0xC0C00000,0x80C0C000)

gui:draw_text(x +  104,y +  0,string.format("%0X",id))

gui:draw_text(x +  0,y +  0,string.format("%01X%04X",pointerp2,pointerp1))

gui:draw_text(x + 36,y +   8,string.format("PT: %2X",pitch))
gui:draw_text(x + 72,y +   8,string.format("FT: %2X",finetune))
gui:draw_text(x +  2,y +   8,string.format("VL: %2X",volume))

--Notes
gui:draw_text(x +  2,y +  16,"N1: " .. cps2notes[note1+1])
gui:draw_text(x +  2,y +  24,string.format("N2: %2X",note2))

gui:draw_text(x+ 36,y + 16,string.format("S1: %2X",setting1))
gui:draw_text(x+ 72,y + 16,string.format("S2: %2X",setting2))
gui:draw_text(x+ 36,y + 24,string.format("S3: %2X",setting3))

--Pan
pangraphic(x+48,y+4,pan)

end
--Dividers
gui:draw_line(x- 2,y+ 8,x+112,y+ 8,0xFFFFFFFF)
gui:draw_line(x+32,y+ 8,x+ 32,y+32,0xFFFFFFFF)
gui:draw_line(x- 2,y+16,x+112,y+16,0xFFFFFFFF)

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
mem:write_u8(addr + 0x0E,00)
mem:write_u8(addr + 0x20,00)
mem:write_u8(addr + 0x25,00)
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
