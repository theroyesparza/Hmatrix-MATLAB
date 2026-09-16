function [L,U] = LU(H, tol)

    % Leaf or dense A
    if H.type == 1
        [Ld,Ud] = lu(H.D);
        L = struct("type",1,"m",size(Ld,1),"n",size(Ld,2),"D",Ld);
        U = struct("type",1,"m",size(Ud,1),"n",size(Ud,2),"D",Ud);
        return;
    end

    % HODLR H
    if H.type == 3

        % Split blocks
        H11 = H.tl;
        H12 = H.tr;
        H21 = H.bl;
        H22 = H.br;

        %------------------------------------------------
        % 1) Factor H11
        %------------------------------------------------
        [L11,U11] = hodlr.LU(H11, tol);

        %------------------------------------------------
        % 2) Compute U12 = L11^{-1} H12
        %------------------------------------------------
        U12 = leftSolve(L11, H12, tol);
        %------------------------------------------------
        % 3) Compute L21 = H21 U11^{-1}
        %------------------------------------------------
        L21 = rightSolve(U11, H21, tol);

        %------------------------------------------------
        % 4) Schur complement
        %------------------------------------------------
        T = hodlr.multiplication(L21, U12, tol);

        S = hodlr.addition(H22, hodlr.scale(T,-1), tol);

        %------------------------------------------------
        % 5) Factor S
        %------------------------------------------------
        [L22,U22] = hodlr.LU(S, tol);

        %------------------------------------------------
        % Assemble L and U
        %------------------------------------------------
        zeros12 = struct("type",0,"m",H12.m,"n",H12.n);
        zeros21 = struct("type",0,"m",H21.m,"n",H21.n);
        L = node(L11, zeros12, L21, L22);
        U = node(U11, U12, zeros21, U22);
        return;
    end
end
