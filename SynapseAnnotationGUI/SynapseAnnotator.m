function varargout = SynapseAnnotator(varargin)
% SYNAPSEANNOTATOR MATLAB code for SynapseAnnotator.fig
%      SYNAPSEANNOTATOR, by itself, creates a new SYNAPSEANNOTATOR or raises the existing
%      singleton*.
%
%      H = SYNAPSEANNOTATOR returns the handle to a new SYNAPSEANNOTATOR or the handle to
%      the existing singleton*.
%
%      SYNAPSEANNOTATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYNAPSEANNOTATOR.M with the given input arguments.
%
%      SYNAPSEANNOTATOR('Property','Value',...) creates a new SYNAPSEANNOTATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SynapseAnnotator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SynapseAnnotator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SynapseAnnotator

% Last Modified by GUIDE v2.5 03-Sep-2015 13:27:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SynapseAnnotator_OpeningFcn, ...
                   'gui_OutputFcn',  @SynapseAnnotator_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
try
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
catch err
    errordlg(sprintf('An error occurred and the error message was saved in the SynapseAnnotator.exe folder. Please send the error report to the developer. \n\nError message:\n %s \n',err.getReport('extended','hyperlinks','off')),'An error occured');
    save('ErrorReport.mat','err');
    rethrow(err);
end
% End initialization code - DO NOT EDIT

%#ok<*INUSL,*DEFNU>
% --- Executes just before SynapseAnnotator is made visible.
function SynapseAnnotator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% varargin   command line arguments to SynapseAnnotator (see VARARGIN)

% Choose default command line output for SynapseAnnotator
handles.output = hObject;

%draw pictograms
axes(handles.PrePostPictogram);
imshow('PrePost.png');
axes(handles.PostPrePictogram);
imshow('PostPre.png');
setAllowAxesZoom(zoom,handles.PrePostPictogram,0);
setAllowAxesZoom(zoom,handles.PostPrePictogram,0);

%start in interface view
handles.view = 'interface-rotated';
handles.highlightVoxels = false;
set(handles.InterfaceRotatedViewButton,'Value',1);
s = sprintf('Current view:\nInterface rotated');
set(handles.ViewStaticText,'String',s);
set(handles.IdentifyVoxelButton,'Enable','off');

%initialize black axes1 window
handles.interfaceImageSize = [140,140];
handles.numInterfaceImages = 60;
axes(handles.axes1);
imshow(zeros(handles.interfaceImageSize));
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = SynapseAnnotator_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                 Main Axis Panel                    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function CommentTextField_Callback(hObject, eventdata, handles)
comment = get(hObject,'String');
handles.comments{handles.currentInterfaceNumber} = comment;
guidata(hObject,handles);


function CommentTextField_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CommentTextField_KeyPressFcn(hObject, eventdata, handles)
if strcmp(eventdata.Key,'return');
%     %de- and refocus to save current text
%     uicontrol(handles.PictureNumberText);
%     uicontrol(handles.CommentChooserTextField);
    
    CommentTextField_Callback(hObject,eventdata,handles);
    
    %move focus to parent of button
    uicontrol(hObject);
    set(hObject,'enable','off');
    drawnow;
    set(hObject,'enable','on');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                    View Panel                      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function InterfaceRotatedViewButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles = getInterfaceNumber(handles);
    handles = untoggleViewButton(hObject,handles);
    handles.view = 'interface-rotated';
    handles = setUpView(handles);
    guidata(hObject,handles);
else
    msgbox('Choose other view mode to disable this one');
    set(hObject,'Value',1);
end


function InterfaceXYViewButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles = getInterfaceNumber(handles);
    handles = untoggleViewButton(hObject,handles);
    handles.view = 'interface-xy';
    handles = setUpView(handles);
    guidata(hObject,handles);
else
    msgbox('Choose other view mode to disable this one');
    set(hObject,'Value',1);
end


function InterfaceXZViewButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles = getInterfaceNumber(handles);
    handles = untoggleViewButton(hObject,handles);
    handles.view = 'interface-xz';
    handles = setUpView(handles);
    guidata(hObject,handles);
else
    msgbox('Choose other view mode to disable this one');
    set(hObject,'Value',1);
