clear all; close all; clc;

update_vtk_data_with_csv = true;
visit_filename = 'density-visit.vtk';
csv_file = 'density-paraview0.csv';

update_vtk_data_with_csv = true;
show_plot=false;

nquad_list = 2:4;

for iq=1:length(nquad_list)
    [L1(iq),L2(iq)] = post_process_norm(nquad_list(iq),visit_filename,csv_file,...
                                        update_vtk_data_with_csv,show_plot);
end

L1
L2
figure;
semilogy(nquad_list,L1);
title('L1 norm versus nquad');
figure;
semilogy(nquad_list,L2); 
title('L2 norm versus nquad');

show_plot=true;
[L1,L2] = post_process_norm(3,visit_filename,csv_file,...
                            update_vtk_data_with_csv,show_plot);

                                