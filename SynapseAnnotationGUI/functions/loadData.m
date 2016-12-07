function [handles,loadSuccessful] = loadData(handles)
%LOADDATA Load required data for Synapse Annotator GUI
% Loads a .mat-file including the data required for the Synapse Annotator.
% The required data is the following:
% A 'data' struct containing 'raw','segments','interfaceSurfaceList',
% 'subsegmentsList','neighborIDs'
% A 'metadata' struct containing 'experiment','boundingBox',
% 'innerBoundingBox', 'rinclude'.
% A 'interfaceLabels' array of uint8

%open dialog box to select data
uiopen('load');

%save data to handles if user selected something meaningful
if exist('data','var') && exist('metadata','var')
    handles.data = data;
    handles.metadata = metadata;

    %load interfaceLabels if it exists or initialize it otherwise
    if exist('interfaceLabels','var') %compatibility with old version
        handles.interfaceLabels = interfaceLabels;
    else
        handles.interfaceLabels = uint8(zeros(size(data.interfaceSurfaceList)));
    end

    %load undecidedList if it exists or initialize it otherwise
    if exist('undecidedList','var')
        handles.undecidedList = undecidedList;
    else
        handles.undecidedList = false(size(data.interfaceSurfaceList));
    end
    
    %load voxel labels if it exists or initialize it otherwise
    if exist('voxelLabels','var')
        handles.voxelLabels = voxelLabels;
    else
        handles.voxelLabels = false(size(data.raw));
    end

    %load precalculated videos
    if exist('preprocessedData','var')
        handles.preprocessedData = preprocessedData;
    else
        handles.preprocessedData = [];
    end
    
    %load synapse prediction
    if exist('synapsePrediction','var')
        handles.synapsePrediction = synapsePrediction;
    else
        handles.synapsePrediction = [];
    end
    
    %load prediction score
    if exist('synapseScore','var')
        handles.synapseScore = synapseScore;
    else
        handles.synapseScore = [];
    end
    
    %load comments
    if exist('comments','var')
        handles.comments = comments;
    else
        handles.comments = cell(size(data.interfaceSurfaceList));
        handles.comments(:) = {'No comment'};
    end
    loadSuccessful = true;
else
    loadSuccessful = false;
end
end