function [ data, metadata ] = convertForSynapseAnnotationGUI( raw, seg, ...
    edges, interfaces, intRefSiz )
%CONVERTFORSYNAPSEANNOTATIONGUI Convert interfaces for synapse annotation
%GUI.
% INPUT raw: 3d int
%           Raw data images. Must have a border of [100, 100, 40] on each
%           side compared to the cube on which the interfaces were
%           calculated.
%       seg: 3d int
%           Volume segmentation for raw data. Must have a border of
%           [100, 100, 40] on each side compared to the cube on which the
%           interfaces were calculated.
%       edges: [Nx2] int
%           see SynEM.Svg.findEdgesAndBorders
%       interfaces: struct
%           see SynEM.Svg.calculateInterfaces
%       intRefSiz: (Optional) [1x3] int
%           Size of the segmentation matrix for which the interfaces were
%           calculated.
%           (Default: [512 512 256])
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

data.raw = raw;
data.segments = seg;
data.interfaceSurfaceList = interfaces.surface;
data.subsegmentsList = interfaces.subseg;

if ~exist('intRefSiz', 'var') || isempty(intRefSiz)
    intRefSiz = [512 512 256];
end

%convert indices stored in interfaces to larger cube
for i = 1:length(data.interfaceSurfaceList)
    [x,y,z] = ind2sub(intRefSiz, data.interfaceSurfaceList{i});
    x = x + 100;
    y = y + 100;
    z = z + 40;
    data.interfaceSurfaceList{i} = uint32(sub2ind(size(raw),x,y,z));
    for j = 1:2
        [x,y,z] = ind2sub(intRefSiz, data.subsegmentsList{1}{i,j});
        x = x + 100;
        y = y + 100;
        z = z + 40;
        data.subsegmentsList{1}{i,j} = uint32(sub2ind(size(raw),x,y,z));
    end
end
data.neighborIDs = edges;

%initialize metadata fields
metadata.experiment = [];
metadata.segmentation = [];
metadata.boundingBox = [];
metadata.innerBoundingBox = [];
metadata.rinclude = interfaces.rinclude;

end

