function draw_block(B, r1, r2, c1, c2)
% Draw block B occupying rows [r1,r2], cols [c1,c2].

    switch B.type
        case 0
            % Draw nothing or white rectangle
            rectangle('Position',[c1 r1 (c2-c1+1) (r2-r1+1)], 'FaceColor',[1 1 1], 'EdgeColor','k');
            return;

        case 1  % dense -> red
            rectangle('Position',[c1 r1 (c2-c1+1) (r2-r1+1)], ...
                      'FaceColor',[1 0.4 0.4], 'EdgeColor','k');
            return;

        case 2  % low-rank -> green
            rectangle('Position',[c1 r1 (c2-c1+1) (r2-r1+1)], ...
                      'FaceColor',[0.4 1 0.4], 'EdgeColor','k');
        
            % ---- compute rank ----
            if isempty(B.U)
                r = 0;
            else
                r = size(B.U,2);
            end
        
            % ---- position for text ----
            xc = (c1 + c2)/2;
            yc = (r1 + r2)/2;
        
            % ---- draw rank ----
            text(xc, yc, sprintf('%d', r), ...
                 'HorizontalAlignment','center', ...
                 'FontSize',8, ...
                 'Color','k');
        
            return;

        case 3  % hodlr node: split into 4 children
            n1 = B.n1;

            % row splits
            rmid = r1 + n1 - 1;
            % col splits (same n1 because square split; consistent with your builder)
            cmid = c1 + n1 - 1;

            % Recurse on the 4 subblocks:
            % tl: rows r1:rmid, cols c1:cmid
            draw_block(B.tl, r1, rmid, c1, cmid);
            % tr: rows r1:rmid, cols cmid+1:c2
            draw_block(B.tr, r1, rmid, cmid+1, c2);
            % bl: rows rmid+1:r2, cols c1:cmid
            draw_block(B.bl, rmid+1, r2, c1, cmid);
            % br: rows rmid+1:r2, cols cmid+1:c2
            draw_block(B.br, rmid+1, r2, cmid+1, c2);

        otherwise
            error("hodlr_spy:UnknownType");
    end
end

