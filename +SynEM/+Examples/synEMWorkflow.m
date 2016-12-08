%% sanity check if in SynEM main folder

if ~exist('+SynEM','dir') || ~exist('SynapseAnnotationGUI','dir') || ...
   ~exist('data','dir')
    error(['Please make sure you are in the SynEM repository main ' ...
           'folder containing the +SynEM, SynapseAnnotationGUI and ' ...
           'data subdirectories'])
end

%% Load raw data and segmentation
% tested for raw and seg of size [512, 512, 256]

if ~exist('TestSet_raw_seg.mat', 'file')
    error(['Please download the file ''TestSet_raw_seg.mat'' from the ' ...
        'SynEM website first.']);
end
m = load('TestSet_raw_seg.mat');
raw = m.raw;
seg = m.segments;
fm = SynEM.getFeatureMap('paper');
b = fm.border./2;
raw = raw(101-b(1):end-100+b(1),101-b(2):end-100+b(2), ...
           41-b(3):end-40+b(3));
seg = seg(101:end-100,101:end-100,41:end-40);

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

%% annotate interfaces in SynapseAnnotationGUI

m = load('TestSet_raw_seg.mat');
raw = m.raw;
seg = m.segments;
[data, metadata] = SynEM.Util.convertForSynapseAnnotationGUI(raw, seg, ...
    edges, interfaces, [512, 512, 256]);
if ~exist('TestCube.mat','file')
    save('TestCube.mat', 'data', 'metadata');
else
    error('TestCube.mat already exists. Please save the file manually.');
end

%start annotation GUI and use the load button to select the 'TestCube.mat'
%file
SynapseAnnotator();