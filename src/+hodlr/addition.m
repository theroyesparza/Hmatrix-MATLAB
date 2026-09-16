function C = addition(A, B, tol)

    % CASE 1) ONE IS EMPTY ================================================

    % CASE A empty
    if A.type == 0
        C = B;
        return;
     % CASE B is empty 
    elseif B.type == 0
        C = A;
        return;
    end

    % CASE 2) BOTH ARE HODLR ==============================================

    if A.type == 3 && B.type == 3
        Ctl = hodlr.addition(A.tl, B.tl, tol);
        Ctr = hodlr.addition(A.tr, B.tr, tol);
        Cbl = hodlr.addition(A.bl, B.bl, tol);
        Cbr = hodlr.addition(A.br, B.br, tol);
        C = node(Ctl, Ctr, Cbl, Cbr);
        return;
    end

    % CASE 3) ONLY ONE HODLR ==============================================
    if (A.type == 3) ~= (B.type == 3)
        if A.type == 3
            n1 = A.n1;
            [Btl,Btr,Bbl,Bbr] = split_block(B, n1, tol);
            Ctl = hodlr.addition(A.tl, Btl, tol);
            Ctr = hodlr.addition(A.tr, Btr, tol);
            Cbl = hodlr.addition(A.bl, Bbl, tol);
            Cbr = hodlr.addition(A.br, Bbr, tol);
            C = node(Ctl, Ctr, Cbl, Cbr);
            return;
        else 
            n1 = B.n1;
            [Atl,Atr,Abl,Abr] = split_block(A, n1, tol);
            Ctl = hodlr.addition(Atl, B.tl, tol);
            Ctr = hodlr.addition(Atr, B.tr, tol);
            Cbl = hodlr.addition(Abl, B.bl, tol);
            Cbr = hodlr.addition(Abr, B.br, tol);
            C = node(Ctl, Ctr, Cbl, Cbr);
            return;
        end 
    end

    % CASE 4) LEAF CASE ===================================================
   
    % Both dense 
    if A.type == 1 && B.type == 1 
        C = struct("type",1,"m",A.m,"n",A.n,"D",A.D + B.D);
        return;
    end
    
    % Both Low Rank
    if A.type == 2 && B.type == 2 
        Uc = [A.U, B.U];
        Vc = [A.V, B.V];
        C = lr_recompress(Uc, Vc, tol);
        return;
    end

    % Dense + LR = Dense 
    Afull = HODLR_to_dense(A);
    Bfull = HODLR_to_dense(B);
    Cfull = Afull + Bfull;
    C = struct("type",1,"m",size(Cfull,1),"n",size(Cfull,2),"D",Cfull);

end
