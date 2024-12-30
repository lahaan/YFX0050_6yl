
global gm
m_venus = 4.867e+24; %veenuse mass(kg)
m_obj = 1000; %keha mass(kg)
r_venus = 6052; %veenuse raadius (km)
G = 6.67408e-11; %gravitatsiooni konstant(m^3*kg^-1*s^-2)
gm = G * m_venus * 1.e-9; %GM aga km^3/s^2

t0 = 0;
y0 = [r_venus + 200; 0; 0; sqrt(gm / (r_venus + 200))]; % [x, y, vx, vy]
tspan = [t0, 100000]; % mitu korda teeb

%funktsioon tuletisteks
function dy = func(t, y)
    global gm
    dy = zeros(4,1);
    dy(1) = y(3); % x' = vx
    dy(2) = y(4); % y' = vy
    dy(3) = -gm * y(1) / (sqrt(y(1)^2 + y(2)^2)^3); % vx' = ax
    dy(4) = -gm * y(2) / (sqrt(y(1)^2 + y(2)^2)^3); % vy' = ay
end

%tihedamad tolerantsid, muidu hakkab orbiidist kaugele vajuma kui 1*VI
options = odeset('RelTol',1e-7,'AbsTol',1e-7); 
[t, y] = ode45(@func, tspan, y0, options); %ode45, rkf45 aga matlabis

%tulemuste kätte saamine
x = y(:,1);
y_coord = y(:,2);
vx = y(:,3);
vy = y(:,4);

%energiate kalkulatsioonid
ekin = 0.5 * m_obj * (sqrt(vx.^2 + vy.^2)).^2 * 1.e6;
epot = -G * m_obj * m_venus * 1.e-3 ./ sqrt(x.^2 + y_coord.^2);
etot = ekin + epot;

%graafikud (identne sellega mis fortrani visualiseerib)
figure('Position', [100 100 1200 300]);

subplot(1,3,1);
plot(x, y_coord, 'b'); grid on; axis equal;
xlabel('x (km)'); ylabel('y (km)'); title('Trajektoor');

subplot(1,3,2);
plot(t, vx, 'r', t, vy, 'b'); grid on;
xlabel('Aeg (s)'); ylabel('Kiirus(ed) (km/s)');
title('Telgedel kiirused'); legend('v_x', 'v_y');

subplot(1,3,3);
plot(t, ekin, 'g', t, epot, 'r', t, etot, 'b'); grid on;
xlabel('Aeg (s)'); ylabel('Energia (J)');
title('Energiad'); legend('Kin. energia', 'Pot. energia', 'Koguenergia');
