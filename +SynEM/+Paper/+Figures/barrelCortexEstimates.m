function stats = barrelCortexEstimates( volume )
%BARRELCORTEXESTIMATES Density and annotation estimates for barrel cortex.
% INPUT volume: double
%           Dataset volume in um^3
% OUTPUT stats: struct
%           Struct containing the statistics for the input volume.
%           Length is typically reported in millimeters and time in hours.
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

%% densities
stats.volume = volume;
neuronDensity = 157500/1000^3; %1/um^3
stats.noNeurons = neuronDensity*volume;
stats.noSynapses = volume; %assuming 1 syn/um^3
% noSynapsesAlt = noNeurons*1e4;
% stats.axonPathLength = volume/1000^3*10*1e6; % mm % 10 km/mm^3
stats.axonPathLength = volume/1000^3*4*1e6; % mm % 4 km/mm^3
stats.dendriticPathLength = stats.axonPathLength/10; % mm
stats.spinePathLength = 2*stats.dendriticPathLength; %mm
inhToNeuronRatio = 0.081; %meyer 2011 PNAS
stats.noInhNeurons = stats.noNeurons*inhToNeuronRatio;
stats.noExNeurons = stats.noNeurons - stats.noInhNeurons;
stats.noInhSynapses = stats.noSynapses*inhToNeuronRatio;
stats.noExSynapses = stats.noSynapses - stats.noInhSynapses;
stats.inhAxonPathLength = stats.axonPathLength*inhToNeuronRatio;
stats.exAxonPathLength = stats.axonPathLength - stats.inhAxonPathLength;

%% annotation times

%neurite contouring (see MH, 2011)
contouringTimeMinPerMM = 200; %h
contouringTimeMaxPerMM = 400; %h
countouringTimePerMM = (contouringTimeMinPerMM + contouringTimeMaxPerMM)/2;
stats.contourTime = (stats.axonPathLength + stats.dendriticPathLength + ...
    stats.spinePathLength)*countouringTimePerMM; %hours
stats.contourDev =(stats.axonPathLength + stats.dendriticPathLength + ...
    stats.spinePathLength)*contouringTimeMaxPerMM - stats.contourTime;

%skeletonization (see SegEM)
skeletonizationTimeMin = 3.7; %h
skeletonizationTimeMax = 7.2; %h
skeletonizationTime = (skeletonizationTimeMin + skeletonizationTimeMax)/2;
%path length: 10 km axons, 1 km dendrites per mm^3
stats.skeletTime = (stats.axonPathLength + stats.dendriticPathLength + ...
    stats.spinePathLength)*skeletonizationTime; %hours
stats.skeletDev =(stats.axonPathLength + stats.dendriticPathLength + ...
    stats.spinePathLength)*skeletonizationTimeMax - stats.skeletTime;
stats.skeletTimeNew = (stats.axonPathLength + stats.dendriticPathLength + ...
    stats.spinePathLength)*0.6;

%synapse volume search 6 min/um^3 (synapses) - split into exc and inh
inhToSynRatioMax = 0.1295; %our test set
inhToSynRatioMin = 0.081; %meyer 2011 PNAS
numSyn = volume;
synVolSearch = 0.1; %h/um^3
% volSearchTime = volume*synVolSearch; %hours
inhSyn = (inhToSynRatioMin + inhToSynRatioMax)/2.*numSyn;
inhSynMin = numSyn*inhToSynRatioMin;
inhSynMax = numSyn*inhToSynRatioMax;
excSyn = numSyn - inhSyn;
excSynMax = numSyn - inhSynMin;
stats.inhSearchTime = inhSyn*synVolSearch;
inhSearchTimeMax = inhSynMax*synVolSearch;
inhSearchTimeMin = inhSynMin*synVolSearch;
stats.inhDev = (inhSearchTimeMax - inhSearchTimeMin);
stats.excSearchTime = excSyn*synVolSearch;
excSearchTimeMax = excSynMax*synVolSearch;
stats.excDev = (excSearchTimeMax - stats.excSearchTime);

%synapse along axons - exc and inh
boutonDensityPerMMMin = 1/10*1000; %1/mm assuming bouton every 10 um
boutonDensityPerMMMax = 1/4*1000; %1/mm assuming bouton every 4 um
boutonDensityPerMM = (boutonDensityPerMMMax + boutonDensityPerMMMin)/2;
annTimePerBouton = 1/60; %h
stats.boutonTime = stats.axonPathLength*boutonDensityPerMM*annTimePerBouton;
stats.boutonTimeExc = stats.exAxonPathLength*boutonDensityPerMM*annTimePerBouton;
stats.boutonTimeInh = stats.inhAxonPathLength*boutonDensityPerMM*annTimePerBouton;
stats.boutonDev = stats.axonPathLength*boutonDensityPerMMMax*annTimePerBouton - ...
            stats.boutonTime;
stats.boutonDevExc = stats.exAxonPathLength*boutonDensityPerMMMax*annTimePerBouton - ...
            stats.boutonTimeExc;
stats.boutonDevInh = stats.inhAxonPathLength*boutonDensityPerMMMax*annTimePerBouton - ...
            stats.boutonTimeInh;
end

