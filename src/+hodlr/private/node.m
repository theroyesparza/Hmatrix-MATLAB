function B = node(tl,tr,bl,br)
    % helper function to separate a HODLR block into their separate blocks
    % (tr,tl,br,bl) and counts the dimensions for MATVEC/related functions
    B = struct();
    B.type = 3;
    B.tl = tl; B.tr = tr; B.bl = bl; B.br = br;
    B.m  = tl.m + br.m;
    B.n  = tl.n + br.n;
    B.n1 = tl.n;   % split point for vectors in matvec/solves
end