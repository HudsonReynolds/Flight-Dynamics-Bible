function RotationsVisualizer(quatArray, timeArray, output)
% RotationsVisualizer
% Visualizes the orientation of a rocket over time based on quaternion data.
%
% Inputs: 
% quatArray      - Array of quaternions for the rocket orientation.
% timeArray      - Array of time values.
% output         - If 1, output a GIF file; if 0, no output.
%
% Outputs:
% A figure showing the rocket's orientation over time.

% Set up the figure
figure(6)
qs = quaternion([45, 0, 0], 'eulerd', 'ZYX', 'frame');  % Initial orientation
ps = [0, 0, 0];  % Initial position (can be adjusted if needed)

% Create the 3D plot and mesh
patch = poseplot(qs, ps, 'ENU', MeshFileName="Model.stl", ScaleFactor=1, PatchFaceColor='r');
view(45, 25);
axis square;
xlabel('x');
ylabel('y');
zlabel('z');
grid on;


% Prepare GIF output if required
if output == 1
    gifFilename = 'RotationAnimation.gif';
end

% Animation loop
for i = 1:2:length(timeArray)
    % Update the orientation using the quaternion for the current time step
    q = quaternion(quatArray(:, i)');
    
    % Set new orientation for the patch
    set(patch, 'Orientation', q);
    
    % Update the title and redraw the figure
    title(sprintf('Orientation at time %.1f s', timeArray(i)));
    drawnow;

    % Create GIF if output is enabled
    if output == 1
        frame = getframe(gcf);  % Capture the frame
        img = frame2im(frame);
        [img, cmap] = rgb2ind(img, 256);

        % Write the first frame or append the subsequent frames
        if i == 1
            imwrite(img, cmap, gifFilename, 'gif', 'LoopCount', Inf, 'DelayTime', 1/24);
        else
            imwrite(img, cmap, gifFilename, 'gif', 'WriteMode', 'append', 'DelayTime', 1/24);
        end
    end
end
end
