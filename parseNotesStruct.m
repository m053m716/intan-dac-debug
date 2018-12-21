function [W,TH,COL] = parseNotesStruct(notes,varargin)
%% PARSENOTESSTRUCT  Parse notes from RHD or RHS recording to get windows
%
%  [W,TH,COL] = PARSENOTESSTRUCT(notes);
%
%  --------
%   INPUTS
%  --------
%    notes     :     Notes struct from RHD or RHS recording. Fields are
%                       'notes1,' 'notes2,' and 'notes3.'
%
%  varargin    :     (optional) 'NAME', value input argument pairs.
%
%  --------
%   OUTPUT
%  --------
%     W        :     Window start and stop samples. Each row corresponds to
%                       a different window level.
%
%    TH        :     Window threshold. Each row corresponds to
%                       a different window level.
%
%    COL       :     Window color. Each row corresponds to
%                       a different window level.
%
% By: Max Murphy  v1.0  12/18/2018  Original version (R2017b)

%% DEFAULTS
C = {'r','m';... % "Exclude" Left: negative-going; Right: positive-going
     'b','c'};   % "Include" Left: negative-going; Right: positive-going
NAME_DELIM = '_';
PAR_DELIM = '|';
  
%% PARSE VARARGIN
for iV = 1:2:numel(varargin)
   eval([upper(varargin{iV}) '=varargin{iV+1};']);
end

%%
W = [];
TH = [];
COL = [];

f = fieldnames(notes);
iCount = 1;
for iF = 1:numel(f)
   pars = parseField(notes.(f{iF}),NAME_DELIM,PAR_DELIM);
   if isempty(pars)
      continue;
   end
   W = [W; str2double(pars.Start), str2double(pars.Stop)]; %#ok<*AGROW>
   TH = [TH; str2double(pars.Amp)];
   colorRow = double(strcmpi(pars.Type,'Include'))+1;
   colorCol = double(TH(iCount) > 0) + 1;
   COL = [COL; C(colorRow,colorCol)];
   iCount = iCount + 1;
   
end



   function out = parseField(c,nameDelim,parDelim)
      %% PARSEFIELD  Parse notes values from a string
      if isempty(c)
         out = [];
         return;
      elseif contains(c,' ')
         out = [];
         return;
      else
         out = struct;
      end
      
      str = strsplit(c,parDelim);
      for iStr = 1:numel(str)
         tmp = strsplit(str{iStr},nameDelim);
         out.(tmp{1}) = tmp{2};
      end
      
   end


end