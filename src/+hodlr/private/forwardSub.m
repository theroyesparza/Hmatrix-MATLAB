function y = forwardSub(L, b)
    % forward sustitution and b is a vector 
    % Dense leaf
    if L.type == 1
        y = L.D \ b;
        return;
    end
    % L is HODLR
    if L.type == 3
        n1 = L.n1;
        b1 = b(1:n1);
        b2 = b(n1+1:end);
        y1 = forwardSub(L.tl, b1);
        b2hat = b2 - hodlr.matvec(L.bl, y1);
        y2 = forwardSub(L.br, b2hat);
        y = [y1; y2];
        return;
    end
end