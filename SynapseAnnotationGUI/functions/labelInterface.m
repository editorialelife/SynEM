function handles = labelInterface( handles,hObject, label )
%LABELINTERFACE Labels the current interface.
handles.interfaceLabels(handles.currentInterfaceNumber) = label;
handles.hasUnsavedAnnotations = true;
handles.annotationStatus = getAnnotationStatus(handles.currentInterfaceNumber, handles.interfaceLabels);
set(handles.AnnotationStatusStaticText,'String',['Annotation status: ',handles.annotationStatus]);
guidata(hObject,handles);
end