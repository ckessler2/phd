data2 = [0 0];

for n = 1:216
    data3 = [];
    for m = 1:216
        if n ~= m
            % data2((216*(n-1)+m),:) = data(n,:)- data(m,:);
            euc = sqrt(sum((data(n,:) - data(m,:)) .^ 2));
            data3 = [data3;euc];
        else
            data3 = [data3;100];
        end
    end
    [A,I] = min(data3);
    data2(n,:) = [A,I];
end