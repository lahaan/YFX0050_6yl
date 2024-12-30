implicit none

!rkf45 asjad , work(x) kus x = 3+6*neqn, teised vajalikud muutujad
real work(27), y(4), m_venus, m_obj, r_venus, a(4), i, dt
real relerr, abserr, tout, t, G, gm, ekin, epot, etot
integer iwork(5), iflag, neqn, nt
common gm
external func

open(10, file="venus_orbit.dat") !fail kuhu kirjutame

relerr = 1.e-7		!relatiivne error tolerants
abserr = 1.e-7		!absoluutne error tolerants
m_venus = 4.867e+24	!veenuse mass    (kg)
m_obj = 1000.		!objekti mass 	 (kg)
r_venus = 6052.		!veenuse raadius (km)
G = 6.67408e-11		!gravitatsiooni konstant (m^3*kg^-1*s^-2)
gm = G * m_venus * 1.e-9 ! kuna GM on meetrites, korrutan 1.e-9'ga 	

t = 0.
y(1) = r_venus + 200.  !algne x-koordinaat (raadius + 200 km)
y(2) = 0.              !algne y-koordinaat	(km)
y(3) = 0.              !algne x-teljel kiirus
y(4) = sqrt(gm / y(1)) !algne y-teljel kiirus (1. kosmiline kiirus)
nt = 100000			   !mitu korda kordab (n)
dt = 1.

t = 0.				   !eraldi muutuja
iflag = 1			   !integratsiooni flag
neqn = 4			   !mitu integratsiooni tehakse

!main loop
do i = 1, nt
    tout = t + dt
    !rkf45 välja kutsumine
    call rkf45(func, neqn, y, t, tout, relerr, abserr, iflag, work, iwork)
    iflag = 2
    
    !kineetiline, potetsiaalne, koguenergia arvutamine
    ekin = 0.5 * m_obj * (sqrt(y(3)**2 + y(4)**2))**2 * 1.e6
    epot = -G * m_obj * m_venus * 1.e-3 / (sqrt(y(1)**2 + y(2)**2))
    etot = ekin + epot	
	
	!differentsiaali(de) funktsioon
    call func(t, y, a)
    
    !välja printimine - 8 asja prindin, 15 nr pikkus, 5 kohta peale koma
    write(10, '(8e15.5)') tout, y, ekin, epot, etot
enddo

stop
end

!funktsioon tuletiste lahendamiseks
subroutine func(t, y, dy)
implicit none
real y(4), dy(4), t, gm
common gm
dy(1) = y(3)	!x'=vx
dy(2) = y(4)	!y'=vy
dy(3) = -gm * y(1) / sqrt(y(1)**2 + y(2)**2)**3	!vx'=ax
dy(4) = -gm * y(2) / sqrt(y(1)**2 + y(2)**2)**3	!vy'=ay
return
end
