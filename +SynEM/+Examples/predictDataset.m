%% Synapse prediction for a dataset segmented by SegEM

%load segmentation parameter file (see setParameterSetting in SegEM code)
%for a precalculated SegEM segmentation
m = load('allParameter.mat');
parameter = m.p;

%run SynEM
fm = SynEM.getFeatureMap('paper');
m = load('data/SynEMPaperClassifier.mat');
classifier = m.classifier;
[parameter, job] = SynEM.Seg.predictDataset( parameter, fm, classifier );