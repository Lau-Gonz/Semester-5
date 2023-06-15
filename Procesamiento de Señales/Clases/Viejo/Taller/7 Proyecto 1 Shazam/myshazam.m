%% Shazam Project, Main File
% Created by: Laura Valentina Gonzalez Rodriguez and Dafne Valeria 
% Castellanos Rojas

% This code implements the Shazam algorithm for music recognition. It 
% records or selects a random audio segment, compares it with a database of 
% songs, and displays the result in a pop-up window with the matching song 
% name and a confidence percentage. It can display the Histogram of offsets
% for each song, the Pairs plot, and the Log Spectrogram of the audio 
% segment. Additionally, it plays the audio of the segment.

clc
clear;  % Limpia la memoria
close all;  % Cierra todas las figuras

% Make a recording or 

recordingOn = 0; %1 for recording from microphone, 0 for random segment
duration = 10; % Seconds

global hashtable

% Check if we have a database in the workspace
if ~exist('songid')
    % Load database if one exists
    if exist('SONGID.mat')
        load('SONGID.mat');
        load('HASHTABLE.mat');
    else  
        msgbox('No song database');
        return;
    end
end

global numSongs
numSongs = length(songid);

add_noise = 1; % Optionally add noise by making this 1.
SNRdB = 5; % Signal-to-noise Ratio in dB, if noise is added.  Can be negative.

if recordingOn
    % Settings used for recording.
    fs = 44100; % Sample frequency
    bits = 16;  % Bits used per sample

    % Record audio for <duration> seconds.
    recObj = audiorecorder(fs, bits, 2);
    handle1 = msgbox('Recording');
    recordblocking(recObj, duration);
    delete(handle1)

    % Store data in Double-precision array.
    sound = getaudiodata(recObj);
    
else % Select a random segment
    
    dir = 'songs'; % This is the folder that the MP3 files are in.
    songs = getMp3List(dir);
    
    % Select random song
    thisSongIndex = ceil(length(songs)*rand);
    filename = strcat(dir, filesep, songs{thisSongIndex});
    [sound,fs] = audioread(filename);
    sound = mean(sound,2);
    sound = sound - mean(sound);
    
    % Select random segment
    if length(sound) > ceil(duration*fs)
        shiftRange = length(sound) - ceil(duration*fs)+1;
        shift = ceil(shiftRange*rand);
        sound = sound(shift:shift+ceil(duration*fs)-1);
    end
    
    % Add noise
    if add_noise
        soundPower = mean(sound.^2);
        noise = randn(size(sound))*sqrt(soundPower/10^(SNRdB/10));
        sound = sound + noise;
    end
end

[bestMatchID, confidence] = match_segment(sound, fs);

matchedSong = songid{bestMatchID};

% Display the matched song and confidence in a message box
answer = matchedSong;
msg = sprintf('Matched song: %s \n\nConfidence: %d', answer, confidence);

if recordingOn
    msgbox({strcat(answer, '  (matched song)'), strcat(int2str(confidence), '  ( % confidence based on the pairs of the song '), 'or 100% according to the paper)'}, 'Recorded Segment')
else
    msgbox({strcat(songs{thisSongIndex}, '  (actual song)'), strcat(num2str(duration(1,1)), ' (segment duration) '), strcat(num2str(SNRdB), ' (SNRdB) '),strcat(answer, '  (matched song)'), strcat(int2str(confidence), '  ( % confidence based on the pairs of the song '), 'or 100% according to the paper)'}, 'Random Segment')
end 

clip = sound;
clear sound;
sound(clip,fs);