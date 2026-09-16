function [Btl,Btr,Bbl,Bbr] = split_block(B, n1, tol)
    % This function split a block B into 4 sub-blocks
    switch B.type
        case 0
            m2 = B.m - n1;
            n2 = B.n - n1;
            
            Btl = struct("type",0,"m",n1,"n",n1);
            Btr = struct("type",0,"m",n1,"n",n2);
            Bbl = struct("type",0,"m",m2,"n",n1);
            Bbr = struct("type",0,"m",m2,"n",n2);

        case 1
            D = B.D;
            m2 = size(D,1) - n1;
            n2 = size(D,2) - n1;

            Btl = struct("type",1,"m",n1,"n",n1,"D",D(1:n1,1:n1));
            Btr = struct("type",1,"m",n1,"n",n2,"D",D(1:n1,n1+1:end));
            Bbl = struct("type",1,"m",m2,"n",n1,"D",D(n1+1:end,1:n1));
            Bbr = struct("type",1,"m",m2,"n",n2,"D",D(n1+1:end,n1+1:end));

        case 2
            U1 = B.U(1:n1,:);
            U2 = B.U(n1+1:end,:);
            V1 = B.V(1:n1,:);
            V2 = B.V(n1+1:end,:);

            Btl = lr_recompress(U1,V1,tol);
            Btr = lr_recompress(U1,V2,tol);
            Bbl = lr_recompress(U2,V1,tol);
            Bbr = lr_recompress(U2,V2,tol);

        case 3
            Btl = B.tl;
            Btr = B.tr;
            Bbl = B.bl;
            Bbr = B.br;

        otherwise
            error("split_block: Unknown block type");
    end
end