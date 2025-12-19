function [ pitch ] = PitchMarker(inaudio)
% PitchMarker.m (From Digital Audio Effects)
% Finds all the pitch marks in the input file and returns the
% markings in a matrix


% initial settings

mark=[1:length(inaudio)]*0;
last_pos=1;
place=1;

blocksize=300;

i=1;

while last_pos+floor(blocksize*1.7) < length(inaudio)
    % grabs the next block to examine
    temp=inaudio(last_pos+50:last_pos+floor(blocksize*1.7));
    % finds the high point in the block
    [mag,place]=max(temp);
    % checks to see if there is really a signal in this block
    if mag < 0.01
        place=length(temp);
        mode = 0;
        mark(place+last_pos+50)=1;
        pitch(i)=place+last_pos+50;
    else
        mode = 1;
    end
    % checks to see if there is a pitch mark before the current pitch mark
    while mode == 1
        % finds largest point in block from beginning to current pitch mark
        [mag2,place2]=max(temp(1:place-50));
        % checks to see if high mark is suffincent size to be a pitch mark
        if mag2 > 0.90*mag
            mag=mag2;
            place=place2;
        else
            mode = 0;
            mark(place+last_pos+50)=1;
            pitch(i)=place+last_pos+50;
        end
    end
    % starts the next block to be examind 50 samples after this block
    blocksize=place+50;
    % makes sure next blocksize is of sufficent size
    if blocksize < 150
        blocksize=150;
    end
    last_pos=place+last_pos+50;
    i=i+1;
end

end