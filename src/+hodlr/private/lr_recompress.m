function C = lr_recompress(U, V, tol)
    % This function given factors U (m x k), V (n x k) representing U*V',
    % recompress to rank r using QR + SVD of small core.

    m = size(U,1); n = size(V,1);
    k = size(U,2);

    if k == 0 || m==0 || n==0
        C = struct("type",0,"m",m,"n",n,"r",0,"U",[],"V",[]);
        return;
    end

    [Qu,Ru] = qr(U,0);
    [Qv,Rv] = qr(V,0);

    M = Ru * Rv';                 % (k x k), small
    [Um,Sm,Vm] = svd(M,'econ');
    s = diag(Sm);

    if isempty(s)
        C = struct("type",0,"m",m,"n",n,"r",0,"U",[],"V",[]);
        return;
    end

    keep = (s > tol*s(1));
    Um = Um(:,keep);
    Vm = Vm(:,keep);
    s  = s(keep);

    if isempty(s)
        C = struct("type",0,"m",m,"n",n,"r",0,"U",[],"V",[]);
    else
        Uc = Qu * (Um * diag(s));
        Vc = Qv * Vm;
        C  = struct("type",2,"m",m,"n",n,"r",numel(s),"U",Uc,"V",Vc);
    end
end