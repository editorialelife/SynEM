%% Calculate neuron-to-neuron recall/precision estimates

%test set recall/precision values
m = load('data/Figure3Data_v3.mat');
rp = m.testSet.rpExc;

%number of synapse between neurons distribution
empDist = m.empDist;
avgEmpDist = m.avgEmpDist;

%connectivity ratio
c_r = 0.2;

%neuron-to-neuron estimated recall/precision values for the corresponding
%single synapse recall/precision values
nnRP = SynEM.ErrorEstimates.nnRP(rp, c_r, avgEmpDist, 1, empDist);

%plot neuron-to-neuron estimated recall/precision
plot(nnRP(:,1), nnRP(:,2))
xlim([0.9 1])
ylim([0.9 1])