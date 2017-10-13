% Auto-generated by cameraCalibrator app on 11-Oct-2017
%-------------------------------------------------------


% Define images to process
imageFileNames = {
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-0.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-1.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-2.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-3.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-4.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-5.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-6.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-8.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-10.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-11.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-12.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-13.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-14.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-15.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-16.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-17.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-19.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-22.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-23.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-24.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-25.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-26.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-27.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-28.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-29.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-30.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-31.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-32.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-33.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-34.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-35.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-36.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-37.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-38.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-39.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-41.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-42.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-43.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-44.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-45.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-46.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-47.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-48.jpg',...
    'D:\Google Drive\FH\Bachelor Thesis\Research\Calibration\frames\binarized-49.jpg',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 29;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 8, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')