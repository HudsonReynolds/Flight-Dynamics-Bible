function RotationsVisualizer(quatArray, timeArray, makeGif)
% ROTATIONSVISUALIZER Visualizes rocket orientation over time using quaternions.
%
% Inputs: 
%   quatArray - 4xN or Nx4 matrix of quaternions [w, x, y, z]
%   timeArray - 1xN vector of timestamps corresponding to each quaternion
%   makeGif   - Logical flag (true/false or 1/0) to export animation to GIF

    % Ensure correct orientation for quaternion conversion (expects Nx4)
    if size(quatArray, 1) == 4
        quatArray = quatArray';
    end
    
    % Base quaternions from integration
    qObjects = quaternion(quatArray);
    
    % Define 90-degree pitch/roll offset about the X-axis: [cos(pi/4), sin(pi/4), 0, 0]
    qOffset = quaternion(cos(pi/4), sin(pi/4), 0, 0);
    
    % Apply constant offset to all frames via quaternion multiplication
    qRotated = qObjects * qOffset;

    % Initialize Visualization
    fig = figure(6); 
    clf(fig);
    
    % Create pose plot object with offset initial frame
    pPlot = poseplot(qRotated(1), [0, 0, 0], 'ENU', ...
        'MeshFileName', 'Model.stl', ...
        'ScaleFactor', 1, ...
        'PatchFaceColor', 'r');
    
    view(45, 25);
    axis square;
    grid on;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    
    % Setup GIF parameters
    if makeGif
        gifFilename = 'RotationAnimation.gif';
        dt = mean(diff(timeArray(1:2:end))); 
    end
    
    % Animation Loop
    for i = 1:2:length(timeArray)
        % Update pose orientation using the rotated quaternion array
        pPlot.Orientation = qRotated(i);
        title(sprintf('Orientation at time: %.2f s', timeArray(i)));
        drawnow;
        
        if ~makeGif
            pause(0.01);
        end
        
        % Capture GIF frames
        if makeGif
            frame = getframe(fig);
            [img, cmap] = rgb2ind(frame.cdata, 256);
            
            if i == 1
                imwrite(img, cmap, gifFilename, 'gif', 'LoopCount', Inf, 'DelayTime', dt);
            else
                imwrite(img, cmap, gifFilename, 'gif', 'WriteMode', 'append', 'DelayTime', dt);
            end
        end
    end
end