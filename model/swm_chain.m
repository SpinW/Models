function obj = swm_chain(param)
% Model file which generates a spin chain
% 
% ### Syntax
% 
% `obj = swm_chain(param)`
% 
% ### Description
% 
% `obj = swm_chain(model, param)` generates a chain with further 
% neighbor interactions.
% 
% ### Input Arguments
% 
% `param`
% : Input parameters of the model, row vector which gives the values of the
%   Heisenberg exchange for first, second, thirs etc. neighbor bonds stored
%   in `p(1)`, `p(2)`, `p(3)`, etc. respectively.
% 
% ### Output Arguments
% 
% `obj`
% : [spinw] class object with the cahin model.
% 
% ### See Also
% 
% [spinw], [sw_model]
%

% Generate lattice and add couplings
obj = spinw;
obj.genlattice('lat_const',[3 9 9],'angled',[90 90 90])
obj.addatom('r',[0 0 0],'S',1,'color','darkmagenta')
obj.gencoupling('maxDistance',10)

% Add exchanges and generate magnetic structure
if nargin > 0
    % Add coupling matrix
    for ii = 1:numel(param)
        obj.addmatrix('value',param(ii),'label',['J_' num2str(ii)],'color',swplot.color(randi(140),1))
        obj.addcoupling('mat',ii,'bond',ii)
    end
    % Generate the magnetic structure
    obj.genmagstr('mode','helical','S',[1 0 0]','k',[0 0 0])
    % Optimise the magnetic structure
    obj.optmagstr('func',@gm_planar,'xmin',[0 0 0 0 0 0],'xmax',[0 1/2 0 0 0 0],'nRun',10)
    tol = 2e-4;
    helical = sum(abs(mod(abs(2*obj.magstr.k)+tol,1)-tol).^2) > tol;
    if ~helical && any(obj.magstr.k>tol)
        nExt = [1 1 1];
        nExt(obj.magstr.k(1:2)>tol) = 2;
        obj.genmagstr('mode','helical','nExt',nExt);
    end
end

end

