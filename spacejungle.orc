
sr = 44100
ksmps = 32
nchnls = 2

 opcode print_a, i, a
ain xin
setksmps 1
kin downsamp (ain)
if (kin)!=0 then
printk kr, kin
endif
xout (0)
 endop

#include "effluq.orc"

event_i "i", 17, 0, -1

gares[] init 16

gi_gain_t ftgen 0,0,17,-2,0,1, db(4.5), db(0)
gi_chan_t ftgen 0,0,17,-2,0,9, 0, 2.5, 3, 2.5, 3, 2.5, 3, 2.5, 2.5, 3
gi_wfst_t ftgen 0,0,17,-2,0,3, 1, 2, 3, 4, 5
gi_west_t ftgen 0,0,17,-2,0,1, 1,1
gi_fmam_t ftgen 0,0,17,-2,0,4, 0.1, 0.4, 0.8, 1.3, 1.5, 0.4, 0.2, 0.0
gi_wvam_t ftgen 0,0,64,-2,0,3, 1,1,0,0,0, 0,1,0,1,0, 1,0,1,0,0, 0,0,1,1,0

 instr 17
imsks[] init 16
imsks[0] = gi_gain_t
imsks[1] = gi_wfst_t
imsks[2] = gi_west_t
imsks[3] = gi_fmam_t
imsks[4] = gi_chan_t
imsks[5] = gi_wvam_t
kkeys[] init 16
ipchs[] init 16
ipchs[0] = semitone(3)
ipchs[1] = semitone(17)
ipchs[2] = semitone(7)
ipchs[3] = 1
aposs[] init 16
kwavs[] init 16
kwavs[0] init gi_Efl_sin
kwavs[1] init gi_Efl_sin
kwavs[2] init gi_Efl_sin
kwavs[3] init gi_Efl_sin
kwavfreq init cpspch(8.06)

;lfo
klfo oscil 1, .2, -1, 0.25
klfo = semitone(klfo*5+5)
kcount = 0
transposekeys:
if kcount<4 then
kkeys[kcount] = ipchs[kcount]*klfo
kcount += 1
kgoto transposekeys
endif

ares[], iid Effluq kwavfreq, imsks, kwavs, aposs, kkeys
gares = ares

print iid
a1, aphase partikkelsync iid
kres partikkelget 1, iid
;printk2 kres
;output channels pt1

achn0 = gares[0]*ampdbfs(-29)
achn0 buthp achn0, 50
achn0 waveset achn0, 28
outs achn0, achn0

achn2 = gares[2]*ampdbfs(-29)
achn3 buthp achn2, 50
achn4 waveset achn2, 19
outs achn2, achn2

achn3 = gares[3]*ampdbfs(-29)
achn3 buthp achn3, 50
achn3 waveset achn3, 5
adel3l comb achn3, 3.0, 1.25
adel3r comb delay(adel3l,1.25/2), 3.0, 1.25
arev nreverb -achn3-adel3l-adel3r, 17.0, 0.89
outs achn3+adel3l+arev, achn3+adel3r-arev

 endin


