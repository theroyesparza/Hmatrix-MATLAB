function y = matvec(B, x)
% This function implements the matrix-vector multiplication with a matrix
% in HODLR format
% types:
% 0 empty, 1 dense (D), 2 lowrank (U,V), 3 hodlr (tl,tr,bl,br,n1)
    switch B.type
        case 0  % empty block
            y = zeros(B.m, 1, class(x));

        case 1  % dense block
            y = B.D * x;

        case 2  % low-rank block: U*(V'*x) to avoid generating a dense matrix
            y = B.U * (B.V' * x);

        case 3  % hodlr node: [tl tr; bl br]
            n1 = B.n1;                % number of columns in left half
            x1 = x(1:n1);
            x2 = x(n1+1:end);

            y1 = hodlr.matvec(B.tl, x1) + hodlr.matvec(B.tr, x2);
            y2 = hodlr.matvec(B.bl, x1) + hodlr.matvec(B.br, x2);

            y = [y1; y2];

        otherwise
            error("HODLR MATVEC: UnknownType");
    end
end
