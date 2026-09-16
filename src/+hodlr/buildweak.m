function H = buildweak(Z, levels, starr,tol)

    % This functions builds a HODLR format matrix for any dense MATRIX 

    nLeaves = 2^levels; % number of leaves 
    leaves = cell(nLeaves,1); % cell to save all leaves 
    idxSets = cell(nLeaves,1); % index where leaves r located 
    % This is basically a cell that contains all indexes partitioned as star

    % Generate dense blocks 
    for i = 1:nLeaves
        idxSets{i} = starr(i):starr(i+1)-1;
        if isempty(idxSets{i})
            leaves{i} = struct("type",0,"m",0,"n",0);
        else
            A = Z(idxSets{i},idxSets{i});
            leaves{i} = struct("type",1,"m",numel(idxSets{i}),"n",numel(idxSets{i}),"D",A);
        end
    end

    % start building 
    nodes = leaves;
    for lev = levels:-1:1
        newNodes = cell(2^(lev-1),1);
        newIdx   = cell(2^(lev-1),1);

        for p = 1:2^(lev-1)
            left  = nodes{2*p-1};
            right = nodes{2*p};

            I1 = idxSets{2*p-1};
            I2 = idxSets{2*p};

            % off-diagonals from original dense Z
            tr = lr_block(Z(I1,I2), tol);
            bl = lr_block(Z(I2,I1), tol);

            newNodes{p} = node(left, tr, bl, right);
            newIdx{p}   = [I1, I2];
        end

        nodes   = newNodes;
        idxSets = newIdx;
    end
    H = nodes{1};

    % ======= HELPER FUNCTIONS ==========
    % 1) CREATE A HODLR NODE
    % B = hodlr_node(tl,tr,bl,br)
    % 2) LOW RANK BLOCK GENERATION
    % B = lr_block(A12, tol);
end