function [ rawLocalNewDirection, segmentsLocalNewDirection, voxelLabelsNewDirection ] = arbitraryReslice( raw , orth1, orth2, sliceNormal, startPos, segments, voxelLabels)
%ARBITRARYSLICE Make Slice through volumetric data
%INPUT raw: volume to be sliced as single or double or uint8 array
%      orth1, orth2: vectors spanning the slice-surface, orth1 will be the
%                   new x-axis and orth2 the y-axis
%      sliceNormal: normal vector of slice-surface
%      startPos: base point for the vectors spanning the slice-surface
%      segments: the segmentation of raw.
%      voxelLabels: (Optional) 3D array of logicals. Additional array which
%           is rotated using nearest neighbors and intended to be used for
%           voxel labels.
%OUTPUT rawLocalNewDirection: a double array sliced out of raw of size
%                             basically given by the roi which is centered
%                             on startPos and the axis given by orth1,
%                             orth2 and sliceNormal as explained above
%        segmentsLocalNewDirection: as rawLocalNewDirection but for
%                             segments insted of raw
%        voxelLabelsNewDirection: 3D array of logical of same size as raw
%           which contains the rotated voxelLabels or zeros if no
%           voxelLables were provided.

%values for the anisotropy of the voxels of raw
voxelSize = [11.24,11.24,28];
voxelSizeAfter = [11.24,11.24,11.24];

%calculate box including all rotations
x_width = 140;
y_width = 140;
z_width = 60;
border = 1/sqrt(2) .* max(voxelSizeAfter .* [x_width y_width z_width]); %given by the cube with side length equal to the maximal side in the rectangle from roi times sqrt(2) to include all rotations
border = ceil(repmat(border,1,3) ./voxelSize); %border=[99,99,40]

%cut out local stack of raw around startPos for interpolation
bbox = [startPos - border; startPos + border];
rawLocal = single(raw(bbox(1,1):bbox(2,1),bbox(1,2):bbox(2,2),bbox(1,3):bbox(2,3)));
localSegments = single(segments(bbox(1,1):bbox(2,1),bbox(1,2):bbox(2,2),bbox(1,3):bbox(2,3)));
    
%define grid for original values on rawLocal in dataset coordinates nm
[X,Y,Z] = meshgrid(-border(1):border(1),-border(2):border(2),-border(3):border(3));
X = X .* voxelSize(1);
Y = Y .* voxelSize(2);
Z = Z .* voxelSize(3);

%define orthogonal matrix for base transformation
A = [orth1', orth2', sliceNormal'];

%define grid for interpolating values
[XI,YI,ZI] = meshgrid(-x_width/2:x_width/2,-y_width/2:y_width/2,-z_width/2:z_width/2); %new grid in new coordinate system
coords = bsxfun(@times, [XI(:) YI(:) ZI(:)], voxelSizeAfter); %taking anisotropy into account
coords = (A*coords')'; %rotating coordinates by A
XI = reshape(coords(:,1),size(XI)); % grid in dataset coordinates nm
YI = reshape(coords(:,2),size(YI));
ZI = reshape(coords(:,3),size(ZI));

%do interpolation
%use vectors for XI,YI,ZI because using the arrays sometimes causes
%problems (e.g. for switch of y and z axis)
rawLocalNewDirection = interp3(X,Y,Z,rawLocal,XI(:),YI(:),ZI(:),'cubic');
rawLocalNewDirection = reshape(rawLocalNewDirection,size(XI));
segmentsLocalNewDirection = interp3(X,Y,Z,localSegments,XI(:),YI(:),ZI(:),'nearest');
segmentsLocalNewDirection = reshape(segmentsLocalNewDirection,size(XI));
if ~isempty(voxelLabels)
    localVoxelLabels = single(voxelLabels(bbox(1,1):bbox(2,1),bbox(1,2):bbox(2,2),bbox(1,3):bbox(2,3)));
    voxelLabelsNewDirection = interp3(X,Y,Z,localVoxelLabels,XI(:),YI(:),ZI(:),'nearest');
    voxelLabelsNewDirection = reshape(voxelLabelsNewDirection,size(XI));
    voxelLabelsNewDirection(isnan(voxelLabelsNewDirection)) = 0;
    voxelLabelsNewDirection = logical(voxelLabelsNewDirection);
else
    voxelLabelsNewDirection = false(size(segmentsLocalNewDirection));
end

%convert results back to integer types
rawLocalNewDirection = uint8(round(rawLocalNewDirection));
segmentsLocalNewDirection = uint32(segmentsLocalNewDirection);

end