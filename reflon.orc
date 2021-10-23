gi_Rfl_sin ftgen 0,0,16384,10,1
gi_Rfl_cos ftgen 0,0,16384,11,1

gi_Rfl_atk ftgen 0,0,16385,-19,0.5,0.5,270,0.5
gi_Rfl_rel ftgen 0,0,16385,-19,0.5,0.5,90,0.5

gi_Rfl_dec ftgen 0,0,16385,-5,1,16385,0.01

gi_Rfl_uni ftgen 0,0,16385,-7,1,16385,1

gi_Rfl_ids ftgen 0,0,16385,-2,0 ;empty list of opcode ids

 opcode Reflon_new_id, i, 0
icount = 0
searching:
if (table:i(icount, gi_Rfl_ids, 0))!=0 then
icount += 1
igoto searching
else
tablew icount+1, icount, gi_Rfl_ids
iopcode_id = icount+1
endif
xout iopcode_id
 endop

 opcode Reflon, a[]i, i[]ai[]k[]a[]k[]
ienvs[], aenv_phase, imsks[], kfrms[], aposs[], kkeys[] xin

kenv_phase = k(aenv_phase)
iopcode_id Reflon_new_id

;initialized
idisttab 	= -1 ;not used
ienv2tab 	= gi_Rfl_uni
ienv_attack 	= gi_Rfl_atk
ienv_decay 	= gi_Rfl_rel
icosine 	= gi_Rfl_cos
kfmenv 		init gi_Rfl_dec
;table-based parameter control
kenv2amt 	table (kenv_phase), ienvs[0], 1, 0, 1
kdistribution 	table (kenv_phase), ienvs[1], 1, 0, 1
kwavfreq 	table (kenv_phase), ienvs[2], 1, 0, 1
krandommask 	table (kenv_phase), ienvs[3], 1, 0, 1
ksweepshape 	table (kenv_phase), ienvs[4], 1, 0, 1
ka_d_ratio 	table (kenv_phase), ienvs[5], 1, 0, 1
ksustain_amount table (kenv_phase), ienvs[6], 1, 0, 1
kduration 	table (kenv_phase), ienvs[7], 1, 0, 1
kamp 		table (kenv_phase), ienvs[8], 1, 0, 1
knumpartials 	table (kenv_phase), ienvs[9], 1, 0, 1
kchroma 	table (kenv_phase), ienvs[10], 1, 0, 1
agrainfreq	table (aenv_phase), ienvs[11], 1, 0, 1
ktraincps	table (kenv_phase), ienvs[12], 1, 0, 1
;printk2 ktraincps

;array-based parameter control

igainmasks 	= imsks[0]
iwavfreqstarttab = imsks[1]
iwavfreqendtab 	= imsks[2]
ifmamptab 	= imsks[3]
ichannelmasks 	= imsks[4]
iwaveamptab	= imsks[5]
;print iwaveamptab

kwaveform1 = kfrms[0]
kwaveform2 = kfrms[1]
kwaveform3 = kfrms[2]
kwaveform4 = kfrms[3]
;printk 1, kwaveform4

asamplepos1 = aposs[0]
asamplepos2 = aposs[1]
asamplepos3 = aposs[2]
asamplepos4 = aposs[3]
;printk 1, k(asamplepos4)


kwavekey1 = kkeys[0]
kwavekey2 = kkeys[1]
kwavekey3 = kkeys[2]
kwavekey4 = kkeys[3]

;printk 1, kwavekey4

;audio-rate grain-FM modulator
awavfm oscil 2/3, 20

;audio-rate grain-density (fundamental) modulator
;agrainfreq = 16*octave(agrainfreq)

;audio-rate sync input (when nonzero, triggers new grain)
async init 0; gausstrig 1, .9, 0.95

anew[] init 8
a1,a2,a3,a4,a5,a6,a7,a8 partikkel agrainfreq, \
              kdistribution, idisttab, async, kenv2amt, ienv2tab, ienv_attack, \
              ienv_decay, ksustain_amount, ka_d_ratio, kduration, kamp, igainmasks, \
              kwavfreq, ksweepshape, iwavfreqstarttab, iwavfreqendtab, awavfm, \
              ifmamptab, kfmenv, icosine, ktraincps, knumpartials, kchroma, \
              ichannelmasks, krandommask, kwaveform1, kwaveform2, kwaveform3, \
              kwaveform4, iwaveamptab, asamplepos1, asamplepos2, asamplepos3, \
              asamplepos4, kwavekey1, kwavekey2, kwavekey3, kwavekey4, 2048, iopcode_id
anew[0] = a1
anew[1] = a2
anew[2] = a3
anew[3] = a4
anew[4] = a5
anew[5] = a6
anew[6] = a7
anew[7] = a8
xout anew, iopcode_id
 endop
