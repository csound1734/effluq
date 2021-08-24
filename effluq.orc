gi_Efl_sin ftgen 0,0,16384,10,1
gi_Efl_cos ftgen 0,0,16384,11,1

gi_Efl_atk ftgen 0,0,16385,-19,0.5,0.5,270,0.5
gi_Efl_rel ftgen 0,0,16385,-19,0.5,0.5,90,0.5

gi_Efl_dec ftgen 0,0,16385,-5,1,16385,0.01

gi_Efl_ids ftgen 0,0,16385,-2,0 ;empty list of opcode ids

 opcode Effluq_new_id, i, 0
icount = 0
searching:
if (table:i(icount, gi_Efl_ids, 0))!=0 then
icount += 1
igoto searching
else
tablew icount+1, icount, gi_Efl_ids
iopcode_id = icount+1
endif
xout iopcode_id
 endop

 opcode Effluq, a[]i, ki[]k[]a[]k[]
kwavfreq, imsks[], kfrms[], aposs[], kkeys[] xin

iopcode_id Effluq_new_id

;unused parameters
idisttab = -1 ;not used
ienv2tab = gi_Efl_dec
kenv2amt init 0.25 ;turned off
kdistribution init 0
async init 0 ;no sync

;initialized
ienv_attack = gi_Efl_atk
ienv_decay = gi_Efl_rel
icosine = gi_Efl_cos
krandommask init 0
kfmenv init gi_Efl_dec ;who knows
ksweepshape init .15
ka_d_ratio init .25
ksustain_amount init 0
kduration init 80
kamp init 1
knumpartials init 40
kchroma init 0.97

;array-based parameter control

igainmasks 	= imsks[0]
iwavfreqstarttab = imsks[1]
iwavfreqendtab 	= imsks[2]
ifmamptab 	= imsks[3]
ichannelmasks 	= imsks[4]
iwaveamptab	= imsks[5]

kwaveform1 = kfrms[0]
kwaveform2 = kfrms[1]
kwaveform3 = kfrms[2]
kwaveform4 = kfrms[3]

asamplepos1 = aposs[0]
asamplepos2 = aposs[1]
asamplepos3 = aposs[2]
asamplepos4 = aposs[3]

kwavekey1 = kkeys[0]
kwavekey2 = kkeys[1]
kwavekey3 = kkeys[2]
kwavekey4 = kkeys[3]
ktraincps = kwavfreq

;audio-rate grain-FM modulator
awavfm oscil 2/3, kwavfreq

;audio-rate grain-density (fundamental) modulator
agrainfreq = 0.0
;agrainfreq = 16*octave(agrainfreq)

;audio-rate sync input (when nonzero, triggers new grain)
async gausstrig 1, .9, 0.95

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
