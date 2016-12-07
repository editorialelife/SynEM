function preprocessVideos( fullData, fullMetadata, partitionSize, savePath )
%PREPROCESSVIDEOS Partition dataset into smaller part to distribute them.
%Includes all the important information in the partitions, i.e. everyting
%except subsegmentsList. You can open a parpool to calculate interfaces in
%parallel.
%INPUT data: An data struct (see InterfaceClassifier/InterfaceCalculation)
%      metadata: As data (see InterfaceClassifier/InterfaceCalculation)
%      savePath: Path and base filename without .mat for saving the
%                partitioned files.
%      varargin: If already done the preprocessedData can be added.
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

raw = single(fullData.raw);
segments = fullData.segments;
n = ceil(length(fullData.interfaceSurfaceList)/partitionSize);

for part = 1:n
    indices = (part - 1)*partitionSize + 1:min(part.*partitionSize,length(fullData.interfaceSurfaceList));
    preprocessedInterfaces = cell(partitionSize,1);
    preprocessedSegments = cell(partitionSize,1);
    interfaceSurfaceList = fullData.interfaceSurfaceList(indices);
    
    %you need to start a parpool before executing this function if you want
    %to use parallel processing
    parfor i = 1:length(interfaceSurfaceList)
        [int_tmp,seg_tmp] = rotateInterface( [],[],interfaceSurfaceList{i},raw,segments,'interface-rotated',[] );
        preprocessedInterfaces{i} = int_tmp;
        preprocessedSegments{i} = seg_tmp;
    end
    
    %save data, metadata and preprocessed vidoes in new matfile
    preprocessedData = cat(2,preprocessedInterfaces,preprocessedSegments);
    data.raw = fullData.raw;
    data.segments = segments;
    data.interfaceSurfaceList = fullData.interfaceSurfaceList(indices);
    data.subsegmentsList = [];
    data.neighborIDs = fullData.neighborIDs(indices,:);
    metadata = fullMetadata;
    metadata.part = part;
    m = matfile([savePath '(' num2str(part) ').mat'],'Writable',true);
    m.data = data;
    m.metadata = metadata;
    m.preprocessedData = preprocessedData;
    fprintf('Written file %s\n',[savePath '(' num2str(part) ').mat']);
end

end