end


function InterfaceYZViewButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles = getInterfaceNumber(handles);
    handles = untoggleViewButton(hObject,handles);
    handles.view = 'interface-yz';
    handles = setUpView(handles);
    guidata(hObject,handles);
else
    msgbox('Choose other view mode to disable this one');
    set(hObject,'Value',1);
end


function ExploreXYViewButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles = getInterfaceNumber(handles);
    handles = untoggleViewButton(hObject,handles);
    handles.view = 'explore-xy';
    handles = setUpView(handles);
    guidata(hObject,handles);
else
    msgbox('Choose other view mode to disable this one');
    set(hObject,'Value',1);
end


function ExploreXZViewButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles = getInterfaceNumber(handles);
    handles = untoggleViewButton(hObject,handles);
    handles.view = 'explore-xz';
    handles = setUpView(handles);
    guidata(hObject,handles);
else
    msgbox('Choose other view mode to disable this one');
    set(hObject,'Value',1);
end


function ExploreYZViewButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    handles = getInterfaceNumber(handles);
    handles = untoggleViewButton(hObject,handles);
    handles.view = 'explore-yz';
    handles = setUpView(handles);
    guidata(hObject,handles);
else
    msgbox('Choose other view mode to disable this one');
    set(hObject,'Value',1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%               Movie Player Panel                   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function PlayButton_Callback(hObject, eventdata, handles)
startStopVideo(hObject,eventdata,handles);


function HighlightAndPlayButton_Callback(hObject, eventdata, handles)
highlightAndPlay(hObject,handles);


function PreviousImageButton_Callback(hObject, eventdata, handles)
%go to previous image if current image is not the first one
if handles.currentImage > 1
    handles.currentImage = handles.currentImage - 1;
    updateImage(hObject,handles);
end


function NextImageButton_Callback(hObject, eventdata, handles)
%go the next image if current image is not last one
if handles.currentImage < handles.lastImage
    handles.currentImage = handles.currentImage + 1;
    updateImage(hObject,handles);
end


function GoToFirstImageButton_Callback(hObject, eventdata, handles)
handles.currentImage = 1;
updateImage(hObject,handles);


function GoTenImagesBackButton_Callback(hObject, eventdata, handles)
%go ten images back if possible
if (handles.currentImage - 10) > 0
    handles.currentImage = handles.currentImage - 10;
else
    handles.currentImage = 1;
end
updateImage(hObject,handles);


function GoTenImagesFurtherButton_Callback(hObject, eventdata, handles)
%jump ten images further if possible
if (handles.currentImage + 10) <= handles.lastImage
    handles.currentImage = handles.currentImage + 10;
else
    handles.currentImage = handles.lastImage;
end
updateImage(hObject,handles);


function HighlightSegmentsCheckbox_Callback(hObject, eventdata, handles)
if get(hObject,'Value') == 1
    handles.highlightSegments = true;
else
    handles.highlightSegments = false;
end
updateImage(hObject,handles);


function HighlightVoxelsCheckbox_Callback(hObject, eventdata, handles)
if get(hObject,'Value') == 1
    handles.highlightVoxels = true;
else
    handles.highlightVoxels = false;
end
updateImage(hObject,handles);


function GoToLastImageButton_Callback(hObject, eventdata, handles)
handles.currentImage = handles.lastImage;
updateImage(hObject,handles);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%               Interface Chooser Panel              %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function InterfaceChooserTextField_Callback(~, ~, ~)


function InterfaceChooserTextField_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function InterfaceChooserTextField_KeyPressFcn(hObject, eventdata, handles)
if strcmp(eventdata.Key,'return');
    %de- and refocus to save current text
    uicontrol(handles.PictureNumberText);
    uicontrol(handles.InterfaceChooserTextField);
    InterfaceChooserButton_Callback(hObject,eventdata,handles);
end


function InterfaceChooserButton_Callback(hObject, eventdata, handles)
%read input from InterfaceChooserTextField
input = str2double(get(handles.InterfaceChooserTextField,'String'));
if isnan(input) || ~(input == floor(input)) || input < 0
    msgbox('Specify a integer number greater than zero.','Error');
    set(handles.InterfaceChooserTextField,'String',handles.currentInterfaceNumber);
else
    %focus on specified interface (or last interface if input exceeds number of
    %interfaces)
    if input <= size(handles.data.interfaceSurfaceList,1)
        handles.currentInterfaceNumber = input;
    elseif input > size(handles.data.interfaceSurfaceList,1)
        handles.currentInterfaceNumber = size(handles.data.interfaceSurfaceList,1);
        set(handles.InterfaceChooserTextField,'String',num2str(size(handles.data.interfaceSurfaceList,1)));
    end
    switch handles.view
        case {'interface-rotated','interface-xy','interface-xz','interface-yz'}
            handles = displayInterface(handles);
        case {'explore-xy','explore-xz','explore-yz'}
            handles.annotationStatus = getAnnotationStatus(handles.currentInterfaceNumber, handles.interfaceLabels);
            set(handles.CommentTextField,'String',handles.comments{handles.currentInterfaceNumber});
            set(handles.AnnotationStatusStaticText,'String',sprintf('Annotation status:\n%s',handles.annotationStatus));
            handles = getHighlightedSegments(handles,[]);
            
            updateImage(hObject,handles);
    end
    guidata(hObject,handles);
    %move focus to parent of button
    uicontrol(hObject);
    set(hObject,'enable','off');
    drawnow;
    set(hObject,'enable','on');
end


function NextInterfaceButton_Callback(hObject, eventdata, handles)
if handles.currentInterfaceNumber < size(handles.data.interfaceSurfaceList,1)
    handles.currentInterfaceNumber = handles.currentInterfaceNumber + 1;
    set(handles.InterfaceChooserTextField,'String',num2str(handles.currentInterfaceNumber));
    InterfaceChooserButton_Callback(hObject, eventdata, handles);
else
    msgbox('This is the last interface.','Info');
end


function NextSynapseButton_Callback(hObject, eventdata, handles)
indices = find(handles.interfaceLabels < 3 & handles.interfaceLabels > 0);
if isempty(indices)
    msgbox('There are no interfaces annotated as synaptic.');
else
    [~,idx] = min(mod(indices - handles.currentInterfaceNumber - 1, length(handles.data.interfaceSurfaceList)));
    handles.currentInterfaceNumber = indices(idx);
    set(handles.InterfaceChooserTextField,'String',num2str(handles.currentInterfaceNumber));
    InterfaceChooserButton_Callback(hObject, eventdata, handles);
end


function NextPredictedSynapseButton_Callback(hObject, eventdata, handles)
if isempty(handles.synapsePrediction)
    msgbox('No predictions available','Info');
else
    indices = find(handles.synapsePrediction == 1);
        if isempty(indices)
            msgbox('There are no interfaces marked as ''Undecided''','Info');
        else
            [~,idx] = min(mod(indices - handles.currentInterfaceNumber - 1, length(handles.data.interfaceSurfaceList)));
            handles.currentInterfaceNumber = indices(idx);
            set(handles.InterfaceChooserTextField,'String',num2str(handles.currentInterfaceNumber));
            InterfaceChooserButton_Callback(hObject, eventdata, handles);
        end
end


function nextUndecidedButton_Callback(hObject, eventdata, handles)
%get all interfaces labelled as undecided
indices = find(handles.undecidedList);
if isempty(indices)
    msgbox('There are no interfaces marked as ''Undecided''','Info');
else
    %find next interface annotated as 'undecided'
    [~,idx] = min(mod(indices - handles.currentInterfaceNumber - 1, length(handles.data.interfaceSurfaceList)));
    handles.currentInterfaceNumber = indices(idx);
    set(handles.InterfaceChooserTextField,'String',num2str(handles.currentInterfaceNumber));
    InterfaceChooserButton_Callback(hObject, eventdata, handles);
end


function nextUnlabeledButton_Callback(hObject, eventdata, handles)
%get all unlabeled interfaces
indices = find(handles.interfaceLabels == 0);
if isempty(indices)
    msgbox('There are no unlabeled interfaces.','Info');
else
    %find next interface without annotation
    [~,idx] = min(mod(indices - handles.currentInterfaceNumber - 1, length(handles.data.interfaceSurfaceList)));
    handles.currentInterfaceNumber = indices(idx);
    set(handles.InterfaceChooserTextField,'String',num2str(handles.currentInterfaceNumber));
    InterfaceChooserButton_Callback(hObject, eventdata, handles);
end


function IdentifyVoxelButton_Callback(hObject, eventdata, handles)
[x,y] = myginput(1,'crosshair');
coordinates = determineCoordinate(handles,round(x),round(y));
globalCoordinates = coordinates + handles.metadata.bboxSmall(:,1)' - [102, 102, 42];
interfaceNumber = findCoordinate(handles,coordinates);
message = sprintf('Voxel coordinates are: %s \n',mat2str(coordinates));
message = [message,sprintf('Global coordinates are: %s \n',mat2str(globalCoordinates))];
if (isscalar(interfaceNumber) == 1 && interfaceNumber ~= 0)
    message = [message,sprintf('This voxel belongs to interface %s.',num2str(interfaceNumber))];
elseif size(interfaceNumber,2) > 1
    for i= 1:size(interfaceNumber,1)
        message = [message,sprintf('This voxel belongs to subsegment %s of interface %s.\n',num2str(interfaceNumber(i,2)),num2str(interfaceNumber(i,1)))]; %#ok<AGROW>
    end
else
    message = [message,sprintf('This voxel could not be found.')];
end
msgbox(message,'Info');


function FurtherInterfaceChooserToggleButton_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(handles.FurtherInterfaceChooserPanel,'Visible','on');
    set(handles.FurtherInterfaceChooserToggleButton,'String','<<');
    set(handles.FurtherInterfaceChooserToggleButton,'TooltipString','Hide further options');
else
    set(handles.FurtherInterfaceChooserPanel,'Visible','off');
    set(handles.FurtherInterfaceChooserToggleButton,'String','>>');
    set(handles.FurtherInterfaceChooserToggleButton,'TooltipString','Display further options');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%             Interface Annotation Panel               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function PrePostButton_Callback(hObject, eventdata, handles)
handles = labelInterface(handles,hObject,1);
%go automatically to next interface
NextInterfaceButton_Callback(hObject, eventdata, handles);


function PostPreButton_Callback(hObject, eventdata, handles)
handles = labelInterface(handles,hObject,2);
%go automatically to next interface
NextInterfaceButton_Callback(hObject, eventdata, handles);


function NoSynapseButton_Callback(hObject, eventdata, handles)
handles = labelInterface(handles,hObject,3);
%go automatically to next interface
NextInterfaceButton_Callback(hObject, eventdata, handles);


function UndecidedButton_Callback(hObject, eventdata, handles)
handles = labelInterface(handles,hObject,4);
%go automatically to next interface
NextInterfaceButton_Callback(hObject, eventdata, handles);


function UndecidedCheckbox_Callback(hObject, eventdata, handles)
handles.undecidedList(handles.currentInterfaceNumber) = get(hObject,'Value');
guidata(hObject,handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%               Voxel Annotation Panel               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function VoxelLabelSynapsesButton_Callback(hObject, eventdata, handles)
synapseIndices = handles.interfaceLabels < 3;
synapses = handles.data.interfaceSurfaceList(synapseIndices);
for k = 1:length(synapses)
    handles.voxelLabels(synapses{k}) = true;
end
switch handles.view
    case {'interface-rotated','interface-xy','interface-xz','interface-yz'}
        handles = displayInterface(handles);
    case 'explore-xy'
        handles = getHighlightedVoxels(handles,handles.voxelLabels);
    case 'explore-xz'
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[1 3 2]));
    case 'explore-yz'
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[2 3 1]));
end
updateImage(hObject,handles);
guidata(hObject,handles);


