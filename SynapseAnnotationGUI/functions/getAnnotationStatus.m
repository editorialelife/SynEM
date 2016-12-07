function [ annotationStatus ] = getAnnotationStatus( interfaceNumber, labelList )
%GETANNOTATIONSTATUS Get the annotation for the specified interface surface.
%   Loads the annotation status from the output list.

currentStatus = labelList(interfaceNumber);

switch currentStatus
    case 0
        annotationStatus = 'No annotation yet';
    case 1
        annotationStatus = 'Pre (green) | Post (blue)';
    case 2
        annotationStatus = 'Pre (blue) | Post (green)';
    case 3
        annotationStatus = 'No Synapse';
    otherwise
        annotationStatus = 'Error in reading annotation status';
end

