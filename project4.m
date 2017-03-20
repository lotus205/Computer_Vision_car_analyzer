function project4

% Turn off warning messages of existing folders
warning('off', 'all'); 

% First parameter is the name of the folder with images(=video file)
% Second parameter is the percent below which the frames are considered
% different scenes

process_scenes('day_time', 78);
process_scenes('night_time', 75);

% Parameter is the name of the folder with scenes(=video file)
car_description('day_time');
car_description('night_time');

end