function VoxelLabelToggleButton_Callback(hObject, ~, ~)
while get(hObject,'value')
    handles = guidata(hObject);
    set(gca,'hittest','off');
    [x,y,button] = myginput(1,'crosshair');
    coordinates = determineCoordinate(handles,round(x),round(y));
    switch button
        case 1
            handles.voxelLabels(coordinates(1),coordinates(2),coordinates(3)) = true;
            handles.currentHighlightedVoxels(round(y),round(x),:,handles.currentImage) = [255,0,255];
            handles.voxelAlphaData(round(y),round(x),handles.currentImage) = true;
        case 3
            handles.voxelLabels(coordinates(1),coordinates(2),coordinates(3)) = false;
            handles.currentHighlightedVoxels(round(y),round(x),handles.currentImage) = false;
            handles.voxelAlphaData(round(y),round(x),handles.currentImage) = false;
        case 2
            set(hObject,'value',false);
    end
    guidata(hObject,handles);
    handles = guidata(hObject);
    updateImage(hObject,handles);
end


function LabelVoxelBigButton_Callback(hObject, ~, ~)
while get(hObject,'value')
    handles = guidata(hObject);
    set(gca,'hittest','off');
    [x,y,button] = myginput(1,'crosshair');
    coordinates = determineCoordinate(handles,round(x),round(y));
    gridSize = get(handles.GridSizeMenu,'Value');
    switch button
        case 1
            switch handles.view
                case {'explore-xy','conSyn  tact-xy'}
                    handles.voxelLabels(coordinates(1) - gridSize:coordinates(1) + gridSize,coordinates(2) - gridSize:coordinates(2) + gridSize,coordinates(3)) = true;
                case {'explore-xz','interface-xz'}
                    handles.voxelLabels(coordinates(1) - gridSize:coordinates(1) + gridSize,coordinates(2),coordinates(3) - gridSize:coordinates(3) + gridSize) = true;
                case {'explore-yz','interface-yz'}
                    handles.voxelLabels(coordinates(1),coordinates(2) - gridSize:coordinates(2) + gridSize,coordinates(3) - gridSize:coordinates(3) + gridSize) = true;
            end
            handles.currentHighlightedVoxels(round(y) - gridSize:round(y) + gridSize,round(x) - gridSize:round(x) + gridSize,:,handles.currentImage) = cat(3,255.*ones(2*gridSize + 1),zeros(2*gridSize + 1),255.*ones(2*gridSize + 1));
            handles.voxelAlphaData(round(y) - gridSize:round(y) + gridSize,round(x) - gridSize:round(x) + gridSize,handles.currentImage) = true;
        case 3
            switch handles.view
                case {'explore-xy','interface-xy'}
                    handles.voxelLabels(coordinates(1) - gridSize:coordinates(1) + gridSize,coordinates(2) - gridSize:coordinates(2) + gridSize,coordinates(3)) = false;
                case {'explore-xz','interface-xz'}
                    handles.voxelLabels(coordinates(1) - gridSize:coordinates(1) + gridSize,coordinates(2),coordinates(3) - gridSize:coordinates(3) + gridSize) = false;
                case {'explore-yz','interface-yz'}
                    handles.voxelLabels(coordinates(1),coordinates(2) - gridSize:coordinates(2) + gridSize,coordinates(3) - gridSize:coordinates(3) + gridSize) = false;
            end
            handles.currentHighlightedVoxels(round(y) - gridSize:round(y) + gridSize,round(x) - gridSize:round(x) + gridSize,:,handles.currentImage) = 255.*ones(2*gridSize + 1,2*gridSize + 1,3);
            handles.voxelAlphaData(round(y) - gridSize:round(y) + gridSize,round(x) - gridSize:round(x) + gridSize,handles.currentImage) = false;
        case 2
            set(hObject,'value',false);
    end
    guidata(hObject,handles);
    handles = guidata(hObject);
    updateImage(hObject,handles);
