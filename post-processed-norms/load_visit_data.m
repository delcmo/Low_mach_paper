function [coordinates, connectivity, data] = load_visit_data(visit_filename, show_plot)

% open the edge file and read in values
visit_filename = 'density-visit.vtk';
fid=fopen(visit_filename);
q=textscan(fid,'%s','commentStyle','#');
d=q{1};clear q;
fclose(fid);

% record some important sections of the vtk file
for k=1:length(d)
    
    if strcmp(d{k},'POINTS')
        k_POINTS=k;
    end
    if strcmp(d{k},'CELLS')
        k_CELLS=k;
    end
    if strcmp(d{k},'LOOKUP_TABLE')
        k_LOOKUP_TABLE=k;
    end
    if strcmp(d{k},'POINT_DATA')
        k_POINT_DATA=k;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read vertices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_vertices = str2double(d{k_POINTS+1});
n_coordinates_to_read = n_vertices * 3;

aux = zeros(n_coordinates_to_read,1);
i=0;
for k=k_POINTS+3:k_POINTS+2+n_coordinates_to_read
    i=i+1;
    aux(i) = str2double(d{k});
end
% store in format nvertices x 3
coordinates = reshape(aux,3,n_vertices)';
% eliminate z coordinates
coordinates(:,3)=[];
clear aux;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read connectivity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_cells = str2double(d{k_CELLS+1});
n_data_to_read = str2double(d{k_CELLS+2});

aux = zeros(n_data_to_read,1);
i=0;
for k=k_CELLS+3:k_CELLS+2+n_data_to_read
    i=i+1;
    aux(i) = str2double(d{k}) +1; % the +1 is to get vertices IDs starting at 1, not 0
end
% store in format ncells x 5
connectivity = reshape(aux,5,n_cells)';
% eliminate first collumn (the # of vertices for a given cell. here we
% quadrangles so this number is always = 4
connectivity(:,1)=[];
clear aux;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% quick check before reading data itself
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( str2double(d{k_POINT_DATA+1}) ~= n_vertices )
    str2double(d{POINT_DATA+1})
    n_vertices
    error('POINT_DATA and n_vertices !!!');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read density data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_data_to_read = n_vertices;
data = zeros(n_data_to_read,1);
i=0;
for k=k_LOOKUP_TABLE+2:k_LOOKUP_TABLE+1+n_data_to_read
    i=i+1;
    data(i) = str2double(d{k}); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot data to verify
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~show_plot
    return
end

for icell=1:n_cells
    vert_IDs = connectivity(icell,:);
    xcoord = coordinates(vert_IDs,1);
    ycoord = coordinates(vert_IDs,2);
    
    values = data(vert_IDs);
    
    patch(xcoord, ycoord, values, values); 
end
    
