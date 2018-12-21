function [flag,x] = get_files_of_interest(Session,block)
%% GET_FILES_OF_INTEREST   Get the "TIME.mat" and other files of interest
%
%  GET_FILES_OF_INTEREST;
%  GET_FILES_OF_INTEREST(block);
%  flag = GET_FILES_OF_INTEREST(block);
%  [flag,x] = GET_FILES_OF_INTEREST(block);
%
%  --------
%   INPUTS
%  --------
%    block     :     Name of recording block. Files must be present in
%                    folder of the same name in this directory.
%
%  --------
%   OUTPUT
%  --------
%    flag      :     Indicates successful retrieval if true.
%
%     x        :     Extracted data struct.
%
% By: Max Murphy  v1.0  12/18/2018  Original version (R2017b)

%% DEFAULTS
SESSION = 'R18-00_2018_12_18';
% BLOCK = nan;
BLOCK_ID = 'R1*_*';
Q = 32768; % half-max for 16-bit ADC

%% PARSE INPUT
flag = false;
if nargin < 1
   if isnan(SESSION)
      B = dir(BLOCK_ID);
      if numel(B) > 1
         [~,bidx] = uidropdownbox('Select SESSION',...
            'Select session:',...
            {B.name}.');
         Session = B(bidx).name;
      else
         Session = B.name;
      end
   else
      Session = SESSION;
   end
end

%% GET SUB-FUNCTIONS
addpath('RHS2000_MATLAB_functions_v1_0');

%% FIND CORRECT FILE
if nargin < 2
   fileID = fullfile(Session,[Session '*.rhs']);
   F = dir(fileID);

   % Check for errors
   if isempty(F)
      if exist(Session,'dir')==0
         warning('Files not saved. No sub-directory for %s found.',Session);
      else
         warning('Files not saved. No RHS files for %s found.',Session);
      end
      return;
   end

   if numel(F) > 1
      [~,idx] = uidropdownbox('Select file','Select RHS file:',...
         {F.name}.');
      F = F(idx);
   end
   [~,block,~] = fileparts(F.name);
else
   [~,block,~] = fileparts(block);
   
   if exist(fullfile(Session,[block '.rhs']),'file')==0
      warning('File not found (%s).',fullfile(Session,[block '.rhs']));
      return;
   end
end
x = readIntan(fullfile(Session,[block '.rhs']));

%% SAVE TIME DATA
fs = x.frequency_parameters.amplifier_sample_rate;
t = x.t;

%% PARSE & SAVE DIGITAL INPUT DATA (EXTRACTED IN HIGH VS LOW VALUES)
% DIG-IN-13: STIM TRIGGER     ||       Row 1
% DIG-IN-14: FSM-ACTIVE       ||       Row 2
% DIG-IN-15: FSM-IDLE         ||       Row 3
if size(x.board_dig_out_data,1)>=15
   idx = 13:15;
   data = x.board_dig_out_data(idx,:);
else
   idx = any(x.board_dig_out_data,2);
   data = x.board_dig_out_data(idx,:);
end
dig = struct('data',data,'t',t,'fs',fs,'info',x.board_dig_out_channels(idx));
save(fullfile(Session,[block '-DigData.mat']),'-struct','dig');

%% PARSE & SAVE DAC WAVEFORM DATA (EXTRACTED IN BIT VALUES AFTER GAIN)
if abs(mean(x.board_dac_data(1,:)))>100
   bits = x.board_dac_data(any(x.board_dac_data-Q,2),:);
else
   bits = x.board_dac_data(any(x.board_dac_data,2),:);
end

dac = struct('bits',bits,'t',t,'fs',fs,'info',x.board_dac_channels);
save(fullfile(Session,[block '-DACData.mat']),'-struct','dac');

%% SAVE AMPLIFIER DATA (EXTRACTED IN BIT VALUES SEEN IN THE FIFO)
amp = struct('bits',x.amplifier_data,'t',t,'fs',fs,'info',x.amplifier_channels);
save(fullfile(Session,[block '-AMPData.mat']),'-struct','amp');

%% SAVE EXPERIMENTAL NOTES
notes = x.notes;
save(fullfile(Session,[block '-Notes.mat']),'-struct','notes');

%% PARSE & SAVE WINDOW PARAMETERS
[W,TH,COL] = parseNotesStruct(notes); %#ok<*ASGLU>
save(fullfile(Session,[block '-WindowParams.mat']),'W','TH','COL','-v7.3');
flag = true;

end