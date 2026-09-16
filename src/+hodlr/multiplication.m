function C =multiplication(A,B,tol)

    % CASE 1) ONE IS EMPTY ================================================
    if A.type == 0 || B.type == 0
        C = struct("type",0,"m",A.m,"n",B.n,"r",0,"U",[],"V",[]);
        return;
    end

    % CASE 2) BOTH ARE HODLR ==============================================
    if (A.type == 3) && (B.type == 3)
        Ctl = hodlr.addition(hodlr.multiplication(A.tl,B.tl,tol), hodlr.multiplication(A.tr,B.bl,tol), tol);
        Ctr = hodlr.addition(hodlr.multiplication(A.tl,B.tr,tol), hodlr.multiplication(A.tr,B.br,tol), tol);
        Cbl = hodlr.addition(hodlr.multiplication(A.bl,B.tl,tol), hodlr.multiplication(A.br,B.bl,tol), tol);
        Cbr = hodlr.addition(hodlr.multiplication(A.bl,B.tr,tol), hodlr.multiplication(A.br,B.br,tol), tol);
        C = node(Ctl,Ctr,Cbl,Cbr);
        return;
    end

    % CASE 3) ONLY ONE IS HODLR (PARTITION APPROACH)
    % if (A.type == 3) ~= (B.type == 3)
    %     if A.type == 3
    %         n1 = A.n1;
    %         [Btl,Btr,Bbl,Bbr] = split_block(B,n1,tol);
    %         Ctl = hodlr.addition(hodlr.multiplication(A.tl,Btl,tol), hodlr.multiplication(A.tr,Bbl,tol), tol);
    %         Ctr = hodlr.addition(hodlr.multiplication(A.tl,Btr,tol), hodlr.multiplication(A.tr,Bbr,tol), tol);
    %         Cbl = hodlr.addition(hodlr.multiplication(A.bl,Btl,tol), hodlr.multiplication(A.br,Bbl,tol), tol);
    %         Cbr = hodlr.addition(hodlr.multiplication(A.bl,Btr,tol), hodlr.multiplication(A.br,Bbr,tol), tol);
    %         C = node(Ctl,Ctr,Cbl,Cbr);
    %         return;
    %     else
    %         n1 = B.n1;
    %         [Atl,Atr,Abl,Abr] = split_block(A,n1,tol);
    %         Ctl = hodlr.addition(hodlr.multiplication(Atl,B.tl,tol), hodlr.multiplication(Atr,B.bl,tol), tol);
    %         Ctr = hodlr.addition(hodlr.multiplication(Atl,B.tr,tol), hodlr.multiplication(Atr,B.br,tol), tol);
    %         Cbl = hodlr.addition(hodlr.multiplication(Abl,B.tl,tol), hodlr.multiplication(Abr,B.bl,tol), tol);
    %         Cbr = hodlr.addition(hodlr.multiplication(Abl,B.tr,tol), hodlr.multiplication(Abr,B.br,tol), tol);
    %         C = node(Ctl,Ctr,Cbl,Cbr);
    %         return;
    %     end   
    % end

    % % CASE 3) ONLY ONE IS HODLR (DENSE APPROACH)
    if (A.type == 3) ~= (B.type == 3)

        Afull = HODLR_to_dense(A);
        Bfull = HODLR_to_dense(B);

        Cfull = Afull * Bfull;

        C = struct("type",1,"m",size(Cfull,1),"n",size(Cfull,2),"D",Cfull);
        return
    end

    % CASE 4) LEAF CASES ==================================================

    % both dense
    if A.type == 1 && B.type == 1
        D = A.D * B.D;
        C = struct("type",1,"m",size(D,1),"n",size(D,2),"D",D);
        return;
    end

    % both lowrank
    if A.type == 2 && B.type == 2
        M = A.V' * B.U;
        Uc = A.U * M;
        Vc = B.V;
        C = lr_recompress(Uc,Vc,tol);
        return;
    end

    % dense and lowrank
    if A.type == 1 && B.type == 2
        Uc = A.D * B.U;
        Vc = B.V;
        C = lr_recompress(Uc,Vc,tol);
        return;
    end

    % low rank and dense 
    if A.type == 2 && B.type == 1
        Uc = A.U;
        Vc = B.D' * A.V;   
        C = lr_recompress(Uc,Vc,tol);
        return;
    end

    error("hodlr.multiplication: error");
end