end


function LabelLineButton_Callback(hObject, eventdata, handles)
if any(strcmp(handles.view,{'explore-xy','interface-xy','explore-xz','interface-xz','explore-yz','interface-yz'}))
    stillPointing = true;
    points = [];
    while stillPointing
        handles = guidata(hObject);
        set(gca,'hittest','off');
        [x,y,button] = myginput(1,'crosshair');
        points = cat(1,points,[round(x),round(y),handles.currentImage]);
        switch button
            case 3
                stillPointing = false;
            case 2
                return;
        end
    end
    handles = labelLine(handles,points);
    guidata(hObject,handles);
    handles = guidata(hObject);
    updateImage(hObject,handles);
else
    errordlg('Label line not available in rotated view.');
end


function GridSizeMenu_Callback(~, ~, ~)


function GridSizeMenu_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function InterfaceToVoxelButton_Callback(hObject, eventdata, handles)
synapseIndices = handles.data.interfaceSurfaceList{handles.currentInterfaceNumber};
handles.voxelLabels(synapseIndices) = true;
switch handles.view
    case {'interface-rotated','interface-xy','interface-xz','interface-yz'}
        handles = displayInterface(handles);
    case 'explore-xy'
        handles = getHighlightedVoxels(handles,handles.voxelLabels);
    case 'explore-xz'
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[1 3 2]));
    case 'explore-yz'
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[2 3 1]));
end
updateImage(hObject,handles);
guidata(hObject,handles);


