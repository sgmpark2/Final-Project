clear, close all

Data = readtable("Full_Test2.dat");

figure(1)
subplot(3,1,1)
hold on
grid on
marker = plot([0 45],[0 0],"Color","Black",LineStyle="-.");
body = plot(Data.Time/1000,Data.Pitch2/100,"Color","Blue",LineWidth=1.5);
cam = plot(Data.Time/1000,Data.Pitch/100,"Color","Red",LineWidth=1.5);
title("Pitch")
xlabel("Time (Seconds)")
ylabel("Pitch Angle (Degrees)")
ylim([-22.5 22.5])

h = [body cam];
l = ["Airframe Pitch" "Camera Pitch"];
legend(h, l)

subplot(3,1,2)
hold on
grid on
marker = plot([0 45],[0 0],"Color","Black",LineStyle="-.");
body = plot(Data.Time/1000,Data.Roll2/100,"Color","Blue",LineWidth=1.5);
cam = plot(Data.Time/1000,Data.Roll/100,"Color","Red",LineWidth=1.5);
title("Roll")
xlabel("Time (Seconds)")
ylabel("Roll Angle (Degrees)")
ylim([-20 20])

h = [body cam];
l = ["Airframe Pitch" "Camera Pitch"];
legend(h, l)

subplot(3,1,3)
hold on
grid on
marker = plot([0 45],[0 0],"Color","Black",LineStyle="-.");
body = plot(Data.Time/1000,Data.Yaw2/100,"Color","Blue",LineWidth=1.5);
cam = plot(Data.Time/1000,Data.Yaw/100,"Color","Red",LineWidth=1.5);
title("Yaw")
xlabel("Time (Seconds)")
ylabel("Yaw Angle (Degrees)")
ylim([-40 40])

h = [body cam];
l = ["Airframe Pitch" "Camera Pitch"];
legend(h, l)