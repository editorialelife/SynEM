# SynEM

Code for synapse detection via neurite interface classification.

## Content

* SynEM: Code package for neurite interface classification (check the
README.md in the package for further information
* SynapseAnnotationGUI: Code for the manual neurite interface annotation
GUI.
* data: Data for examples and prediction

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

Examples for code are contained in the package SynEM.Examples:
* neuron2neuronErrorEstimates.m: How to use the error estimation framework
* synEMWorkflow.m: Direct application of SynEM using only a volume
segmentation and raw data array
* predictDataset.m: Application of SynEM to a dataset segmented by SegEM

To run the scripts in the Matlab command window the full name of the script
must be specified, e.g.
>> SynEM.Examples.synEMWorkflow
or
>> run('SynEM.Examples.synEMWorkflow.m')


