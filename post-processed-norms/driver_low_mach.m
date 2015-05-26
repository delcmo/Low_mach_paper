clear all; close all; clc;

update_vtk_data_with_csv = true;
visit_filename = 'density-visit.vtk';
csv_file = 'density-paraview0.csv';

update_vtk_data_with_csv = true;
show_plot=false;

nquad_list = 2:2;

for iq=1:length(nquad_list)
    [L1(iq),L2(iq)] = post_process_norm(nquad_list(iq),visit_filename,csv_file,...
                                        update_vtk_data_with_csv,show_plot);
end

figure;
semilogy(nquad_list,L1);
figure;
semilogy(nquad_list,L2); 


show_plot=true;
for iq=1:length(nquad_list)
    [L1(iq),L2(iq)] = post_process_norm(3,visit_filename,csv_file,...
                                        update_vtk_data_with_csv,show_plot);
end