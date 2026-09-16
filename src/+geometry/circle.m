function [Circ,Edges] = circle(n,r)
    theta = linspace(2*pi/n, 2*pi, n);  
    x = r .* cos(theta);
    y = r .* sin(theta);
    Circ = [x' y']; %Remove duplicate
    Edges = [(1:n)' [2:n 1]'];
    Edges(end+1,:) = [1,n];
end