classdef cel < signalanalysis
    % cel class locates the bursts in the cell recordings.
    % 
    % cel is a subclass of signalanalysis.
    %
    % METHODS -------------------------------------------------------------
    % NAME          DESCRIPTION
    % cel           Class constructor.
    % isBurst       Finds the bursts in the root data.
    %
    % ---------------------------------------------------------------------
    
    properties
    end
    
    methods
        
        % Class constructor or the cel class. 
        % @param time:          Time data set for the eng.
        % @param potential:     Voltages data set for the root reading of
        %                         the eng.
        % @param threshold:     Double value for a voltage level to detect
        %                         bursts.
        % @param onsetTimes:    An existing set of values of the times of
        %                         onsets.
        % @param offsetTimes:   An existing set of values of the times of
        %                         offsets.
        % @returns CE:          Class object.
        function CE = cel(time, potential, threshold, onsetTimes, offsetTimes)
            if (nargin == 3)
                superArgs{1} = [];
                superArgs{2} = [];
            else
                superArgs{1} = onsetTimes;
                superArgs{2} = offsetTimes;
            end
            CE = CE@signalanalysis(time, potential, threshold, superArgs{:});
        end
        
        % Determines bursts in the data sets base on 3 threshold values.
        % @param RO:                The root class object.
        % @param spikeThreshold:    Double value, a minimum threshold.
        %                             Anything greate than this threshold
        %                             is considered to be a possible part
        %                             of a burst.
        % @param throughThreshold:  Double value, a maximum threshold.
        %                             trough occurs between two spikes. If
        %                             trough is less than threshold, the
        %                             spikes are grouped to be a possible
        %                             burst.
        % @param burstThreshold:    Double value, a maximum threshold. If a
        %                             possible burst is less the this
        %                             threshold, then it is excluded,
        %                             otherwise it is consdered a burst.
        function isBurst (CE, spikeThreshold, troughThreshold,...
                burstThreshold)
            
            % Sets default values for the parameters if they are NsN.
            if (isnan(spikeThreshold))
                spikeThreshold = 0.005;
            end
            
            if (isnan(troughThreshold))
                troughThreshold = 1.00;
            end
            
            if (isnan(burstThreshold))
                burstThreshold = 0.005;
            end  
            
            % if a spike above the threshold lasts more than the
            % SPIKE_THRESHOLD, adds to the [on], [off] array. 
            try
                ind = ( (CE.time(CE.offset)) - (CE.time(CE.onset)) ) > spikeThreshold;
                on = CE.time(CE.onset(ind));
                off = CE.time(CE.offset(ind));

                % determines all troughs that are less than the
                % TROUGH_THRESHOLD            
                on1 = on;
                on1(1) = [];
                off1 = off;
                off1(end) = [];
                ind1 =  ( ((on1 - off1) < troughThreshold) & ((on1 - off1) > 0) );
                trough_on = on1(ind1);
                trough_off = off1(ind1);

                % troughs that are less than the TROUGH_THRESHOLD are ignored
                % by removing them from the [on], [off], array.
                ind2 = ismember(on, trough_on);
                ind3 = ismember(off, trough_off);
                on(ind2) = [];
                off(ind3) = [];

                % determines single spikes that was considered to be a burst
                % from previous operations.
                ind4 = (off - on) < burstThreshold;
                burst_on = on(ind4);
                burst_off = off(ind4);

                % removes the single spikes from the [on], [off] arrays.            
                ind5 = ismember(on, burst_on);
                ind6 = ismember(off, burst_off);
                on(ind5) = [];
                off(ind6) = [];
                CE.onsetTimes = on;
                CE.offsetTimes = off;
                
%                 fixStart = [min(CE.potentialMod):0.1:CE.potentialMod(1)]';
%                 fixStop  = [min(CE.potentialMod):0.1:CE.potentialMod(end)]';
%                 fixStartTime = zeros(size(fixStart));
%                 fixStopTime  = ones(size(fixStop))*CE.time(end);
%                 time = vertcat(fixStartTime, CE.time, fixStopTime);
%                 potentialMod = vertcat(fixStart, CE.potentialMod, fixStop);
                
                
            % If error is produced, error dialog box will appear.
            catch err
                msg = {'Error in detecting bursts for cell.',...
                    '1. Try another threshold level.',...
                    '2. Try another data time frame.',...
                    '3. Adjust cell input settings.'};
                errordlg(msg);
            end
            
        end
        
    end
    
end

