%% sanity check if in SynEM main folder

if ~exist('+SynEM','dir') || ~exist('SynapseAnnotationGUI','dir') || ...
   ~exist('data','dir')
    error(['Please make sure you are in the SynEM repository main ' ...
           'folder containing the +SynEM, SynapseAnnotationGUI and ' ...
           'data subdirectories'])
end

%% Load raw data and segmentation
% tested for raw and seg of size [512, 512, 256]

m = load('raw.mat');
raw = m.raw;
m = load('seg.mat');
seg = m.seg;

%% Interface calculation for a segmentation

[interfaces, intIdx, edges] = SynEM.Svg.calculateInterfaces(...
    seg, [], [], 150, [11.24, 11.24, 28], [40, 80, 160]);
%edges with interface size above areaThreshold of 150
edges = edges(intIdx,:);

%% Neurite interface feature calculation

fm = SynEM.getFeatureMap('paper');
X = fm.calculate(interfaces, raw);

%% Neurite interface classification

m = load('data/SynEMPaperClassifier.mat');
classifier = m.classifier;
[~,scores] = classifier.predict(X);

%% Feature selection

m = load('data/SynEMPaperClassifier.mat');
classifier = m.classifier;
imp = classifier.ens.predictorImportance();
fm = SynEM.getFeatureMap('paper');
fm.setSelectedFeat(imp > 0); %all features that contribute
disp(['Selected ' num2str(fm.numFeaturesSelected) ' features.']);
X = fm.calculate(interfaces, raw);