declare name        "tester";
declare version     "1.0";
declare author      "Grame";
declare license     "BSD";
declare copyright   "(c) GRAME 2006";

//-----------------------------------------------
// Audio tester : send a sinus to a loudspeaker
//-----------------------------------------------

import("music.lib");

pink    = f : (+ ~ g) with {
    f(x)    = 0.04957526213389*x - 0.06305581334498*x' +
          0.01483220320740*x'';
    g(x)    = 1.80116083982126*x - 0.80257737639225*x';
};


// User interface
//----------------
smooth(c)       = *(1-c) : +~*(c);
vol             = hslider("2-volume", -96, -96, 0, 0.1): db2linear : smooth(0.999);
freq            = hslider("1-freq", 1000, 0, 24000, 0.1);
dest            = rint(hslider("3-destination", 1, 1, 50, 1));

testsignal      = _*checkbox("input")
		+ osci(freq)*checkbox("sine wave")
                + noise * checkbox("white noise")
                + pink(noise) * db2linear(20)  * checkbox("pink noise");

process         = vgroup( "Audio Tester", testsignal*vol <: par(i,50, _*((i+1)==dest)) );
//process         = hgroup("Audio Tester",vgroup( "Parameters", testsignal*vol) <: vgroup("Channels",par(i,50,_*button("%2i"))));