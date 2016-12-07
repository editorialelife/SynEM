%% set up for SynEM code package (run from SynEM repository main folder)

if ~exist('+SynEM','dir') || ~exist('SynapseAnnotationGUI','dir')
    error(['Please make sure you are in the SynEM repository main ' ...
           'folder containing the +SynEM and SynapseAnnotationGUI ' ...
           'subdirectories'])
end

%compile mex-files
cd +SynEM/+Aux
mex eig3S.cpp
cd ../..