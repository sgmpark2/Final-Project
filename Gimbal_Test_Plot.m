clear, close all

Data = readtable("Full_Test2.dat");

figure(1)
subplot(3,1,1)
hold on
grid on
plot(Data.Time/1000,Data.Pitch2/100)
plot(Data.Time/1000,Data.Pitch/100)
title("Pitch")
xlabel("Time (Seconds)")
ylabel("Pitch Angle (Degrees)")
legend("Airframe Pitch", "Camera Pitch")

subplot(3,1,2)
hold on
grid on
plot(Data.Time/1000,Data.Roll2/100)
plot(Data.Time/1000,Data.Roll/100)
title("Roll")
xlabel("Time (Seconds)")
ylabel("Roll Angle (Degrees)")
legend("Airframe Roll", "Camera Roll")

subplot(3,1,3)
hold on
grid on
plot(Data.Time/1000,Data.Yaw2/100)
plot(Data.Time/1000,Data.Yaw/100)
title("Yaw")
xlabel("Time (Seconds)")
ylabel("Yaw Angle (Degrees)")
legend("Airframe Yaw", "Camera Yaw")