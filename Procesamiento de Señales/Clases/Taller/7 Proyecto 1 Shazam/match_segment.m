function [bestMatchID, confidence] = match_segment(clip, fs)
%function [bestMatchID, confidence] = match_segment(clip, fs)
%  This function requires the global variables 'hashtable' and 'numSongs'
%  in order to work properly.

global hashtable
global numSongs

hashTableSize = size(hashtable,1);

% Find peak pairs from the clip

clipTuples = convert_to_pairs(fingerprints(clip, fs));

% Construct the cell of matches
matches = cell(numSongs,1);
for k = 1:size(clipTuples, 1)

    clipHash = simple_hash(clipTuples(k,3), clipTuples(k,4), clipTuples(k,2) - clipTuples(k,1), hashTableSize);

    % If an entry exists with this hash, find the song(s) with matching peak pairs
    if (~isempty(hashtable{clipHash, 1}))
        matchID = hashtable{clipHash, 1}; % row vector of collisions
        matchTime = hashtable{clipHash, 2}; % row vector of collisions
        
        % Calculate the time difference between clip pair and song pair

        timeDiff = matchTime - clipTuples(k, 2);

        % Add matches to the lists for each individual song
        for n = 1:numSongs
            matches{n} = [matches{n}, timeDiff(matchID == n)];
        end
    end
end

% Find the counts of the mode of the time offset array for each song

modeCounts = zeros(numSongs,1);
for k = 1:numSongs
     if (~isempty(matches{k}))
        [modeVal, modeCount] = mode(matches{k});
        modeCounts(k) = modeCount;
    end
end


% Song decision and confidence
[maxCount, bestMatchID] = max(modeCounts);
confidence = (maxCount / size(clipTuples, 1))*100;

optional_plot = 1; % turn plot on or off

if optional_plot
    figure(3)
    clf
    y = zeros(length(matches),1);
    for k = 1:length(matches)
        subplot(length(matches),1,k)
        hist(matches{k},1000)
        y(k) = max(hist(matches{k},1000));
    end
    
    for k = 1:length(matches)
        subplot(length(matches),1,k)
        axis([-inf, inf, 0, max(1, ceil(max(y)))])
    end

    subplot(length(matches),1,1)
    title('Histogram of offsets for each song')
end

end

