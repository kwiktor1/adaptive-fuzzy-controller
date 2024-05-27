function squares = findsquares(D)

% D - matrix of zeros  and ones: zero means no point,
% one means point exists
%
% squares - coordinates of squares (columns 1:8) 
% and the edge lenght (column 9)
% Note: lenght = 3 means 3 points in the edge

[M,N] = size(D);

squares = [];

% for all rows excluding the first one
for i = 2:M
    % for all columns excluding the last one
    for j = 1:N-1
        % does the left bottom corner exist? 
        if D(i,j) == 1
            % the distance beetwen points
            d = 1;
            issquare = true;
            while issquare
                % checking the indexes so that they do not exceed 
                % the size of the matrix and checking whether 
                % the sides are composed of only ones: 
                % left, top, right, bottom
                if i-d>0 && j+d<N && ...
                    all(D(i-d:i,j)) && all(D(i-d,j:j+d)) && ...
                    all(D(i-d:i,j+d)) && all(D(i,j:j+d))
                    % storing vertex coordinates and the length 
                    % of the edge in the form of a number of points
                    squares = [squares; 
                        [[i,j],[i-d,j]],[i-d,j+d],[i,j+d],d+1];
                else break
                end
                d = d + 1;
            end
        end
    end
end
