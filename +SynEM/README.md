# SynEM

Code for synapse detection via interface classification.

## Content

* Aux: Auxiliary functions
* Classifier: Wrapper classes for classifiers
* ErrorEstimates: Neuron-to-neuron error estimation framework
* Eval: Evaluation routines for SynEM classifiers
* Examples: Scripts exemplifying the usage of the different parts of the
SynEm pipeline
* Feature: Wrapper classes for features
* FeatureMap: Feature map class for interface feature calculation
* Seg: Running SynEM on a SegEM segmentation
* Svg: Supervoxel graph construction and interface calculation
* Training: Feature calculation for training set and classifier training
* Util: Utility functions

## Setup

The Matlab-mex compiler has to be configured. This can be done done by
typing “mex -setup” in command line or the Matlab command prompt.
In case your system does not have a compiler installed please follow the
instructions by Mathworks. This is required to compile some of the routines
for the user’s computer.

Before using SynEM for the first time run the setup.m file in from the
SynEM main folder with the SynEM main folder set to the working directory.

## Usage

Code was tested with MATLAB R2015b.

Examples for code are contained in the module SynEM.Examples.


