function startPos = calculateStartPos( segments, interfaceIndices )
%CALCULATESTARTPOS Claculates an approximate center of mass.
%Calculates an approximate center of mass for the interfaceSurface using
%knnsearch.

%define adjacent subregions and interface surface
interfaceSurface = false(size(segments));
interfaceSurface(interfaceIndices) = true;

%calculate center of mass
L = bwlabeln(interfaceSurface);
STATS = regionprops(L,'Centroid');
startPos = STATS.Centroid;

%search closest point on interface surface center of mass
[x,y,z] = ind2sub(size(segments),interfaceIndices);
wallIndices = double([y,x,z]);
idx = knnsearch(wallIndices,startPos);
startPos = wallIndices(idx,:);
startPos = [startPos(2),startPos(1),startPos(3)];
end

