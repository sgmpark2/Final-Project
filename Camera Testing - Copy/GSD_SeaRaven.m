clc; clear all; close all
 
%%
 
figure(1)
hold on
line([30 30],[0 3.5],'color',[1 0 0],'linewidth',1,'LineStyle', '--');
line([0 120],[0.8 0.8],'color',[1 0 0],'linewidth',1,'LineStyle', '--');
title('GSD Height against Distance from Cliff with Varying Focal Distance');
xlabel('Distance from cliff [m]');
ylabel('GSD [cm/px]');
grid on
 
F_l = 16;                    %Inital Focal Length (mm)
 
for i = 1:8;
    Sh = 15.6;                     %Sensor Height (mm)
    Sw = 23.5;                     %Sensor Width (mm)
    Iw = 5456;                     %Image Width (px)
    Ih = 3632;                     %Image Height (px)
    Fh = 0:15:120;
    GSD_h = (Fh*100*Sh)./(F_l*Ih);
    
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
 
    plot(Fh,GSD_h, "-", 'Color', color,'LineWidth', 2);
 
    F_l = F_l + 5
    
end
legend('','','16mm','21mm','26mm','31mm','36mm','41mm','46mm','51mm');
%%
 
figure(2)
hold on
line([30 30],[0 3.5],'color',[1 0 0],'linewidth',1,'LineStyle', '--');
line([0 120],[0.8 0.8],'color',[1 0 0],'linewidth',1,'LineStyle', '--');
title('GSD Width against Distance from Cliff with Varying Focal Distance');
xlabel('Distance from cliff [m]');
ylabel('GSD [cm/px]');
grid on
 
F_l = 16;                    %Inital Focal Length (mm)
 
for i = 1:8;
    Sh = 15.6;                     %Sensor Height (mm)
    Sw = 23.5;                     %Sensor Width (mm)
    Iw = 5456;                     %Image Width (px)
    Ih = 3632;                     %Image Height (px)
    Fh = 0:15:120;
    GSD_w = (Fh*100*Sw)./(F_l*Iw);
    
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
 
    plot(Fh,GSD_w, "-", 'Color', color,'LineWidth', 2);
 
 
    F_l = F_l + 5
    
end
legend('','','16mm','21mm','26mm','31mm','36mm','41mm','46mm','51mm');

%%
%%Real calculations

FL = [1.6,3.2,5];
GSDw = (300*2.32)./(FL*5456);
GSDh = (300*1.54)./(FL*3632);