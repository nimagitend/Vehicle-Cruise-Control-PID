clear;
clc;

parameters;

v_ref = 100;

tspan = [0 1000];

x0 = [0; 0];

v_ref_ms = v_ref / 3.6;

Ki = 0.5;
Kp = 20;

model = @(t,x) vehicle_dynamics(t,x,rho,Cd,A,Crr,m,g,Kp,Ki,v_ref_ms);

[t,x] = ode45(model,tspan,x0);

v = x(:,1);

v_kmh = v * 3.6;

figure;

plot(t,v_kmh,'LineWidth',1.5);

grid on;

xlabel('Time (s)');
ylabel('Vehicle Speed (km/h)');
title('PI Cruise Control Response');

function dxdt = vehicle_dynamics(t,x,rho,Cd,A,Crr,m,g,Kp,Ki,v_ref_ms)

dxdt = zeros(2,1);

v = x(1);
integral_error = x(2);

e = v_ref_ms - v;

F_t = Kp * e + Ki * integral_error;

F_drag = 1/2 * rho * Cd * A * v^2;

F_rolling = Crr * m * g;

F_resistance = F_drag + F_rolling;

dxdt(1) = (F_t - F_resistance) / m;

dxdt(2) = e;

end