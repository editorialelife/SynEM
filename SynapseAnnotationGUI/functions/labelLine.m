function handles = labelLine( handles, points )
%LABELLINE Labels all voxels on straight lines between points.

voxelToLabel = points(1,:);
for k = 1:size(points,1) - 1
    directionVector = points(k + 1,:) - points(k,:);
    length = norm(directionVector);
    directionVector = directionVector./length;
    for step = 1:ceil(length)
        voxelToLabel = cat(1,voxelToLabel,round(points(k,:) + step.*directionVector));
    end
end
voxelToLabel = unique(voxelToLabel,'rows');
voxelToLabelGlobal = zeros(size(voxelToLabel));
for k = 1:size(voxelToLabel,1);
    voxelToLabelGlobal(k,:) = determineCoordinate(handles,voxelToLabel(k,1),voxelToLabel(k,2));
end
switch handles.view
    case {'explore-xy','interface-xy'}
        for k = 1:size(voxelToLabel,1)
            handles.voxelLabels(voxelToLabelGlobal(k,1) - 1:voxelToLabelGlobal(k,1) + 1,voxelToLabelGlobal(k,2) - 1:voxelToLabelGlobal(k,2) + 1,voxelToLabelGlobal(k,3)) = true;
            handles.currentHighlightedVoxels(voxelToLabel(k,2) - 1:voxelToLabel(k,2) + 1,voxelToLabel(k,1) - 1:voxelToLabel(k,1) + 1,:,voxelToLabel(k,3)) = cat(3,255.*ones(3,3),zeros(3,3),255.*ones(3,3));
            handles.voxelAlphaData(voxelToLabel(k,2) - 1:voxelToLabel(k,2) + 1,voxelToLabel(k,1) - 1:voxelToLabel(k,1) + 1,voxelToLabel(k,3)) = true;
        end
    case {'explore-xz','interface-xz'}
        for k = 1:size(voxelToLabel,1)
            handles.voxelLabels(voxelToLabelGlobal(k,1) - 1:voxelToLabelGlobal(k,1) + 1,voxelToLabelGlobal(k,2),voxelToLabelGlobal(k,3) - 1:voxelToLabelGlobal(k,3) + 1) = true;
            handles.currentHighlightedVoxels(voxelToLabel(k,2) - 1:voxelToLabel(k,2) + 1,voxelToLabel(k,1) - 1:voxelToLabel(k,1) + 1,:,voxelToLabel(k,3)) = cat(3,255.*ones(3,3),zeros(3,3),255.*ones(3,3));
            handles.voxelAlphaData(voxelToLabel(k,2) - 1:voxelToLabel(k,2) + 1,voxelToLabel(k,1) - 1:voxelToLabel(k,1) + 1,voxelToLabel(k,3)) = true;
        end
    case {'explore-yz','interface-yz'}
        for k = 1:size(voxelToLabel,1)
            handles.voxelLabels(voxelToLabelGlobal(k,1),voxelToLabelGlobal(k,2) - 1:voxelToLabelGlobal(k,2) + 1,voxelToLabelGlobal(k,3) - 1:voxelToLabelGlobal(k,3) + 1) = true;
            handles.currentHighlightedVoxels(voxelToLabel(k,2) - 1:voxelToLabel(k,2) + 1,voxelToLabel(k,1) - 1:voxelToLabel(k,1) + 1,:,voxelToLabel(k,3)) = cat(3,255.*ones(3,3),zeros(3,3),255.*ones(3,3));
            handles.voxelAlphaData(voxelToLabel(k,2) - 1:voxelToLabel(k,2) + 1,voxelToLabel(k,1) - 1:voxelToLabel(k,1) + 1,voxelToLabel(k,3)) = true;
        end
end

end

