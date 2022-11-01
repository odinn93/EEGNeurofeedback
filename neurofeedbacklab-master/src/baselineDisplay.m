%%%IMPORTANT%%%°

%Because my laptop has a 'hybrid' graphics card, psychtoolbox can't run
%proper tests on Windows. Try running the code without Screen('Preference', 'SkipSyncTests', 1);
%but if it crashes shortly after you'll need to include it. You might
%want to see if you can fix it using the instructions provided by the 
%command 'help SyncTrouble'

function baselineDisplay()

Screen('Preference', 'VisualDebugLevel', 1);
Screen('Preference', 'SkipSyncTests', 1);

%This program generates a black screen with a red dot in the middle for use
%in generating a baseline.

PsychDefaultSetup(2);
screens = Screen('Screens');

%% Settings %%
%Modify the following settings as you wish or use the default settings:

%Monitor in use, returns a value counting from 0, 1, 2 etc.
%By default, it uses the monitor with the highest assigned value, which
%most likely will be an external monitor. Set to 0 if you want to use the
%main monitor (unnecessary if there is only one).
screenNumber = max(screens);

%Color codes
red = [1 0 0];
green = [0 1 0];
blue = [0 0 1];
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white/2;

%Color settings
cDotColor = red;        %Dot in center of screen
screenColor = black;    %Background

%Size settings
cDotSize = 20;          %Center dot

%Maze pattern
%An MxN array is randomly generated and the values are used as coordinates
%for each "pixel". For a 16:9 display (a typical widescreen monitor),
%M=N=110 is ideal. For a 16:10 display, try M=N=90. This ensures that the 
%dots will fill the entire screen, although note that some systems might
%struggle with animating so many pixels.
M = 110;
N = 110;
sc = 30; %Scaling factor, controls the size of each maze pixel. Note that
         %smaller pixels will require a larger MxN. It's also recommended
         %that you reduce MxN when sc is increased for performance reasons.
         
%Speed settings
angles = 1;         %Initial rotation speed (not in use atm)

%Time settings
initialWait = 5;   %Time before spinning starts
spinTime = 35;      %Duration of spinning animation
afterWait = 5;     %Time where the maze stays still before end of program

%% Start of program %%

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Set up alpha-blending for smooth (anti-aliased) textures
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

CenterdotXpos = screenXpixels/2;
CenterdotYpos = screenYpixels/2;

%Code for generating maze
T = M*N;
A = zeros(M,N); 
for i = 1:M
    for j = 1:N
        A(i,j) = randi([0 1]);
    end
end

%NOTE: A pattern can be manually created by filling a MxN array with 1s and
%0s, where 1 represent a white pixel and 0 a black pixel.

grill = A;

% Make the grill into a texure 
checkerTexture = Screen('MakeTexture', window, grill);

% We will scale our texure up to 100 times its current size be defining a
% larger screen destination rectangle
[s1, s2] = size(grill);
dstRect = [0 0 s1 s2] .* sc;

% We position the squares in the middle of the screen in Y, spaced equally
% scross the screen in X
posXs = screenXpixels/2;
posYs = screenYpixels/2;

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 0.1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

filterMode = 0;

        posX = posXs;
        posY = posYs;
        angle = angles;

dstRect = CenterRectOnPointd(dstRect, posX, posY);

%Set the background color as black
Screen('FillRect', window, screenColor)

%Draw the center dot
Screen('DrawDots', window, [CenterdotXpos CenterdotYpos], cDotSize,...
    cDotColor, [], 2);
vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

WaitSecs(initialWait);

feedback = 0;
start = tic;
stop = 0;
while ~KbCheck
    
    Screen('FillRect', window, screenColor)
    
    % Draw the grill texture to the screen. By default bilinear
    % filtering is used. For this example we don't want that, we want
    %nearest neighbour so we change the filter mode to zero
    filterMode = 0;

        posX = posXs;
        posY = posYs;
        angle = angles;

    dstRect = CenterRectOnPointd(dstRect, posX, posY);

        %Translate, rotate, re-tranlate and then draw our square
        %Screen('glPushMatrix', window)
        Screen('glTranslate', window, posX, posY)
        Screen('glRotate', window, angle, 0, 0);
        Screen('glTranslate', window, -posX, -posY)
   

    Screen('DrawDots', window, [CenterdotXpos CenterdotYpos], cDotSize,...
        cDotColor, [], 2);
    
    %Flip to the screen
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
     
     stop = toc(start);
     if stop >= spinTime
         WaitSecs(afterWait);
         break
     end 
end
sca;
end