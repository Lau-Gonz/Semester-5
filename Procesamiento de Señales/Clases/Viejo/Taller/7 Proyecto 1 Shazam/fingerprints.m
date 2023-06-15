function peaks = fingerprints(sound, fs)
%function peaks = fingerprint(sound, fs)
% This function takes a sound and sampling frequency.  It returns a binary
% matrix indicating the locations of peaks in the spectrogram.

new_smpl_rate = 8000; % sampling rate
time_res = 0.064; % for spectrogram
gs = 4; % grid size for spectrogram peak search
desiredPPS = 30; % scales the threshold
overlap = 0.032;

sound = mean(sound, 2);
sound = sound - mean(sound);
sound = resample(sound, new_smpl_rate, fs); % rates must each be integers.
fs = new_smpl_rate;

% Create the spectrogram
% Because the signal is real, only positive frequencies will be returned by
% the spectrogram function, which is all we will need.

[S,F,T] = spectrogram(sound, hamming(round(time_res * fs)), round(overlap * fs), [], fs);

% Find the local peaks with respect to the nearest gs entries in both
% directions

magS = abs(S);
peaks = ones(size(magS)); % 2D boolean array indicating position of local peaks
for horShift = -gs:gs
    for vertShift = -gs:gs
        if(vertShift ~= 0 || horShift ~= 0) % Avoid comparing to self
            shiftedMag = circshift(magS, [horShift, vertShift]);
            peaks = peaks.* (magS > shiftedMag);
        end
    end
end

% Calculate threshold to use.
% We will set one threshold for the entire segment.  Improvements might be
% possible by adapting the threshold throughout the length of the segment,
% and setting a lower threshold for higher frequencies.
peakMags = peaks.*magS;
sortedpeakMags = sort(peakMags(:),'descend'); % sort all peak values in order
threshold = sortedpeakMags(ceil(max(T)*desiredPPS));

% Apply threshold
if (threshold > 0)
    peakMags = peaks.*magS;
    peaks = (peakMags >= threshold);
end

optional_plot = 1; % turn plot on or off

if optional_plot
    % plot spectrogram
    figure(1)
    Tplot = [5, 10]; % Time axis for plot

    logS = log(magS);
    imagesc(T,F,logS);
    title('Log Spectrogram');
    xlabel('time (s)');
    ylabel('frequency (Hz)');
    axis xy
    axis([Tplot, -inf, inf])
    frame1 = getframe;

    % plot local peaks over spectrogram
    peaksSpec = (logS - min(min(logS))).*(1-peaks);
    imagesc(T,F,peaksSpec);
    title('Log Spectrogram');
    xlabel('time (s)');
    ylabel('frequency (Hz)');
    axis xy
    axis([Tplot, -inf, inf])
    frame2 = getframe;
    
    % Shows the points like a movie, this stops the code until the figure is closed.
    %movie([frame1,frame2],10,1)
end

end

