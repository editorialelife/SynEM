function [ listNumber ] = findCoordinate( handles, coordinate )
%FINDCOORDINATE Find the specified coordinate.
%Searches for the specified coordinate in the interfaceSurfaceList and
%subsegmentsList and returns the list index (single number for the
%interfaceSurfaceList and row and column number for the subsegmentsList).
%Returns 0 if the coordinate wasn't found.

%convert to linear index if necessary
if length(coordinate) == 3
    coordinate = sub2ind(size(handles.data.raw),coordinate(1),coordinate(2),coordinate(3));
end

listNumber = 0;

%search for coordinate in interfaceList
foundInterface = false;
for i = 1:length(handles.data.interfaceSurfaceList)
    if ~isempty(find(handles.data.interfaceSurfaceList{i} == coordinate,1))
        listNumber = i;
        foundInterface = true;
        break;
    end
end

%search for coordinate in subsegmentsList with smallest rinclude
% [~,idx] = max(handles.metadata.includedSubsegmentDistance);
if ~foundInterface
listNumber = [0,0];
foundSubsegment = false;
    for i=1:size(handles.data.subsegmentsList{1},1)
        if ~isempty(find(handles.data.subsegmentsList{1}{i,1} == coordinate,1))
            listNumber = [listNumber;[i,1]];
            foundSubsegment = true;
        elseif ~isempty(find(handles.data.subsegmentsList{1}{i,2} == coordinate,1))
            listNumber = [listNumber;[i,2]];
            foundSubsegment = true;
        end
    end
    listNumber(1,:) = [];
    if ~foundSubsegment
        listNumber = 0;
    end
end


end

