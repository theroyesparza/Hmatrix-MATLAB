function A = HODLR_to_dense(B)
    % This function convert an HODLR block to a full dense matrix.

    switch B.type
        case 0
            A = zeros(B.m, B.n);

        case 1
            A = B.D;

        case 2
            A = B.U * B.V'; %make low rank dense

        case 3
            A11 = HODLR_to_dense(B.tl);
            A12 = HODLR_to_dense(B.tr);
            A21 = HODLR_to_dense(B.bl);
            A22 = HODLR_to_dense(B.br);
            A = [A11, A12; A21, A22];

        otherwise
            error("HODLR_to_dense:UnknownType");
    end
end