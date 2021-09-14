sr = 44100
ksmps = 32
nchnls = 2

#include "reflon.orc"

gSinf = "r.wav"

event_i "i", 1, 2, -1

gi_env2amt 	ftgen 0,0,16384,-7,0,8192,0,8192,0
gi_distribution	ftgen 0,0,16384,-7,0,8192,0,8192,0
gi_wavfreq 	ftgen 0,0,16384,-7,.5,8192,.5,8192,.5
gi_randommask 	ftgen 0,0,16384,-7,0,8192,0,8192,0
gi_sweepshape 	ftgen 0,0,16384,-7,.05,8192,.95,8192,.05
gi_a_d_ratio 	ftgen 0,0,16384,-7,.5,8192,.5,8192,.5
gi_sustain_amount ftgen 0,0,16384,-7,0.75,8192,.75,8192,0.75
gi_duration 	ftgen 0,0,16384,-7,1000*32768/sr,16384,1000*32768/sr
gi_amp	 	ftgen 0,0,16384,-7,1,16384,1
gi_numpartials 	ftgen 0,0,16384,-7,2,8192,12,8192,120
gi_chroma 	ftgen 0,0,16384,-7,.5,8192,1.5,8192,0.5
gi_grainfreq	ftgen 0,0,16384,-7,8,8192,8,8192,8
gi_traincps	ftgen 0,0,16384,-7,440,8192,220,8192,440

gi_gain_msk	ftgen 0,0,4,-2,	0,1,	1,1
gi_wfs_msk	ftgen 0,0,16,-2,	0,4,	1,1,1,1,1,1
gi_wfe_msk	ftgen 0,0,16,-2,	0,5,	1,1,1,1,1,1
gi_fma_msk	ftgen 0,0,4,-2,	0,1,	0,0
gi_chn_msk	ftgen 0,0,16,-2,0,4,	0,2,1,3,4
gi_wva_msk	ftgen 0,0,16,-2,0,0, 	1,1,1,1,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0

gifnL	ftgen	0,0,0,1, gSinf, 0, 0, 1 ;left

instr 1

ilen = ftlen(gifnL)/sr

ienvs[] 	fillarray gi_env2amt, gi_distribution, gi_wavfreq, gi_randommask, gi_sweepshape, gi_a_d_ratio, gi_sustain_amount, gi_duration, gi_amp, gi_numpartials, gi_chroma, gi_grainfreq, gi_traincps
imsks[] 	fillarray gi_gain_msk, gi_wfs_msk, gi_wfe_msk, gi_fma_msk, gi_chn_msk, gi_wva_msk
kfrms[] 	fillarray gifnL, gifnL, gifnL, gifnL, gifnL
aposs[] 	init 32
aposs[0] randomi 0, .25, .3
aposs[1] randomi .25, .5, .3
aposs[2] randomi .5, .75, .3
aposs[3] randomi .75, .95, .3
kkeys[] 	fillarray 1/23,1/23,1/23,1/23

aenv lfo 1, 1/20, 1

ares[], ires Reflon ienvs,aenv,imsks,kfrms,aposs,kkeys
kchan partikkelget 4, ires
ares[0] = tanh(ares[0]*db(1.8))
ares[1] = tanh(ares[1]*db(1.8))
ares[0] exciter ares[0], 270, 13210, 10, 10
ares[1] exciter ares[1], 270, 13210, 10, 10
aL tvconv ares[0], ares[2], 1, 1, 64, 32768
aR tvconv ares[1], ares[3], 1, 1, 64, 32768
aL dcblock aL*ampdbfs(57.0)
aR dcblock aR*ampdbfs(57.0)
aL limit aL, -ampdbfs(0), ampdbfs(0)
aR limit aR, -ampdbfs(0), ampdbfs(0)
outs aL, aR
endin
