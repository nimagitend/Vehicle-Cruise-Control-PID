clear;
clc;

parameters;

F_t = 600;

tspan = [0 150];

v0 = 0;

model = @(t,v) vehicle_dynamics(t,v,rho,Cd,A,Crr,m,g,F_t);

[t,v] = ode45(model,tspan,v0);

v_kmh = v * 3.6;

figure;

plot(t,v_kmh,'LineWidth',1.5);

grid on;

xlabel('Time (s)');
ylabel('Vehicle Speed (km/h)');
title('Open-Loop Vehicle Response');

function dvdt = vehicle_dynamics(t,v,rho,Cd,A,Crr,m,g,F_t)

F_drag = 0.5 * rho * Cd * A * v^2;

F_rolling = Crr * m * g;

F_resistance = F_drag + F_rolling;

dvdt = (F_t - F_resistance) / m;

end
%% 