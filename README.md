# SynEM

Code for synapse detection via neurite interface classification
(Staffler et al.)

## Content

* SynEM: Code package for neurite interface classification
* SynapseAnnotationGUI: Graphical User Interface for manual neurite
interface annotation (Suppl. Fig. 1a in Staffler et al.)
* data: Data for examples and prediction

## Setup

MATLAB R2015b or higher is required. The Matlab-mex compiler has to be
configured. This can be done by
typing “mex -setup” in command line or the Matlab command prompt.
In case your system does not have a compiler installed please follow the
instructions by Mathworks. This is required to compile some of the routine
for the user’s computer.

Before using SynEM for the first time run the setup.m file from the
SynEM main folder (the same folder that this readme file is located in)
with the SynEM main folder set to the working directory.

## Usage

Code was tested with MATLAB R2015b.

The package SynEM.Examples contains examples for running SynEM:
* synEMWorkflow.m: Direct test application of SynEM using only a volume
segmentation and raw data array
* neuron2neuronErrorEstimates.m: How to use the connectome error estimation
 (Fig. 3 in Staffler et al.)

To test run SynEM, execute the following Matlab command 
```
>> SynEM.Examples.synEMWorkflow
```
or
```
>> run('SynEM.Examples.synEMWorkflow.m')
```

