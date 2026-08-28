clear;

clc;

parameters;

v_ref = 100 / 3.6;

Kp = 20;

Ki = 0.5;

Kd = 5;

tspan = [0 1000];

x0 = [0; 0];

model = @(t,x) cruise_dynamics( ...
    t,x,rho,Cd,A,Crr,m,g,Kp,Ki,Kd,v_ref);

[t,x] = ode45(model,tspan,x0);

v = x(:,1);

v_kmh = v * 3.6;

figure;

plot(t,v_kmh,'LineWidth',1.5);

grid on;

xlabel('Time (s)');

ylabel('Vehicle Speed (km/h)');

title('PID Cruise Control Response');

function dxdt = cruise_dynamics( ...
    t,x,rho,Cd,A,Crr,m,g,Kp,Ki,Kd,v_ref)

dxdt = zeros(2,1);

v = x(1);

integral_error = x(2);

e = v_ref - v;

F_drag = 0.5 * rho * Cd * A * v^2;

F_rolling = Crr * m * g;

F_resistance = F_drag + F_rolling;

F_PI = Kp * e + Ki * integral_error;

F_t = (F_PI + Kd * F_resistance / m) / ...
      (1 + Kd / m);

dxdt(1) = (F_t - F_resistance) / m;

dxdt(2) = e;

end