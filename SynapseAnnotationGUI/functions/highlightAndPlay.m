function highlightAndPlay( hObject, handles )
%HIGHLIGHTANDPLAYBUTTON Modified version of Play button.
%This modified button starts the video in the middle by highlighting the
%two segments. Afterwards, it is played backwards to the first picture and
%then the complete video is played.

if get(handles.HighlightAndPlayButton,'Value')
    set(handles.HighlightAndPlayButton,'String','Stop');
    %go to middle of video first
    handles.currentImage = ceil(size(handles.currentImageData,3)/2);
    updateImage(hObject,handles);
    %highlight segments for 1 second before playing the video
    if ~handles.highlightSegments
        handles.highlightSegments = true;
        updateImage(hObject,handles);
        pause(1);
        handles.highlightSegments = false;
        updateImage(hObject,handles);
    else
        pause(1);
    end
else
    set(handles.HighlightAndPlayButton,'String','Highlight & Play');
end

%play video backward till first image
while get(handles.HighlightAndPlayButton,'Value')
    if handles.currentImage > 1
        handles.currentImage = handles.currentImage - 1;
        updateImage(hObject,handles);
        pause(0.05);
        drawnow();
    else
        break;
    end
    guidata(hObject,handles);
end

pause(1);

%now play video from the beginning
while get(handles.HighlightAndPlayButton,'Value')
    if handles.currentImage < handles.lastImage 
        handles.currentImage = handles.currentImage + 1;
        updateImage(hObject,handles);
        pause(0.05);
        drawnow();
    else
        handles.currentImage = 31;
        pause(1);
        updateImage(hObject,handles);
        set(handles.HighlightAndPlayButton,'Value',0);
        set(handles.HighlightAndPlayButton,'String','Highlight & Play');
    end
    guidata(hObject,handles);
end
end