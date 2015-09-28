clc; close all; clear;

% ----- Model Parameters ----- %
N = 60000;
s0 = .99 * N;
i0 = .01 * N;
r0 = 0;
beta = 1;
gamma = .1;
% ---------------------------- %

t0 = 0;
tf = 12;
y0 = [s0,i0,r0];
[T,Y] = ode45(@(t,y) sir_update(y, beta, gamma), [t0, tf], y0);
plot(T,Y)