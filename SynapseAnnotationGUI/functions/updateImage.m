function updateImage( hObject,handles)
%UPDATEIMAGE Set image number and draw image.

set(handles.PictureNumberText,'String',strcat(num2str(handles.currentImage),'/',num2str(handles.lastImage)));
guidata(hObject,handles);
drawImage(handles);

end

