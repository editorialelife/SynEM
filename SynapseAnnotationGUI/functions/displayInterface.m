function handles = displayInterface( handles )
%DISPLAYINTERFACE Loads the specified interface for display
%   Rotate interface to its pca coordinate system and display it.

if ~isempty(handles.preprocessedData) && strcmp(handles.view,'interface-rotated')
    rotatedInterface = handles.preprocessedData{handles.currentInterfaceNumber,1};
    rotatedSegments = handles.preprocessedData{handles.currentInterfaceNumber,2};
    rotatedVoxelLabels = false(size(rotatedSegments));
else
    imSiz = handles.interfaceImageSize;
    numIm = handles.numInterfaceImages;
    interfaceIndices = handles.data.interfaceSurfaceList{handles.currentInterfaceNumber};
    raw = handles.data.raw;
    segments = handles.data.segments;
    voxelLabels = handles.voxelLabels;
    view = handles.view;
    [rotatedInterface, rotatedSegments, rotatedVoxelLabels] = rotateInterface(imSiz,numIm,interfaceIndices,raw,segments,view,voxelLabels);
end

handles.currentImageData = rotatedInterface;
handles = getHighlightedSegments(handles,rotatedSegments);
handles = getHighlightedVoxels(handles,rotatedVoxelLabels);

%update handles
handles.currentImage = ceil(size(handles.currentImageData,3)/2);
handles.lastImage = size(handles.currentImageData,3);
handles.annotationStatus = getAnnotationStatus(handles.currentInterfaceNumber, handles.interfaceLabels);

%diplay interface
handles = setFieldsForNewInterface(handles);
dataAspectRatio = get(handles.axes1,'dataAspectRatio');
imshow(handles.currentImageData(:,:,handles.currentImage),[50 180]);
set(handles.axes1,'dataAspectRatio',dataAspectRatio);
drawImage(handles);
end