function UnlabelInterfaceToVoxelButton_Callback(hObject, eventdata, handles)
synapseIndices = handles.data.interfaceSurfaceList{handles.currentInterfaceNumber};
handles.voxelLabels(synapseIndices) = false;
switch handles.view
    case {'interface-rotated','interface-xy','interface-xz','interface-yz'}
        handles = displayInterface(handles);
    case 'explore-xy'
        handles = getHighlightedVoxels(handles,handles.voxelLabels);
    case 'explore-xz'
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[1 3 2]));
    case 'explore-yz'
        handles = getHighlightedVoxels(handles,permute(handles.voxelLabels,[2 3 1]));
end
updateImage(hObject,handles);
guidata(hObject,handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                     IO Panel                       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function SaveButton_Callback(hObject, eventdata, handles)
set(handles.InfoStaticText,'String','Saving ...');
set(handles.InfoStaticText,'Visible','on');
saveAnnotations(handles, false);
set(handles.InfoStaticText,'Visible','off');
handles.hasUnsavedAnnotations = false;
guidata(hObject, handles);


function ExportAnnotationsButton_Callback(hObject, eventdata, handles)
%save labels only
saveAnnotations(handles,true);


function SaveButtonToolbar_ClickedCallback(hObject, eventdata, handles)
%same functionality as SaveButton
SaveButton_Callback(hObject,eventdata,handles);


function LoadButton_Callback(hObject, eventdata, handles)
if isfield(handles,'data');
    handles.view = 'interface-rotated';
    set(handles.InterfaceRotatedViewButton,'Value',1);
    set(handles.InterfaceXYViewButton,'Value',0);
    set(handles.InterfaceXZViewButton,'Value',0);
    set(handles.InterfaceYZViewButton,'Value',0);
    set(handles.ExploreXYViewButton,'Value',0);
    set(handles.ExploreXZViewButton,'Value',0);
    set(handles.ExploreYZViewButton,'Value',0);
    handles.highlightVoxels = false;
    handles = setUpView(handles);
    guidata(hObject,handles);
end
axes(handles.axes1);
imshow(zeros(handles.interfaceImageSize));
set(handles.InfoStaticText,'String','Loading ...');
set(handles.InfoStaticText,'Visible','on')
[handles, loadSuccessful] = loadData(handles);
set(handles.InfoStaticText,'Visible','off');
if loadSuccessful
    handles.currentInterfaceNumber = 1;
    handles = displayInterface(handles);
    %write annotation status to textfield
    handles.annotationStatus = getAnnotationStatus(handles.currentInterfaceNumber, handles.interfaceLabels);
%     set(handles.AnnotationStatusStaticText,'String',sprintf('Annotation status:\n%s',handles.annotationStatus));
    handles.hasUnsavedAnnotations = false;
    guidata(hObject,handles);
else
    msgbox('Loading failed because file did not contain a dataset.','Error');
    %restore previous image
    if isfield(handles,'currentInterfaceNumber')
        displayInterface(handles);
    end
end


function LoadButtonToolbar_ClickedCallback(hObject, eventdata, handles)
%same functionality as LoadButton
LoadButton_Callback(hObject,eventdata,handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                       Misc                         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function SynapseAnnotatorGUI_CloseRequestFcn(hObject, eventdata, handles)
%initialized field if it does not exist(otherwise user can not close
%window if he did not load any data)
if ~isfield(handles,'hasUnsavedAnnotations')
    handles.hasUnsavedAnnotations = false;
end
%check for unsaved annotations and warn user via a questdlg
if(handles.hasUnsavedAnnotations)
    selection = questdlg( ...
        'You have unsaved annotations. Do you really want to quit?', ...
        'Exit Message','Save annotations and quit', ...
        'Quit without saving', ...
        'Don''t quit', ...
        'Don''t quit');
    switch selection
        case 'Save annotations and quit'
            saveAnnotations(handles);
            delete(hObject);
        case 'Quit without saving'
            delete(hObject);
        case 'Don''t quit'
    end
else
    delete(hObject);
end


function LabelList_ClickedCallback(hObject, eventdata, handles)
try
    annotationStatusString = arrayfun(@(x)getAnnotationStatus(x,handles.interfaceLabels),1:length(handles.data.interfaceSurfaceList),'UniformOutput',false);
    f = figure;
    t = uitable('Parent',f,'ColumnName',{'Interface Number','Label','Comment'},'ColumnFormat',{'char','char','char'},'ColumnWidth',{'auto',150,'auto'},'RowName',[],'Position',[20 10 500 400]);
    set(t,'Data',[num2cell(1:length(handles.data.interfaceSurfaceList))',annotationStatusString',handles.comments]);
catch error
    errordlg('Could not retrieve data information');
    fprintf('%s',getReport(error));
end


function InfoUIToggleTool_ClickedCallback(hObject, eventdata, handles)
try
    bboxBig = '';
    if isfield(handles.metadata, 'bboxBig')
        bboxBig = mat2str(handles.metadata.bboxBig);
    elseif isfield(handles.metadata, 'boundingBox')
        bboxBig = mat2str(handles.metadata.boundingBox);
    end
    experiment = '';
    if isfield(handles.metadata, 'experiment') && ...
            ~isempty(handles.metadata.experiment)
        experiment = handles.metadata.experiment;
    end
    segmentation = '';
    if isfield(handles.metadata, 'segmentation') && ...
            ~isempty(handles.metadata.segmentation)
        segmentation = handles.metadata.segmentation;
    end
    bboxSmall = '';
    if isfield(handles.metadata, 'bboxSmall')
        bboxBig = mat2str(handles.metadata.bboxSmall);
    elseif isfield(handles.metadata, 'innerBoundingBox')
        bboxBig = mat2str(handles.metadata.innerBoundingBox);
    end
    rinclude = '';
    if isfield(handles.metadata, 'rinclude')
        rinclude = mat2str(handles.metadata.rinclude);
    end
    message = sprintf('%s %s\n%s %s\n%s %s\n%s %s\n%s %s\n%s %s\n\n%s\n%s %s\n%s %s\n%s %s\n%s %s', ...
        'Total number of interfaces:', ...
        num2str(size(handles.data.interfaceSurfaceList,1)), ...
        'Annotated as Pre(green) | Post(blue):', ...
        num2str(sum(handles.interfaceLabels == 1)),...
        'Annotated as Pre(blue) | Post(green):', ...
        num2str(sum(handles.interfaceLabels == 2)),...
        'Annotated as No Synapse:', ...
        num2str(sum(handles.interfaceLabels == 3)),...
        'Marked as Undecided:', ...
        num2str(sum(handles.undecidedList)),...
        'Not annotated yet:', ...
        num2str(sum(handles.interfaceLabels == 0)),...
        'Info on current EM data:', ...
        'Experiment:', experiment, ...
        'Segmentation: ', segmentation, ...
        'Bounding box:', bboxBig, ...
        'Inner bounding box:', bboxSmall, ...
        'Included subsegment distance:', rinclude);
    msgbox(message,'Info');
catch error
    message = sprintf('%s','Could not retrieve data information');
    errordlg(message);
    fprintf('%s',getReport(error));
end


function ZoomInButton_Callback(~, ~, handles)
% zoom(2);
zoom(handles.SynapseAnnotatorGUI,2);


function ZoomOutButton_Callback(~, ~, handles)
zoom(handles.SynapseAnnotatorGUI,0.5);


function DeveloperToolsButton_ClickedCallback(hObject, eventdata, handles)
[hObject,handles] = developerToolsButton( hObject,handles );
guidata(hObject,handles);


function HelpTool_ClickedCallback(~, ~, ~)
message = sprintf('Shortcut list\n\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n',...
    'leftarrow - previous image','rightarrow - next image', ...
    'l - label line button','h - highlight segments checkbox', ...
    '1 - PrePost button','2 - PostPre button','3 - NoSynapse button');
msgbox(message,'Info');


function LoadPredictionsButton_Callback(hObject, eventdata, handles)
handles = loadPredictions(handles);
guidata(hObject,handles);


function SizeCutoffButton_Callback(hObject, eventdata, handles)
input = str2double(get(handles.CutoffTextField,'String'));
if isnan(input)
    sizeCutoff = 150;
else
    sizeCutoff = input;
end
lengthList = cellfun(@(x) length(x),handles.data.interfaceSurfaceList);
indices = lengthList > sizeCutoff;
handles.data.interfaceSurfaceList = handles.data.interfaceSurfaceList(indices);
if ~isempty(handles.data.subsegmentsList)
    handles.data.subsegmentsList = cellfun(@(x)x(indices,:), ...
        handles.data.subsegmentsList, 'UniformOutput', false);
end
handles.data.neighborIDs = handles.data.neighborIDs(indices,:);
handles.interfaceLabels = handles.interfaceLabels(indices);
handles.undecidedList = handles.undecidedList(indices);
guidata(hObject,handles);
GoToFirstImageButton_Callback(hObject, eventdata, handles);


function CutoffTextField_Callback(~, ~, ~)


function CutoffTextField_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SavePicButton_Callback(hObject, eventdata, handles)
[fileName,filePath] = uiputfile('Image.tif','Save axis as');
fr = getframe(handles.axes1);
im = fr.cdata;
imwrite(im,[filePath, fileName],'tiff','Compression','none');


function SaveRawData_Callback(hObject, eventdata, handles)
[fileName,filePath] = uiputfile('Image.tif','Save axis as');
im = handles.currentImageData(:,:,handles.currentImage);
imwrite(im,[filePath, fileName],'tiff','Compression','none');


function SaveToStackButton_Callback(hObject, eventdata, handles)
if ~isfield(handles,'stackData')
    handles.stackData.X = zeros(141,141,0);
    handles.stackData.Y = false(0);
end
handles.stackData.X = cat(3,handles.stackData.X,handles.currentImageData(:,:,handles.currentImage));
handles.stackData.Y = cat(1,handles.stackData.Y,handles.interfaceLabels(handles.currentInterfaceNumber) < 3);
guidata(hObject,handles);


function ExportStackButton_Callback(hObject, eventdata, handles)
[fileName,filePath] = uiputfile('Stack.mat','Save stack in');
m = matfile([filePath, fileName],'Writable',true);
m.X = handles.stackData.X;
m.Y = handles.stackData.Y;


function SynapseAnnotatorGUI_KeyPressFcn(hObject, eventdata, handles)
switch eventdata.Key
    case 'leftarrow'
        PreviousImageButton_Callback(hObject,eventdata,handles);
    case 'rightarrow'
        NextImageButton_Callback(hObject,eventdata,handles);
    case 'l'
        LabelLineButton_Callback(hObject,eventdata,handles);
    case 'h'
        if handles.highlightSegments
            set(handles.HighlightSegmentsCheckbox,'Value',0);
            handles.highlightSegments = false;
        else
            set(handles.HighlightSegmentsCheckbox,'Value',1);
            handles.highlightSegments = true;
        end
        updateImage(hObject,handles);
        guidata(hObject,handles);
    case '1'
        hObject = handles.PrePostButton;
        handles = labelInterface(handles,hObject,1);
        %go automatically to next interface
        NextInterfaceButton_Callback(hObject, eventdata, handles);
    case '2'
        hObject = handles.PostPreButton;
        handles = labelInterface(handles,hObject,1);
        %go automatically to next interface
        NextInterfaceButton_Callback(hObject, eventdata, handles);
    case '3'
        hObject = handles.NoSynapseButton;
        handles = labelInterface(handles,hObject,1);
        %go automatically to next interface
        NextInterfaceButton_Callback(hObject, eventdata, handles);
        
end
