function fm = getFeatureMap( name, varargin )
%GETFEATUREMAP Create a predefined feature map.
% INPUT name: string
%           Name of the feature map (see below).
%       varargin: Any arguments required for specific feature maps.
%           For 'paper' varargin{1} specifies the voxel size in nm.
% OUTPUT fm: SynEM.FeatureMap object
% Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>

import SynEM.Feature.*
import SynEM.FeatureMap

switch name
    case 'paper'
        areaT = 150;
        subvolsSize = [40 80 160];
        quantiles = [0.25 0.5 0.75 0 1];
        if ~isempty(varargin)
            voxelSize = varargin{1};
        else
            voxelSize = [11.24, 11.24, 28];
        end
        moments = true(4,1);
        sigma = 12./voxelSize;
        fS = ceil(2.*sigma);
        fRawNorm = '@(x)single(x)';

        %construct feature map
        fm = FeatureMap(subvolsSize, areaT, ...
            quantiles, moments, 'direction', [1, 1, 1], fRawNorm);

        %add features
        fm.addFeature(Identity());
        fm.addFeature(EVsStructureTensor(sigma, fS, sigma, fS));
        fm.addFeature(EVsStructureTensor(sigma, fS, 2.*sigma, 2.*fS));
        fm.addFeature(EVsStructureTensor(2.*sigma, 2.*fS, sigma, fS));
        fm.addFeature(EVsStructureTensor(2.*sigma, 2.*fS, 2.*sigma, 2.*fS));
        fm.addFeature(EVsStructureTensor(3.*sigma, 3.*fS, 3.*sigma, 3.*fS));
        fm.addFeature(EVsHessian(sigma, fS));
        fm.addFeature(EVsHessian(2.*sigma, 2.*fS));
        fm.addFeature(EVsHessian(3.*sigma, 3.*fS));
        fm.addFeature(EVsHessian(4.*sigma, 4.*fS));
        fm.addFeature(GaussFilter(sigma, fS));
        fm.addFeature(GaussFilter(2.*sigma, 2.*fS));
        fm.addFeature(GaussFilter(3.*sigma, 3.*fS));
        fm.addFeature(DoG(sigma, fS, 1.5));
        fm.addFeature(DoG(sigma, fS, 2));
        fm.addFeature(DoG(2.*sigma, 2.*fS, 1.5));
        fm.addFeature(DoG(2.*sigma, 2.*fS, 2));
        fm.addFeature(DoG(3.*sigma, 3.*fS, 1.5));
        fm.addFeature(LoG(sigma, fS));
        fm.addFeature(LoG(2.*sigma, 2.*fS));
        fm.addFeature(LoG(3.*sigma, 3.*fS));
        fm.addFeature(LoG(4.*sigma, 4.*fS));
        fm.addFeature(GaussGradMagnitude(sigma, fS));
        fm.addFeature(GaussGradMagnitude(2.*sigma, 2.*fS));
        fm.addFeature(GaussGradMagnitude(3.*sigma, 3.*fS));
        fm.addFeature(GaussGradMagnitude(4.*sigma, 4.*fS));
        fm.addFeature(GaussGradMagnitude(5.*sigma, 5.*fS));
        fm.addFeature(StdFilter([5, 5, 5]));
        fm.addFeature(EntropyFilter([5, 5, 5]));
        fm.addFeature(IntVar([3, 3, 3]));
        fm.addFeature(IntVar([5, 5, 5]));
        fm.addFeature(AverageFilter('ball',3,[1, 1, 2]));
        fm.addFeature(AverageFilter('ball',6,[1, 1, 2]));
        fm.addFeature(Volume([], 3),[1, 2, 3],[1 3 2]);
        fm.addFeature(Volume( ...
            '@(x)single(nthroot(6*x*(11.24*11.24*28)*pi,3))',1), ...
            1, 1); %diameter from old fm
        fm.addFeature(PrincipalAxis('length',[1, 1, 28/11.24]),1,[1, 2, 3]);
        fm.addFeature(PrincipalAxis('prod',[1, 1, 28/11.24]),[2 3],1);
        fm.addFeature(ConvexHull(3),[1, 2, 3],[1 3 2]);
        
    case 'SurfaceOnlyTest'
        areaT = 150;
        subvolsSize = [];
        quantiles = [0.25 0.5 0.75 0 1];
        moments = true(4,1);
        voxelSize = [11.24, 11.24, 28];
        sigma = 12./voxelSize;

        %construct feature map
        fm = FeatureMap(subvolsSize, areaT, ...
            quantiles, moments, 'direction');
        
        %add features
        fm.addFeature(Identity());
        fm.addFeature(GaussFilter(sigma, 2));
        fm.addFeature(Volume([], 1),1,1);
        
    otherwise
        error('Feature map %s not defined.', name);
end
end

