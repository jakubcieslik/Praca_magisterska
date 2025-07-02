%Rossler atractor circuit parameters
a = 0.2;
b = 0.2;
c = 5.7;

%Simulation time
StopTime = 100;

%Adding noise to samples. If bit = 0 there is no noise. If bit = 1 there is
NoiseBit = 1;
%NoiseLevel = [0, 0.001, 0.002, 0.005, 0.01, 0.1];
%NoiseLevel variable is amplitude of noise
NoiseLevel = 0.005;
