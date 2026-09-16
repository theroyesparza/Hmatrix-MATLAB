function C = scale(A, alpha)
    % function to multiply a HODLR matrix with a scalar
    C = A;
    if A.type == 0
        return;
    elseif A.type == 1
        C.D = alpha*A.D;
    elseif A.type == 2
        C.U = alpha*A.U;
    elseif A.type == 3
        C.tl = hodlr.scale(A.tl, alpha);
        C.tr = hodlr.scale(A.tr, alpha);
        C.bl = hodlr.scale(A.bl, alpha);
        C.br = hodlr.scale(A.br, alpha);
    end
end