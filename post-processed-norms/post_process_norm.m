clear all; close all; clc;

% read vtk file from visit
visit_filename = 'density-visit.vtk';
show_plot=false;
[coordinates, connectivity, data] = load_visit_data(visit_filename, show_plot);

% read csv file from paraview
csv_file = 'density-paraview0.csv';
M = csvread(csv_file,1,0);
if size(M,2)==5
    exact_is_present_in_csv=1;
else
    exact_is_present_in_csv=0;
end

% double check the vtk/csv data
n_vert = length(data);
if size(M,1) ~= n_vert
    error('not the same number of vertices in vtk and csv data !!!');
end

max_diff=0;
for i=1:n_vert
    x_csv=M(i,2+exact_is_present_in_csv);
    y_csv=M(i,3+exact_is_present_in_csv);
    indicesX = find(abs(coordinates(:,1)-x_csv)<1e-5);
    if isempty(indicesX)
        i
        x_csv
        error('x_csv not found in vtk coordinates')
    end
    indicesY = find(abs(coordinates(indicesX,2)-y_csv)<1e-5);
    if isempty(indicesY)
        i
        coordinates(indicesX,2)
        y_csv
        error('y_csv not found in vtk coordinates')
    end
    if length(indicesY)>1
        [x_csv y_csv]
        indicesX
        indicesY
        error('y_csv found more than once in vtk coordinates')
    end
    vert_ID_in_vtk = indicesX(indicesY);
    value_vtk = data(vert_ID_in_vtk);
    value_csv = M(i,1);
    max_diff = max(max_diff, abs(value_vtk-value_csv));
    %     data(vert_ID_in_vtk,2) = M(i,2); % save exact

    % overwrite vtk data with more accurate csv data
%     data(vert_ID_in_vtk) = value_csv;
%     coordinates(vert_ID_in_vtk,1)=x_csv;
%     coordinates(vert_ID_in_vtk,2)=y_csv;

end
fprintf('max diff %15.10e \n',max_diff);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_cells = size(connectivity,1);

figure(1)
if exact_is_present_in_csv
    subplot(2,1,1)
end
for icell=1:n_cells
    vert_IDs = connectivity(icell,:);
    xcoord = coordinates(vert_IDs,1);
    ycoord = coordinates(vert_IDs,2);
    
    values = data(vert_IDs,1);
    
    patch(xcoord, ycoord, values, values);
end

if exact_is_present_in_csv
    subplot(2,1,2)
    for icell=1:n_cells
        vert_IDs = connectivity(icell,:);
        xcoord = coordinates(vert_IDs,1);
        ycoord = coordinates(vert_IDs,2);
        
        values = data(vert_IDs,2);
        
        patch(xcoord, ycoord, values, values);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_cells = size(connectivity,1);

% lower left point of mesh (used to determine ccw ordering of each element)
X_MIN=min(coordinates(:,1));
Y_MIN=min(coordinates(:,2));

% load 2d quadrature
nquadx=11; nquady=11;
[xq,yq,wq] = GL_2D(nquadx,nquady);
% load basis function
b = shape_functions(xq,yq);
nq = nquadx*nquady;
% norms
normL1 =0;
normL2 =0;

figure(99);
for icell=1:n_cells
    % pick an element
    vert_IDs = connectivity(icell,:);
    xcoord = coordinates(vert_IDs,1);
    ycoord = coordinates(vert_IDs,2);
    % check ccw ordering
    if ispolycw(xcoord,ycoord)
        warning('found a cw oriented cell!!!!')
    end
    % re-order nodes and shit data to we have:
    %    4          3
    %    +----------+
    %    |          |
    %    |          |
    %    +----------+
    %    1          2
    r2 = (xcoord-X_MIN).^2 + (ycoord-Y_MIN).^2  ;
    [~,ind]=min(r2);
    
    my_order = circshift(vert_IDs',-(ind-1))';
    xx = coordinates(my_order,1);
    yy = coordinates(my_order,2);
    vv = data(my_order,1);
%     ee = data(my_order,2);
    
    % compute jacobian at quadrature points
    Jxw = compute_jacobian(xq,yq,wq,xx,yy);
    
    % obtain numerical solution at qpts
    U = zeros(length(xq),1);
    for k=1:4
        U = U + vv(k)*b(:,k);
    end
    
    % obtain exact solution at qpts
    E = compute_exact(xx,yy,b);
    
    % norms
    normL1 = normL1 + dot(Jxw,abs(U-E));
    normL2 = normL2 + dot(Jxw,(U-E).^2);
    
end

[normL1 normL2]

