function drawImage( handles )
%DRAWIMAGE Display image stored in handles
%   Displays the image stored in the handles object and highlights the
%   subsegments and draws interface normal if specified. The zoom level of
%   the previous image will be used to determine the zoom level of the
%   current image.

%get axes, zoom level and aspect ratio
axes(handles.axes1);
zoomLevel = get(handles.axes1,{'xlim','ylim'});
dataAspectRatio = get(handles.axes1,'dataAspectRatio');

%draw new image
cla(handles.axes1);
imshow(handles.currentImageData(:,:,handles.currentImage),[50 180]);

%highlight segments if specified
hold on;
himage = imshow(handles.currentHighlightedSegments(:,:,:,handles.currentImage));
hold off;
if handles.highlightSegments
    set(himage,'AlphaData',0.15.*handles.alphaData(:,:,handles.currentImage));
else
    set(himage,'AlphaData',0);
end

%highlight voxel labels if specified
if handles.highlightVoxels
    hold on;
    himage = imshow(handles.currentHighlightedVoxels(:,:,:,handles.currentImage));
    hold off;
    set(himage,'AlphaData',0.15.*handles.voxelAlphaData(:,:,handles.currentImage));
end

%set zoom level and aspect ratio to saved value
set(handles.axes1,{'xlim','ylim'},zoomLevel);
set(handles.axes1,'dataAspectRatio',dataAspectRatio);

end