eventType = 277; 
figure; 

for i = 1:length(EEG.event)
    if EEG.event(i).edftype == eventType
        start = EEG.event(i).latency; 
        if isfield(EEG.event, 'duration') && EEG.event(i).duration > 0
            duration = EEG.event(i).duration;
        else
            duration = 313;
        end
        for ch = 1:25 
            endIndex = min(size(EEG.data, 2), start + duration - 1);
            eventSegment = EEG.data(ch, start:endIndex);
            plot(eventSegment);
            hold on; 
        end
    end
end

xlabel('Time (ms)');
ylabel('Amplitude (uV)');
title(sprintf('Event Type %d - All Occurrences', eventType));
legend(arrayfun(@(ch) sprintf('Channel %d', ch), 1:25, 'UniformOutput', false));