clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filenames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % for testing
% % i=0;
% % i=i+1; csv_file_list{i}='density-paraview0.csv';
% % i=0;
% % i=i+1; vtk_file_list{i}='density-visit.vtk';
%
% results as of May 26
i=0;
i=i+1; csv_file_list{i}='density-ref-0-data0.csv';
i=i+1; csv_file_list{i}='density-ref-1-data0.csv';
i=i+1; csv_file_list{i}='density-ref-2-data0.csv';
% i=i+1; csv_file_list{i}='density-paraview0.csv';
i=i+1; csv_file_list{i}='density-ref-3-data0.csv';
i=i+1; csv_file_list{i}='density-ref-4-data0.csv';
i=i+1; csv_file_list{i}='density-ref-5-data0.csv';
i=0;
i=i+1; vtk_file_list{i}='density-ref-0-data.vtk';
i=i+1; vtk_file_list{i}='density-ref-1-data.vtk';
i=i+1; vtk_file_list{i}='density-ref-2-data.vtk';
% i=i+1; vtk_file_list{i}='density-visit.vtk';
i=i+1; vtk_file_list{i}='density-ref-3-data.vtk';
i=i+1; vtk_file_list{i}='density-ref-4-data.vtk';
i=i+1; vtk_file_list{i}='density-ref-5-data.vtk';
% check
if length(vtk_file_list) ~= length(csv_file_list)
    error('number of result files is not consistent between vtk and csv filenames');
end
dir_name='.\result_files\';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
update_vtk_data_with_csv = true;
show_plot=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% quadrature choice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nquad_list = 2:6;
% nquad_list = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ifile=1:length(vtk_file_list)
    for iq=1:length(nquad_list)
        
        fprintf('file %d / %d, quadrature %d / %d \n', ...
            ifile,length(vtk_file_list),iq,length(nquad_list));
        
        [n_cells(ifile,iq),L1(ifile,iq),L2(ifile,iq)] = ...
            post_process_norm(nquad_list(iq),...
                              sprintf('%s%s',dir_name,vtk_file_list{ifile}),...
                              sprintf('%s%s',dir_name,csv_file_list{ifile}),...
                              update_vtk_data_with_csv,...
                              show_plot);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(20)
plot(log(n_cells(:,end)), log(L1(:,end)) ,'-+'); hold all
plot(log(n_cells(:,end)), log(L2(:,end)) ,'-o');
legend(['L1';'L2']);
% exclude coarsest mesh
figure(30)
plot(log(n_cells(2:end,end)), log(L1(2:end,end)) ,'-+'); hold all
plot(log(n_cells(2:end,end)), log(L2(2:end,end)) ,'-o');
legend(['L1';'L2']);

if length(nquad_list) > 1
    figure(21)
    for iq=1:length(nquad_list)
        plot(log(n_cells(:,iq)), log(L1(:,iq)) ,'-+'); hold all
    end
    figure(22)
    for iq=1:length(nquad_list)
        plot(log(n_cells(:,iq)), log(L2(:,iq)) ,'-+'); hold all
    end
    for iq=1:length(nquad_list)
        L1_rate(1:length(vtk_file_list)-1,iq) = log(L1(1:end-1,iq)./L1(2:end,iq)) / log(2);
        L2_rate(1:length(vtk_file_list)-1,iq) = log(L2(1:end-1,iq)./L2(2:end,iq)) / log(2);
    end
else
    [n_cells(:,1) L1(:,1) L2(:,1)]
    L1_rate = log(L1(1:end-1)./L1(2:end,1)) / log(2)
    L2_rate = log(L2(1:end-1)./L2(2:end,1)) / log(2)
end

save compression_corner_5ref_several_quad.mat 

% just to see the finest mesh solution
% show_plot=true;
% [~,~]=post_process_norm(nquad_list(iq),...
%     sprintf('%s%s',dir_name,vtk_file_list{end-2}),...
%     sprintf('%s%s',dir_name,csv_file_list{end-2}),...
%     update_vtk_data_with_csv,...
%     show_plot);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

