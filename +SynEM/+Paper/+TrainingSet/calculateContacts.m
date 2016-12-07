function [ data, metadata ] = calculateContacts( rawConf, segConf, ...
    bbox, rinclude, useInGUI )
%CALCULATECONTACTS Calculate contact surfaces in a given volume for usage
%in the SynapseAnnotationGUI.
% INPUT rawConf: struct
%           Struct to load data from a knossos hierarchy. The required
%           fields are
%           'root': String
%               Path to knossos hierarchy root folder.
%           'prefix': String
%               Filename prefix of knossos cube files.
%       segConf: struct
%           As rawConf for the segmentation.
%       bbox: [3x2] int
%           Bounding box in the format [minX, maxX; inY, maxY; inZ, maxZ].
%       rinclude: [1xN] int
%           Size of the different subsegments in nm.
%       useInGUI: (Optional) logical
%           Flag specifying whether data should be used in Synapse
%           Annotation GUI.
%           (Default: true)
% OUTPUT data: struct
%           Struct containing the processed data. Fields are
%           'raw'
%           'segments'
%           'neighborIDs'
%           'contactSurfaceList'
%           'subsegmentsList'
%       metadata: struct
%           Information about data struct. Fields are
%           'experiment'
%           'boundingBox'
%           'innerBoundingBox'
%           'includedSubsegmentDistance'
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

fprintf('%s INFO loading raw data and segmentation\n', datestr(now));
raw = SynEM.Paper.TrainingSet.readKnossosRoi(rawConf.parfolder, ...
    rawConf.fileprefix, bbox, 'uint8', [128 128 128], 0);
if all(~raw)
    error('The raw file read from %s is empty.', rawConf.parfolder);
end
walls = SynEM.Paper.TrainingSet.readKnossosRoi( ...
    segConf.parfolder, segConf.fileprefix, bbox, ...
    'uint16', [128 128 128], 10);
if all(~walls)
    error('The walls file read form %s is empty.', ...
        segConf.parfolder);
end
if ~exist('useInGUI','var') || isempty(useInGUI)
    useInGUI = true;
end
segments = bwlabeln(walls,26);
rinclude = sort(rinclude);

%calculate contacts
[contactSurfaceList, subsegmentsList, neighborIDs ] = ...
    SynEM.Paper.TrainingSet.contactCalculationPipeline( segments, ...
    ~walls, rinclude, bbox, useInGUI );

%create data for gui
data.raw = raw;
if max(segments(:)) < 65537
    data.segments = uint16(segments);
    data.neighborIDs = uint16(neighborIDs);
else
    data.segments = uint32(segments);
    data.neighborIDs = uint32(neighborIDs);
end
data.contactSurfaceList = contactSurfaceList;
data.subsegmentsList = subsegmentsList;


%create metadata
metadata.experiment = rawConf.parfolder;
metadata.boundingBox = bbox;
if useInGUI
    metadata.innerBoundingBox = [100,bbox(1,2)-bbox(1,1)-99;100, ...
        bbox(2,2)-bbox(2,1)-99;40, ...
        bbox(3,2)-bbox(3,1)-39];
else
    metadata.innerBoundingBox = [40,bbox(1,2)-bbox(1,1)-39;40, ...
        bbox(2,2)-bbox(2,1)-39;14, ...
        bbox(3,2)-bbox(3,1)-13];
end

metadata.includedSubsegmentDistance = rinclude;

fprintf('%s INFO finished contact calculation\n', datestr(now));

end

