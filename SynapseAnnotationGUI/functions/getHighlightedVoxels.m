function handles = getHighlightedVoxels( handles,voxelLabels )
%GETHIGHLIGHTEDVOXELS Creates RGB and alpha data for voxel labels.
% INPUT voxelLabels: The voxel labels already adjusted to the current view.

L = voxelLabels;
colormap = [1,0,1];
currentHighlightedVoxels = zeros(size(L,1),size(L,2),3,size(L,3));
for i=1:size(L,3)
    image = label2rgb(L(:,:,i),colormap);
    currentHighlightedVoxels(:,:,:,i) = image;
end
handles.currentHighlightedVoxels = currentHighlightedVoxels;
handles.voxelAlphaData = L > 0;
end

