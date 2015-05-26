clear all; close all; clc;

csv_file = 'density-paraview0.csv';
M = csvread(csv_file,1,0);

indx = find( abs(M(:,2) -(-0.75)) < 1e-10)

value = M(indx,1);
y = M(indx,3);

value