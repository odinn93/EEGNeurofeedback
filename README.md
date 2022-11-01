# EEGNeurofeedback
An EEG Neurofeedback program for treatment of motion sickness and other related illnesses. MATLAB based and designed to be used with the Muse 2 EEG headband, however it should work with any headset compatible with Neurofeedbacklab.

This was written in a few short months for a Master's Thesis in 2021 which required a lot of rough stiching together of available programs and packages, which were only available for use with MATLAB at the time. The intention was and still is to write it from the ground up in a cleaner and more efficient manner in C, Python or whatever else is appropriate. The new version may not be uploaded here, as I will not be handling the rewrite.

## Info on versions
There are technically three ways of using the program.
1) **Through MATLAB command line** \
this will require you to run the MainProgram.m file in \neurofeedbacklab-master\src
2) **The BioFeedbackTesting app** \
Opened through the Matlab app developer. This version has more features, intended to be used in a controlled testing environment
3) **The BioFeedback app** \
Simpler version intended to be compiled into a executable that can be installed on a test subject's personal computer

Check the comments under the "startupFcn(app)" function in the Biofeedback.mlapp file if you intend to compile the apps. The app developer isn't great at estimating which files it needs to include in the packaging. For greater chance of a successful compilation (at the cost of file size etc.) include every file you think might be relevant to your program.

## Dependencies:

NOTE: I may have missed some MATLAB packages required to run the program, but if so MATLAB should inform you of which packages are missing

### BlueMuse
Ideal for use on Windows. Enables easy connection to the Muse 2 headset through Bluetooth \
https://github.com/kowalej/BlueMuse

**Ideally you want to use LabStreamingLayer (LSL) when integrating everything into one simple package and/or working on another OS**

### Neurofeedbacklab
**Should not be needed as it is already set up in the repository, only if a clean install is required**\
Most of the code in this program is based on the older version that depends on BCILAB. See the 2020 branch of Neurofeedbacklab:\
https://github.com/arnodelorme/neurofeedbacklab/tree/version2020 \
The Main branch has a newer version of Neurofeedbacklab that has not been tested with the code yet. I expect some changes will have to be made:\
https://github.com/arnodelorme/neurofeedbacklab \
Please see other dependencies depending on which version you're using

### Psychtoolbox-3
http://psychtoolbox.org/
Remember to check dependencies. \
NOTE: Psychtoolbox is known to have issues when running on Windows. The issues can be supressed through a few commands in code, which is preapplied in this repository, but it is recommended to use Psychtoolbox on Linux (not tested with this code).

### GStreamer
Proper installation is discussed in the Psychtoolbox installation section. I mention this here because it is needed when running the app version of the program while the others aren't, so you might have missed that it is a dependency

### MATLAB Parallel Computing Toolbox
Download through MATLAB

## Other information
In the \neurofeedbacklab-master\src folder there are a bunch of files, some came with the Neurofeedbacklab repository. \
As mentioned earlier, ProgramMain.m runs the program but it references several of the other files which in turn reference others.
At least one of these files must be modified slightly when using on a new computer.
nfblab_options, in line 140, you need to change "BCILABpath" to wherever you installed the BCILAB folder, if using the older version of Neurofeedbacklab. This has not been tested with the new version.

Any file called "nfblab..." is from Neurofeedbacklab or a slight modification of one. It's best to go to that repository for further information.
Almost everything else is written during the Master's thesis project or from various other projects found on the internet. \
In those cases there are usually rather detailed comments included in the code that should hopefully help you understand how these files interact with each other. Start from MainProgram and work your way from there.
