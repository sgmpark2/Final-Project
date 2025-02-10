clc;clear all; close all;
 
figure(2)
hold on
s = 30*1000; %focus distance [mm]
line([0 22],[s/1000 s/1000],'color',[1 0 0],'linewidth',1,'LineStyle', '--');
grid on
 
f = 16 %focal length [mm]
for i = 1:8;
    N = 3.5:1.85:22; %f number (aperture)
    c = 0.025; %circle of confusion [mm]
    
    H = (f.^2./(N.*c))+f %hyperfocal distance
    if i==1
        color = [0 0.4470 0.7410]
    end
    if i==2
        color = [0 1 0]
    end
    if i==3
        color = [0 0 1]
    end
    if i==4
        color = [0 1 1]
    end
    if i==5
        color = [1 0 1]
    end
    if i==6
        color = [1 1 0]
    end
    if i==7
        color = [0.4940 0.1840 0.5560]
    end
    if i==8
        color = [0.6350 0.0780 0.1840]
    end
 
    plot(N,H/1000, "-", 'Color', color,'LineWidth', 2);
    
    f = f + 5
    
end
 
ylim([0 40])
xlim([3.5 20])
xlabel('F No. (Aperture size)')
ylabel('Hyperfocal Distance(m)')
title('Graph showing Hyperfocal Distance against Aperture size')
legend('Minimum Flight Distance','16mm','21mm','26mm','31mm','36mm','41mm','46mm','51mm');