data=readlines('benchmark1.plt');


data1_formatted = [];
data2_formatted = [];
row1 = [];
row2 = [];

counter = 1;

for j = 11:length(data)-1
    i = j - 10;
    if data(i) == ""
        if data(i+1) == ""
            counter = counter + 1;
            % data_formatted(i,1) = row1;
            % data_formatted(i,2) = row2;
            data1_formatted = [data1_formatted;row1];
            data2_formatted = [data2_formatted;row2];
            row1 = [];
            row2 = [];
        end
    else
        nums = split(data(i)," ");
        row1 = [row1,str2num(nums(1))];
        row2 = [row2,str2num(nums(2))];
    end
end

hold on
for i = 1:length(data1_formatted)
    plot(data1_formatted(i,:),data2_formatted(i,:), 'color' , '[1 0 0]');
end