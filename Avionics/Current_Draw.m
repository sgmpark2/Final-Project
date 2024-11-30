Tmotor_Throttle = table([20;40;60;80;100],[25.2;25.2;25.5;24.9;24.7],[1.6;5.1;10.3;20.6;35.8],[204.4;586.0;1016.9;1684.7;2470]);
Tmotor_Throttle.Properties.VariableNames = {'Throttle','Voltage','Current','Thrust'};


px6Current = 0.175;
gpsCurrent = 0.055;
telemCurrent = 0.035;
stormCurrent = 0.2;
fpvCurrent = 0.5;
seagulCurrent = 0.02175;
AvionicsCurrent = px6Current + gpsCurrent + telemCurrent + stormCurrent + fpvCurrent+ seagulCurrent ;

TotalMass = 3700;

TotalMotorCurrent = interp1(Tmotor_Throttle.Thrust,Tmotor_Throttle.Current,(TotalMass/4)) * 4;

TotalCurrent = AvionicsCurrent + TotalMotorCurrent;

Time = 0.1;     %Time in hours

CurrentDraw = TotalCurrent * Time * 1000;

BatteryCapacity = 6000;

BatteryPercentage = ((BatteryCapacity - CurrentDraw) / BatteryCapacity) * 100