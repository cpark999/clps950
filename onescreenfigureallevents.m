uniqueEventTypes = unique([EEG.event.edftype]); 
numUniqueEventTypes = length(uniqueEventTypes);

numRows = ceil(sqrt(numUniqueEventTypes));
numCols = numRows;

figure;

for u = 1:numUniqueEventTypes
    eventType = uniqueEventTypes(u);
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
                if isempty(allDataSegments)
                    allDataSegments = segment;
                else
                    allDataSegments(ch, :, end+1) = segment;
                end
            end
        end
    end

    meanData = mean(allDataSegments, 3);

    subplot(numRows, numCols, u);
    plot(meanData');
    title(sprintf('Event Type %d', eventType));
    xlabel('Time (ms)');
    ylabel('Amplitude (uV)');
    
    if u == numUniqueEventTypes 
        legend(arrayfun(@(ch) sprintf('Ch %d', ch), 1:size(EEG.data, 1), 'UniformOutput', false), 'Location', 'eastoutside');
    end
end

set(gcf, 'Position', get(0, 'Screensize')); 
