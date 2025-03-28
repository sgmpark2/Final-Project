clear
close all
%code to determine optimal focal length and number of images required
%29/01/20
 
%input parameters
f_length=[16,24,32,40,50]; %camera focal lenght (mm)
s_height = 15.4; %sensor hight (mm)
s_width = 23.2; %sensor width (mm)
i_height = 3632; %maximum image height (px)
i_width = 5456; %maximum image width (px)
max_n = 420; %maximum number of images that can be stored
a_height = 73; %height of area of interest (m)
a_width = 730; %width of area of interest (m)
f_start = 413; %distance from launch point to start of mission (m)
f_end = 140; %distance form mission end point to landing point (m)
V = (1:1:20); %range of flight speeds (m/s)
altitude = (0:10:120); %range of flight altitudes up to maximim allowable (m)
overlap = 0.70; %required image overlap
 
%field of view calulations
AoV_height = 2*atand(s_height./(2.*f_length)); %angle of view in height direction (deg)
LFoV_height = 2.*tand(AoV_height./2).*(altitude.'); %field of view in height direction (m)
AoV_width = 2*atand(s_width./(2.*f_length)); %angle of view in width direction (deg)
LFoV_width = 2.*tand(AoV_width./2).*(altitude.'); %field of view in width direction (m)
 
%plot FoV graphs
figure(1)
for i = 1:length(f_length)
    plot(altitude,LFoV_height(:,i))
    hold on
end
li1=line([30 30],[0 140]);
set(li1,'color','k','linestyle','--')
    title('Height field of view against perpendicular distance from cliff')
    ylabel('Field of view (m)')
    xlabel('distance from cliff (m)')
    legend('16mm','24mm','32mm','40mm','50mm','location','northwest')
    txt = 'min distance';
    text(28,100,txt,'Rotation',90)
 
 
figure (2)
for i = 1:length(f_length)
    plot(altitude,LFoV_width(:,i))
    hold on
end
li2=line([30 30],[0 200]);
set(li2,'color','k','linestyle','--')
    title('Width field of view against perpendicular distance from cliff')
    ylabel('Field of view (m)')
    xlabel('distance from cliff (m)')
    legend('16mm','24mm','32mm','40mm','50mm','location','northwest')
    txt = 'min distance';
    text(28,140,txt,'Rotation',90)
 
%GSD calulations
GSD_height = ((1000.*altitude.*s_height)./((f_length.*i_height).')).*0.1; 
GSD_width = ((1000.*altitude.*s_width)./((f_length.*i_width).')).*0.1; 
 
%plot GSD graphs
figure(3)
for i = 1:length(f_length)
    plot(altitude,GSD_height(i,:))
    hold on
end
li3=line([0 120],[0.82 0.82]);
li4=line([30 30],[0 3.5]);
patch([30 120 120 30],[0 0 0.82 0.82],"g",'FaceAlpha', 0.2)
set([li3 li4],'color','k','linestyle','--')
plot(altitude(4:7),GSD_height(3,4:7),LineStyle="--",Color='red',LineWidth=3)
    title('Height GSD against perpendicular distance from cliff')
    ylabel('GSD (px)')
    xlabel('distance from cliff (m)')
    legend('16mm','24mm','32mm','40mm','50mm','','','','Planned Range','location','northwest')
    txt1 = 'min distance';
    text(28,1.5,txt1,'Rotation',90)
    txt2 = 'max GSD';
    text(10,0.9,txt2)
    
figure(4)
for i = 1:length(f_length)
    plot(altitude,GSD_width(i,:))
    hold on
end
li5=line([0 120],[0.82 0.82]);
li6=line([30 30],[0 3.5]);
patch([30 120 120 30],[0 0 0.82 0.82],"g",'FaceAlpha', 0.2)
set([li5 li6],'color','k','linestyle','--')
plot(altitude(4:7),GSD_width(3,4:7),LineStyle="--",Color='red',LineWidth=3)
    title('Width GSD against perpendicular distance from cliff')
    ylabel('GSD (px)')
    xlabel('Altitude (m)')
    legend('16mm','24mm','32mm','40mm','50mm','','','','Planned Range','location','northwest')
    txt1 = 'min distance';
    text(28,1.5,txt1,'Rotation',90)
    txt2 = 'max GSD';
    text(10,0.9,txt2)
    
    
 %number of pictures required calulations
 N_height = ceil((a_height)./(LFoV_height - (LFoV_height.*(overlap/2))));
 N_width = ceil((a_width)./(LFoV_width - (LFoV_width.*(overlap/2))));
 N_total = N_height.*N_width;
 
 %plot number of images graph
 figure (5)
for i = 1:length(f_length)
    plot(altitude(4:end),N_total(4:end,i))
    hold on
end
li7=line([30 120],[420 420]);
set(li7,'color','k','linestyle','--')
plot(altitude(4:7),N_total(4:7,3),LineStyle="--",Color='red',LineWidth=3)
    title('Number of images required against perpendicular distance from cliff')
    ylabel('number of images')
    xlabel('distance from cliff (m)')
    legend('16mm','24mm','32mm','40mm','50mm','','Planned Range','location','northwest')
    txt = 'max storage';
    text(80,460,txt)
