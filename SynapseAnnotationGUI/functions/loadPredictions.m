function handles = loadPredictions( handles )
%LOADPREDICTIONS

if ~isfield(handles,'data')
    msgbox('Load data first.','Error');
else
    uiopen('load');
    if exist('synapsePrediction','var')
        handles.synapsePrediction = synapsePrediction;
    else
        handles.synapsePrediction = [];
    end
    
    if exist('synapseScore','var')
        handles.synapseScore = synapseScore;
    else
        handles.synapseScore = [];
    end
end


end

