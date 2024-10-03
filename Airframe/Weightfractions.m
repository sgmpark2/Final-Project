% Weight Fractions estimation 

% Weight fractions
W_camera=0.269;
W_gimble=;
W_empty=;
W_battery=;

%avionics
W_pix=0.0158;
W_motor=;
W_esc=;
W_receiver=;
W_Transm=;
W_prop=;
W_wiring=;

W_p=W_camera+W_Gimble;
W_avionics=W_pix+4*W_motor+4*W_esc+W_receiver+W_Transm+4*W_prop+W_wiring;

%Empty weight fraction
W_ef=;
%Battery weight fraction
W_bf=;


W_to=(W_avionics+W_payload)/(1-(W_ef)-(W_bf)) 