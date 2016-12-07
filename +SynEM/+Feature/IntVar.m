classdef IntVar < SynEM.Feature.TextureFeature
    % IntVar Intensity/variance filter.
    % PROPERTIES
    % nhood: [Nx1] array of integer specifying the size of the filter in
    %   each dimension.
    % sigma: (Optional) [Nx1] array of float specifying the standard
    %   deviation in each dimension for prior smoothing
    %   (Default: no prior smoothing)
    %
    % Author: Benedikt Staffler <benedikt.staffler@brain.mpg.de>
    
    properties
        nhood
    end
    
    methods
        function obj = IntVar(nhood)
            obj.name = 'IntVar';
            obj.nhood = nhood;
            obj.border = (nhood - 1);
            obj.numChannels = 1;
        end
        
        function feat = calc(obj, raw)
            feat = obj.calculate(raw, obj.nhood);
        end
    end
    
    methods (Static)
        function feat = calculate(raw, nhood)
            h = ones(nhood);
            raw = double(raw)./255;
            feat = imfilter(raw.*raw,h) - imfilter(raw,h).^2;
        end
    end
    
end

