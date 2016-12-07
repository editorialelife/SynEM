function handles = setFieldsForNewInterface( handles )
%SETFIELDSFORNEWINTERFACE Reseting fields for new interface
%   This function disables the checkboxes and loads the text fields for a
%   new interface.

%reset check checkboxes
handles.highlightSegments = true;
set(handles.HighlightSegmentsCheckbox,'Value',1);
handles.drawInterfaceNormal = false;

%set text fields for new interface
set(handles.PictureNumberText,'String',strcat(num2str(handles.currentImage),'/',num2str(handles.lastImage)));
set(handles.AnnotationStatusStaticText,'String',sprintf('Annotation status:\n%s',handles.annotationStatus));
set(handles.InterfaceChooserTextField,'String',num2str(handles.currentInterfaceNumber'));
set(handles.UndecidedCheckbox,'Value',handles.undecidedList(handles.currentInterfaceNumber));
set(handles.CommentTextField,'String',handles.comments{handles.currentInterfaceNumber});
if ~isempty(handles.synapseScore)
    set(handles.SynapseProbabilityTextBox,'String',num2str(handles.synapseScore(handles.currentInterfaceNumber)));
    set(handles.SynapseProbabilityTextBox,'Visible','on');
else
    set(handles.SynapseProbabilityTextBox,'String','No Prediction.');
    set(handles.SynapseProbabilityTextBox,'Visible','off');
end

