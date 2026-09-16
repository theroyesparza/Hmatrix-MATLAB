function X = leftSolve(L, B, tol)
    % HODLR-left solver and B is a BLOCK 
    % CASE 1) empty B
    if B.type == 0
        X = B;
        return;
    end

    % CASE 2) DENSE LEAF L ================================================
    if L.type == 1
        if B.type == 1
            Xdense = L.D \ B.D;
            X = struct("type",1,"m",size(Xdense,1),"n",size(Xdense,2),"D",Xdense);
            return;
        end
        if B.type == 2
            Ux = L.D \ B.U;
            X  = lr_recompress(Ux, B.V, tol); 
            return;
        end
        % HODLR B
        Bfull = HODLR_to_dense(B);
        Xdense = L.D \ Bfull;
        X = struct("type",1,"m",size(Xdense,1),"n",size(Xdense,2),"D",Xdense);
        return;
    end

    % CASE 3) RECURSIVE HODLR ============================================
    if L.type == 3
        if B.type ~= 3 % B is not HODLR
            [Btl,Btr,Bbl,Bbr] = split_block(B, L.n1, tol);
        else % B is HODLR 
            Btl = B.tl;  Btr = B.tr;
            Bbl = B.bl;  Bbr = B.br;
        end
        % find Xtl and Xtr (tops)
        Xtl = leftSolve(L.tl, Btl, tol);   
        Xtr = leftSolve(L.tl, Btr, tol);  
        % Find Xbl and Xbr (bottoms)
        T1  = hodlr.multiplication(L.bl, Xtl, tol);         
        T2  = hodlr.multiplication(L.bl, Xtr, tol);         
        Sbl = hodlr.addition(Bbl, hodlr.scale(T1,-1), tol);  
        Sbr = hodlr.addition(Bbr, hodlr.scale(T2,-1), tol);  
        Xbl = leftSolve(L.br, Sbl, tol);  
        Xbr = leftSolve(L.br, Sbr, tol);  
        
        X = node(Xtl,Xtr,Xbl,Xbr);
        return;
    end
end 
