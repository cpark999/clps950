uniqueEventTypes = unique([EEG.event.edftype]); 
for eventType = uniqueEventTypes
    allDataSegments = []; 
    
    for i = 1:length(EEG.event)
        if EEG.event(i).edftype == eventType
            start = EEG.event(i).latency;
            if isfield(EEG.event, 'duration') && EEG.event(i).duration > 0
                duration = EEG.event(i).duration;
            else
                duration = 313; 
            end
            
            for ch = 1:size(EEG.data, 1)
                endIndex = min(size(EEG.data, 2), start + duration - 1);
                segment = EEG.data(ch, start:endIndex);
                segment = interp1(linspace(0, 1, numel(segment)), segment, linspace(0, 1, duration), 'linear', 'extrap');
                allDataSegments(ch, :, end+1) = segment; 
            end
        end
    end
    
  
    meanData = mean(allDataSegments, 3);
    
    figure; 
    plot(meanData');
    title(sprintf('Average EEG Data for Event Type %d', eventType));
    xlabel('Time (ms)');
    ylabel('Amplitude (uV)');
    legend(arrayfun(@(ch) sprintf('Channel %d', ch), 1:size(EEG.data, 1), 'UniformOutput', false));
end