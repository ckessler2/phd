function allFileNames = get_csv_files(root)
    % location = "\SwallowData2\BlankSwallow\HyoidBone\8PS";
    filePattern = fullfile(root, "*.csv");
    ds = fileDatastore(filePattern, 'ReadFcn', @readmatrix);
    allFileNames = ds.Files;
end