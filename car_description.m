function car_description(video_file)

% Got the directory with scenes
% and the first frame from the video
video_directory = strcat('scenes/', video_file);
empty_frame = imread(strcat(video_file, '/', video_file, '_frame_1.jpg'));

% Setup the output file and print filename in it
output_file = fopen('RESULTS', 'a');
fprintf(output_file, 'VIDEO: %s \n', video_file);


% SHAPE DETECTION

% Matrix of car shapes
cars_info = [];

k = 1; 
while k <= (length(dir(video_directory)) - 2)
    
    current_frame = imread(strcat('scenes/', video_file, '/scene_', num2str(k), '.png'));

    % Take a literate difference between scene with the car
    % and scene without a car. What is left is the car.
    difference_temp = empty_frame(:,:,:) - current_frame(:,:,:);
    % Invert colors
    difference = imcomplement(difference_temp);
    
    [x, y, z] = size(difference);
    
    % Count non-background (non-white pixels)
    count = 0;
    for i = 1:x
        for j = 1:y
            if(difference(i,j,1) ~= 255 && difference(i,j,2) ~= 255 && difference(i,j,3) ~= 255)
                count = count + 1;
            end
        end
    end
    
    % Appending a single car's info to the matrix
    a_car = [k (count/(x*y))];
    cars_info = [cars_info ; a_car];
    
    k = k + 1;
end

sorted_shapes = sortrows(cars_info, 2);


% COLOR DETECTION

k = 1; 
while k <= (length(dir(video_directory)) - 2)
    
    current_frame = imread(strcat('scenes/', video_file, '/scene_', num2str(k), '.png'));

    % Take a literate difference between scene with the car
    % and scene without a car. What is left is the car.
    difference_temp = empty_frame - current_frame;
    % Invert colors
    difference = imcomplement(difference_temp);

    % -- Getting RGB channels average
        %figure
        %subplot(2,2,1);
        %imhist(difference(:,:,1));
        R = mean2(difference(:,:,1));
        %disp(R);
        %subplot(2,2,2);
        %imhist(difference(:,:,2));
        G = mean2(difference(:,:,2));
        %disp(G);
        %subplot(2,2,3);
        %imhist(difference(:,:,3));
        B = mean2(difference(:,:,3));
        %disp(B);
        %subplot(2,2,4);
        %imshow(difference);
    % --
    
    % The following hardcoded values are chosen based 
    % on the study of the realm of input and educated guess
    
    % Arbitrary decision of colorful car:
    % highest and lowest channel difference is [5]
    if((max([R, G, B]) - min([R, G, B])) > 5)
        if(R == max([R, G, B]))
            fprintf(output_file, 'CAR #: %d | COLOR: [%s]', k, 'red');
        elseif(G == max([R, G, B]))
            fprintf(output_file, 'CAR #: %d | COLOR: [%s]', k, 'green');
        elseif(B == max([R, G, B]))
            fprintf(output_file, 'CAR #: %d | COLOR: [%s]', k, 'blue');
        else
            disp('WTF?');
        end
    else
        % Arbitrary decision of "whiteness" of the car:
        % values over [230] are white
        % [220 - 230] are gray
        % [210 and below] are black
        if((max([R, G, B]) / 10) > 23)
            fprintf(output_file, 'CAR #: %d | COLOR: [%s]', k, 'white');
        elseif((max([R, G, B]) / 10) > 22)
            fprintf(output_file, 'CAR #: %d | COLOR: [%s]', k, 'gray');
        else
            fprintf(output_file, 'CAR #: %d | COLOR: [%s]', k, 'black');
        end
    end
    
    % Appending the shapes to the file
    % Limits are chosen arbitrary, 
    % based on the partitions of cars_info matrix: 
    % top 25% are vans
    % 60-75% are trucks
    % 0-60% are sedans
    for i = 1:length(sorted_shapes)
        if(sorted_shapes(i,1) == k)
            if(i > round(length(sorted_shapes)*0.75))
                fprintf(output_file, ' | TYPE: [%s]\n', 'van');
            elseif (i > round(length(sorted_shapes)*0.60))
                fprintf(output_file, ' | TYPE: [%s]\n', 'truck');
            else
                fprintf(output_file, ' | TYPE: [%s]\n', 'sedan');
            end
        end
    end

    k = k + 1; 
end

fprintf(output_file, '\n');

end