
%andmete laadimine, deal() annab vastavatele muutujatele andmepunkti
data = load('venus_orbit.dat');
[t, x, y, vx, vy, ek, ep, et] = deal(data(:,1), data(:,2), data(:,3), ...
    data(:,4), data(:,5), data(:,6), data(:,7), data(:,8));

%kindla suurusega graafikud/aknad (et ilusam graafik saada)
figure('Position', [100 100 1200 300]);

%esimene graafik - trajektoor/koordinaadid
subplot(1,3,1);
plot(x, y, 'b'); %andmed mida graafik kasutab
grid on; 
axis equal;
xlabel('x (km)'); %kirjeldused
ylabel('y (km)');
title('Trajektoor'); 

%teine graafik - kiirused x, y teljel
subplot(1,3,2); 
plot(t, vx, 'r', t, vy, 'b'); %andmed mida graafik kasutab
grid on;
xlabel('Aeg (s)'); %kirjeldused
ylabel('Kiirus(ed) (km/s)'); 
title('Telgedel kiirused');
legend('v_x', 'v_y');

%kolmas graafik - energiad
subplot(1,3,3); 
plot(t, ek, 'g', t, ep, 'r', t, et, 'b'); %andmed mida graafik kasutab
grid on;
xlabel('Aeg (s)'); %kirjeldused
ylabel('Energia (J)');
title('Energiad');
legend('Kin. energia', 'Pot. energia', 'Koguenergia');