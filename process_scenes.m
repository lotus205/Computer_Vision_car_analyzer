function process_scenes(video_file, percent_input)

% Settings
PRECENT_SIMILARITY_FOR_EQUALTY = percent_input;

% Make sure the directories to store images exist
mkdir(strcat('scenes/', video_file));

% Got the frist frame (garage entrance with no cars)
empty_frame = imread(strcat(video_file, '/', video_file, '_frame_1.jpg'));

% Frame counter
k = 1; 
previous_k = 1;
count = 1;

% Percentage how similar two frames are
% based on their RGB channels histograms
similarity = 0;  
previous_similatiry = 0;

% Frame that is the most different from
% the first frame. Used to select a single 
% outstanding frame from multiple frames 
% when a car is present
most_different_frame = 0;
most_different_frame_k = 0;
most_different_frame_sim = 0;

while k <= (length(dir(video_file)) - 2)

    current_frame = imread(strcat(video_file, '/', video_file, '_frame_', num2str(k), '.jpg'));

    % -- Calculate a frames RGBs' histograms
    % -- Get the difference between the histograms
    % -- for the current and empty frame
        h1_r = imhist(empty_frame(:,:,1)) ./ numel(empty_frame(:,:,1));
        h2_r = imhist(current_frame(:,:,1)) ./ numel(current_frame(:,:,1));

        s_r = sum(sum(sum(sqrt(h1_r).*sqrt(h2_r))));

        h1_b = imhist(empty_frame(:,:,2)) ./ numel(empty_frame(:,:,2));
        h2_b = imhist(current_frame(:,:,2)) ./ numel(current_frame(:,:,2));

        s_b = sum(sum(sum(sqrt(h1_b).*sqrt(h2_b))));

        h1_g = imhist(empty_frame(:,:,3)) ./ numel(empty_frame(:,:,3));
        h2_g = imhist(current_frame(:,:,3)) ./ numel(current_frame(:,:,3));

        s_g = sum(sum(sum(sqrt(h1_g).*sqrt(h2_g))));

        similarity = (s_r*s_b*s_g)*100;
    % --

    if (similarity < PRECENT_SIMILARITY_FOR_EQUALTY)
        % If the selected frame is NOT directly following
        % the previous one. Example: 
        % (frame 5, skip, frame 7) vs (frame 5, frame 6, frame 7)
        if((k - previous_k) ~= 1)
            % If it's not the very first frame scanned
            if(most_different_frame_k ~= 0)
                show = sprintf('MOST DIFFERENT FROM FIRST || SIMILARITY: %0.5g, SCENE: %d', most_different_frame_sim, most_different_frame_k);
                disp(show);

                imwrite(most_different_frame, sprintf('scenes/%s/scene_%d.png', video_file, count));
                count = count + 1;
            end

            % Set the [most_different_frame] as the new
            % sequence of frames has begun
            most_different_frame = current_frame;
            most_different_frame_k = k;
            most_different_frame_sim = similarity;
            previous_similatiry = similarity;
        else
            if(previous_similatiry > similarity)
                most_different_frame = current_frame;
                most_different_frame_k = k;
                most_different_frame_sim = similarity;
                previous_similatiry = similarity;
            end
        end
        show = sprintf('DIFFERENT FROM FIRST || SIMILARITY: %0.5g, SCENE: %d', similarity, k);
        disp(show);

        previous_k = k;
        k = k + 1;
    else
        k = k + 1;
    end

end

% The last MDF is required to be output outside the above while loop
% because it ends before it gets to the output
show = sprintf('MOST DIFFERENT FROM FIRST || SIMILARITY: %0.5g, SCENE: %d', most_different_frame_sim, most_different_frame_k);
disp(show);

imwrite(most_different_frame, sprintf('scenes/%s/scene_%d.png', video_file, count));

end