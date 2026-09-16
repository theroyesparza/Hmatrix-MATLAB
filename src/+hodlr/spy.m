function spy(B)
% Visualize an HODLR/HODLR-stronglike tree as block rectangles.
% Dense blocks (type=1): red
% Low-rank blocks (type=2): green
% Empty blocks (type=0): white
% Recurses through type=3 nodes using B.n1

    N = B.m;  % assuming square; for MoM Z it is square
    figure; hold on; axis equal; axis([1 N+1 1 N+1]);
    set(gca,'YDir','reverse');  % matrix-like coordinates (row 1 at top)
    title('HODLR block partition (red=dense, green=low-rank)','Interpreter','latex');
    xlabel('Column index','Interpreter','latex'); ylabel('Row index','Interpreter','latex');

    % recurse from root covering full matrix
    draw_block(B, 1, N, 1, N);

    % draw grid outline
    box on; grid off;
end
