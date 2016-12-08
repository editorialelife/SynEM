%% set up for SynEM code package (run from SynEM repository main folder)

if ~exist('+SynEM','dir') || ~exist('SynapseAnnotationGUI','dir')
    error(['Please make sure you are in the SynEM repository main ' ...
           'folder containing the +SynEM and SynapseAnnotationGUI ' ...
           'subdirectories'])
end

%compile mex-files
mex -v CXX='/usr/bin/g++-4.7' CXXFLAGS='$CXXFLAGS -std=c++11' -outdir +SynEM/+Aux +SynEM/+Aux/eig3S.cpp
