function X = rightSolve(U, B, tol)

    % CASE 1) empty B
    if B.type == 0
        X = B;
        return;
    end

    % CASE 2) DENSE LEAF L ================================================
    if U.type == 1
        if B.type == 1
            Xdense = B.D / U.D;
            X = struct("type",1,"m",size(Xdense,1),"n",size(Xdense,2),"D",Xdense);
            return;
        end
        if B.type == 2
            Vx = U.D' \ B.V;
            X  = lr_recompress(B.U, Vx, tol);
            return;
        end
        % B is HODLR
        Bfull = HODLR_to_dense(B);
        Xdense = Bfull / U.D;
        X = struct("type",1,"m",size(Xdense,1),"n",size(Xdense,2),"D",Xdense);
        return;
    end

    % CASE 3) RECURSIVE HODLR ============================================
    if U.type == 3
        if B.type ~= 3
            [Btl,Btr,Bbl,Bbr] = split_block(B, U.n1, tol);
        else
            Btl = B.tl;  Btr = B.tr;
            Bbl = B.bl;  Bbr = B.br;
        end
        % find left
        Xtl =rightSolve(U.tl, Btl, tol);   
        Xbl =rightSolve(U.tl, Bbl, tol);   
        % find right 
        T1  = hodlr.multiplication(Xtl, U.tr, tol);          
        T2  = hodlr.multiplication(Xbl, U.tr, tol);         
        Str = hodlr.addition(Btr, hodlr.scale(T1,-1), tol);  
        Sbr = hodlr.addition(Bbr, hodlr.scale(T2,-1), tol); 
        Xtr =rightSolve(U.br, Str, tol);  
        Xbr =rightSolve(U.br, Sbr, tol);  
    
        X = node(Xtl,Xtr,Xbl,Xbr);
        return;
    end
end 

