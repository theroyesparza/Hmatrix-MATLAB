function x = backwardSub(U, y)
    % Backward substitution and y is a vector 
    % Dense leaf
    if U.type == 1
        x = U.D \ y;
        return;
    end

    % U is HODLR
    if U.type == 3
        n1 = U.n1;
        y1 = y(1:n1);
        y2 = y(n1+1:end);
        x2 = backwardSub(U.br, y2);
        y1hat = y1 - hodlr.matvec(U.tr, x2);
        x1 = backwardSub(U.tl, y1hat);
        x = [x1; x2];
        return;
    end
end