%% Run this when starting ('Run Section')
%It creates the parallel processing pools, but while they are open running
%this again can cause errors
%Wait until the icon in the bottom left corner of MATLAB no longer says
%"Busy" and only displays a set of blue or green squares before continuing.

parpool(2);
myCluster = parcluster('local');
%% Once the pools are open, run this using 'Run Section' until you are done.
%I recommend restarting the stream before every run, because it has a time-
%out timer that I don't know how to change and it can shut down mid-run.
s1 = input('Do you want to run a baseline now (y/n)?', 's');
    if strcmpi(s1, 'y')
        runmode = 'base';
    elseif strcmpi(s1, 'n')
        s2 = input('Do you want to run (b)iofeedback or (c)onstant velocity?', 's');
        if strcmpi(s2, 'b')
            runmode = 'feedback';
        elseif strcmpi(s2, 'c')
            runmode = 'constant';
        else error('unknown option');
        end
    else error('Unknown option');
    end
if strcmpi(runmode, 'base')
    baselineDisplay;
    s3 = input('Do you want to run the program (y/n)?', 's');
    if strcmpi(s3, 'y')
        s2 = input('(b)iofeedback or (c)onstant velocity?', 's');
        if strcmpi(s2, 'b')
            runmode = 'feedback';
        elseif strcmpi(s2, 'c')
            runmode = 'constant';
        else error('unknown option');
        end
    elseif strcmpi(s3, 'n')
        msg = "Program aborted";
        msgbox(msg);
        return;
    else error('Unknown option');
    end
end

if strcmpi(runmode, 'constant')
    s5 = input('(s)low, (m)edium or (f)ast?', 's');
    if strcmpi(s5, 's') || strcmpi(s5, 'm') || strcmpi(s5, 'f')
        1;
    else error('Unknown option');
    end
end

if ~strcmpi(runmode, 'feedback') && ~strcmpi(runmode, 'constant')
    error('Wrong run type')
end

asrFiles = dir('asr_baseline*.mat');
        if isempty(asrFiles)
            error('No baseline file found in current folder, run baseline first');
        else
            fprintf('\nBaseline files available in current folder:\n');
            for iFile = 1:length(asrFiles)
                fprintf('%d - %s\n', iFile, asrFiles(iFile).name);
            end
            fprintf('------\n');
            iFile = input('Enter file number above to use for baseline:');
            fileNameAsr = asrFiles(iFile).name;
        end
            
WaitSecs(1);

start = 0;
d1 = '2021-03-15 16:00:00'; %A series of reference time values used to
d2 = '2021-03-15 16:00:15'; %indicate when the program should start.
d3 = '2021-03-15 16:00:30'; %Only the second marks are read in the
d4 = '2021-03-15 16:00:45'; %while loop below that they are used for,
t1 = datetime(d1,'Format','ss'); %the date, hour etc. are just there
t2 = datetime(d2,'Format','ss'); %for formatting reasons. If you wan't
t3 = datetime(d3,'Format','ss'); %to change when the program is allowed
t4 = datetime(d4,'Format','ss'); %to start, only change the seconds in 
s1 = second(t1); %d1, d2, d3 and d4. If you want fewer start times,
s2 = second(t2); %e.g. you want to remove d3 and d4, it is enought to 
s2 = second(t3); %just remove isequal(timeNow,s3) and isequal(timeNow,s4)
s2 = second(t4); %from the while loop below. 
    
while(start == 0)
    timeNow = datetime('now','TimeZone','local','Format','ss');
    timeNow = floor(second(timeNow));
    if isequal(timeNow,s1) || isequal(timeNow,s2) || isequal(timeNow,s2) || isequal(timeNow,s2)
        start = 1;
    end
end

if strcmpi(runmode, 'constant')
    if strcmpi(s5, 's')
        spmd(2)
            if labindex == 1
                EEGreaderNoFeedback(fileNameAsr);
            else
                EEGconstant('s');
            end
        end
    elseif strcmpi(s5, 'm')
        spmd(2)
            if labindex == 1
                EEGreaderNoFeedback(fileNameAsr);
            else
                EEGconstant('m');
            end
        end
    elseif strcmpi(s5, 'f')
        spmd(2)
            if labindex == 1
                EEGreaderNoFeedback(fileNameAsr);
            else
                EEGconstant('f');
            end
        end
    else error('Unknown option');
    end
elseif strcmpi(runmode, 'feedback')
    spmd(2)
        if labindex == 1
            EEGreader(fileNameAsr);
        else
            EEGfeedback;
        end
    end
else error('Wrong run type')
end
%% Run this when you're done or run into problems and need to resart
delete(myCluster.Jobs);
clear all
close all