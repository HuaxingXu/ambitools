declare name        "HOA encoder up to order 5";
declare version     "1.0";
declare author      "Pierre Lecomte";
declare license     "GPL";
declare copyright   "(c) Pierre Lecomte 2014";

// HOA encoder up to order 5 for spherical wave or plane wave
//[1] Lecomte, P., & Gauthier, P.-A. (2015). Real-Time 3D Ambisonics using Faust, Processing, Pure Data, And OSC. In 15th International Conference on Digital Audio Effects (DAFx-15). Trondheim, Norway.

import("lib/nfc.lib");
import("lib/ymn.lib");

// Spherical restitution speaker layout radius r2 is needeed to stabilize near-field filters, see [1]
r2 = nentry("[6]Speakers Radius", 1.07, 0.5, 10, 0.01);
spherical=vgroup("[2]Spherical Wave Encoding",checkbox("Yes"));
r1 = vslider("[5]Source Radius", 2, 0.5, 10, 0.01);

vmeter(x)		= attach(x, envelop(x) : vbargraph("[unit:dB]",-70, 6));
envelop			= abs : max(db2linear(-70)) : linear2db : min(6)  : max ~ -(80.0/SR);

id(x,delta) =  vgroup("%2a",vmeter) with{
a = x+1+delta;};

meterm(m) = par(i,2*m+1,hgroup("%m",id(i,m*m-1)));

theta=vslider("[3]Source Azimuth", 0, 0, 360, 0.1)*PI/180;
delta=vslider("[4]Source Elevation", 0, -90, 90, 0.1)*PI/180;

// Volume controller
smooth(c)       = *(1-c) : +~*(c);
vol             = hslider("[1]Gain[style:knob][unit:dB]", 0, -20, 20, 0.1) : db2linear : smooth(0.999);

// This gain is introduced here to have the correct gain of the virtual source, defined at its position, not at origin, see [1]
gain=r2/r1;

process=hgroup("Parameters",_<:(*(spherical)*(vol),*(1-spherical)*(vol)):((*(gain)<:(nf0<:bus(1)),(nf1(r1,r2)<:bus(3)),(nf2(r1,r2)<:bus(5)),(nf3(r1,r2)<:bus(7)),(nf4(r1,r2)<:bus(9)),(nf5(r1,r2)<:bus(11))),(_<:bus(36))):>ytot(theta,delta)):vgroup("B-Format",hgroup("0-3",meterm(0),meterm(1),meterm(2),meterm(3)),hgroup("4-5",meterm(4),meterm(5)));