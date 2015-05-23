function [x,y,w] = GL_2D (nquadx,nquady)
 
[bpxv,wfxv]=GLNodeWt(nquadx);

[bpyv,wfyv]=GLNodeWt(nquady);

[bpx,bpy]=meshgrid(bpxv,bpyv);
[wfx,wfy]=meshgrid(wfxv,wfyv);
wfxy=wfx.*wfy;


% put in 1d arrays
[n1, n2]=size(bpx);
x = reshape(bpx,n1*n2,1);
y = reshape(bpy,n1*n2,1);
w = reshape(wfxy,n1*n2,1);

end
