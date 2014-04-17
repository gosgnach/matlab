classdef root < signalanalysis
    % root class manipulates the root data so that bursts are easier to
    % detect, and also find the burst in that data set.
    % 
    % root is a subclass of signalanalysis.
    %
    % PROPERTIES ----------------------------------------------------------
    % NAME          TYPE            DESCRIPTION
    % b             double          1st parameter in the creation of the
    %                                 butterworth filter 
    %                                 [b, a] = butter(...);
    % a             double          2nd parameter in the creation of the
    %                                 butterworth filter 
    %                                 [b, a] = butter(...);
    %
    % ---------------------------------------------------------------------
    %
    % METHODS -------------------------------------------------------------
    % NAME          DESCRIPTION
    % root          Class constructor.
    % bandpass      Creates the bandpass filter used to filter the data.
    % downsample    Allows the user to downsample the data.
    % filterData    Applies the bandpass filter to the data, then retifies
    %                 the data and takes a moving average.
    % isBurst       Finds the bursts in the root data.
    %
    % ---------------------------------------------------------------------
    
    properties (Access = private)
        
        b
        a
        
    end
    
    methods
        
        % Class constructor or the root class. 
        % @param time:          Time data set for the eng.
        % @param potential:     Voltages data set for the root reading of
        %                         the eng.
        % @param threshold:     Double value for a voltage level to detect
        %                         bursts.
        % @param onsetTimes:    An existing set of values of the times of
        %                         onsets.
        % @param offsetTimes:   An existing set of values of the times of
        %                         offsets.
        % @returns RO:          Class object.
        function RO = root(time, potential, threshold, onsetTimes, offsetTimes)
            if (nargin == 3)
                superArgs{1} = [];
                superArgs{2} = [];
            else
                superArgs{1} = onsetTimes;
                superArgs{2} = offsetTimes;
            end
            RO = RO@signalanalysis(time, potential, threshold, superArgs{:});
    
        end
        
        % Creates a bandpass butterworth filter.
        % @param RO:            The root class object.
        % @param filterOrder:   Double value for the order of the bandpass
        % butterworth filter.
        % @param sampFrequency  Double value for the sampling frequenct of
        %                         the data.
        % @param passFrequency  Two element array [i, j] where i is the low
        %                         cutoff ans j is the high cutoff.
        function bandpass (RO, filtOrder, sampFrequency, passFrequency)
            
            if (isempty(filtOrder))
                FILTER_ORDER = 2; % order of the filter
            else
                FILTER_ORDER = filtOrder; % order of the filter
            end
            
            if (isempty(sampFrequency))
                FREQ_SAMPLE = 10000; % sample frequency (Hz)
            else
                FREQ_SAMPLE = sampFrequency; % sample frequency (Hz)
            end
            
            if(isempty(passFrequency))
                FREQ_PASS = [100, 1000];
            else
                FREQ_PASS = passFrequency;
            end
            freqNorm = 2*FREQ_PASS / FREQ_SAMPLE;%normalized passband
            [RO.b, RO.a] = butter(FILTER_ORDER, freqNorm, 'bandpass');
        end
        
        % Downsamples both the time and potential data by a give factor.
        % @param RO:            The root class object.
        % @param factor:        Double value to downsample the sampling
        %                         frequency by.
        function downsample(RO, factor)
            % If facotr is not NaN, will downsample the data by the factor.
            if (~isnan(factor))
                RO.time      = downsample(RO.time     , factor);
                RO.potential = downsample(RO.potential, factor);
            end
        end
        
        % Applies the bandpass filter, rectifies the data, and takes a
        % moving average.
        % @param RO:            The root class object.
        % @param window:        Double value for the window span for the
        %                         moving average.
        function filterData (RO, window)
            % Sets default values if window is NaN.
            if (isnan(window))
                window = 511;
            else
                window = window * (10^4);
            end
            % Applies bandpass filter. Uses filtfilt function, doubles the
            % filtering order.
            filtPoten = filtfilt(RO.b, RO.a, RO.potential);
            % Rectifies data by taking the absoulute value of the filtered
            % data.
            absFiltPoten = abs(filtPoten);
            % Applies a moving average.
            RO.potentialMod = smooth(absFiltPoten, window, 'moving');
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
        function isBurst (RO, spikeThreshold, troughThreshold,...
                burstThreshold)
            
            % Sets default values for the parameters if they are NsN.
            if (isnan(spikeThreshold))
                spikeThreshold = 0.05;
            end
            
            if (isnan(troughThreshold))
                troughThreshold = 0.200;
            end
            
            if (isnan(burstThreshold))
                burstThreshold = 0.7;
            end  
            
            try
                % if a spike above the threshold lasts more than the
                % SPIKE_THRESHOLD, adds to the [on], [off] array. 
                ind = (RO.time(RO.offset) - RO.time(RO.onset)) > spikeThreshold;
                on = RO.time(RO.onset(ind));
                off = RO.time(RO.offset(ind));

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
                RO.onsetTimes = on;
                RO.offsetTimes = off;
                
            % If error is produced, error dialog box will appear.
            catch err
                msg = {'Error in detecting bursts for root.',...
                    '1. Try another threshold level.',...
                    '2. Try another data time frame.',...
                    '3. Adjust root input settings.'};
                errordlg(msg);
            end
            
        end
        
    end
    
end

