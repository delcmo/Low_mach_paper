function b = shape_functions(xq,yq)

b = zeros(length(xq),4);

%    4          3
%    +----------+
%    |          |
%    |          |
%    +----------+
%    1          2

    
b(:,1) = (1-xq).*(1-yq)/4;
b(:,2) = (1+xq).*(1-yq)/4;
b(:,3) = (1+xq).*(1+yq)/4;
b(:,4) = (1-xq).*(1+yq)/4;

end

