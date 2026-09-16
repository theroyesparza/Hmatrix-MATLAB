function x = solve(H,B,tol)
    [L,U] = hodlr.LU(H, tol);
    if isstruct(B)
        Y = leftSolve(L, B, tol);
        x = rightSolve(U, Y, tol);
    else
        y = forwardSub(L, B);
        x = backwardSub(U, y);
    end
end