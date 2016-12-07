function saveAnnotations( handles, annotationsOnly )
%SAVEANNOTATIONS Save annotations as .mat-file
%   The annotations are saved as an array of the same length as the list of
%   interface surfaces, where each entry indicates the status of the
%   interface surface of the interface surface list with the same indices.
%   Furthermore, the metadata are also saved.
%   The possible entries of the output array are:
%   0 - no annotation
%   1 - Pre|Post
%   2 - Post|Pre
%   3 - No synapse

try
    [fileName,filePath] = uiputfile('MyAnnotation.mat');
    if annotationsOnly
        save([filePath fileName],'-struct','handles','interfaceLabels','voxelLabels','metadata','undecidedList','comments');
    else
        save([filePath fileName],'-struct','handles','interfaceLabels','voxelLabels','metadata','data','undecidedList','preprocessedData','comments');
    end
    uiwait(msgbox(['Saved file to ',[filePath fileName]],'Operation complete'));
    pause(0.01);
catch error
    message = getReport(error,'basic','hyperlinks','off');
    uiwait(msgbox((message),'Error','error'));
    pause(0.01);
end
end