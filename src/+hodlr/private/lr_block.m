function B = lr_block(A12, tol)
    % This function creates a low rank matrix from a dense matrix 
    
    [m,n] = size(A12); % obtain the size of the block 

    if m==0 || n==0 % if empty --> type 0
        B = struct("type",0,"m",m,"n",n,"r",0,"U",[],"V",[]); 
        return;
    end
 
    % SVD 
    [u,s,v] = svdsketch(A12, tol);
    s = diag(s);

    % % if no singular values --> type 0
    % if isempty(s)
    %     B = struct("type",0,"m",m,"n",n,"r",numel(s),"U",[],"V",[]);
    %     return;
    % end

    keep = s > tol*s(1);
    u = u(:,keep); v = v(:,keep); s = s(keep);

    if isempty(s)
        B = struct("type",0,"m",m,"n",n,"r",0,"U",[],"V",[]);
    else
        B = struct("type",2,"m",m,"n",n,"r",numel(s),"U",u*diag(s),"V",v);
    end
end