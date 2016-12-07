function startStopVideo( hObject,~,handles )
%STARTSTOPVIDEOBUTTON Pushbutton functionality for video start/stop.
%Starts video on first hit beginning with the current picture. If one hits
%the start button at the last picture, then the video starts from the
%beginning.
%Stops video if the button is pressed a second time before the video is
%over.

if get(handles.PlayButton,'Value')
    set(handles.PlayButton,'String','Stop');
    if handles.currentImage == handles.lastImage
        handles.currentImage = 1;
        updateImage(hObject,handles);
    end
    drawnow();
else
    set(handles.PlayButton,'String','Play');
end

while get(handles.PlayButton,'Value')
    if handles.currentImage < handles.lastImage 
        handles.currentImage = handles.currentImage + 1;
        updateImage(hObject,handles);
        pause(0.05);
        drawnow();
    else
        set(handles.PlayButton,'Value',0);
        set(handles.PlayButton,'String','Play');
    end
    guidata(hObject,handles);
end

end

