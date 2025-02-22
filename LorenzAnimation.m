%% Lorenz Animation
% Draw the Lorenz Attractor
% inputs:
% x - output vector
% lims - bounds on the camera, xl,yl,zl
% tspan - time span of values
% t - time value
% output - turn on / off video output
% outputs:
% video output

function[] = LorenzAnimation(x, lims, tspan, t, output)

writerObj= VideoWriter('LorenzAnimation', 'MPEG-4');
writerObj.FrameRate = 30;
writerObj.Quality = 85;
open(writerObj)

lineNumber = size(x, 2)/3;

for i = 1:lineNumber
    colors(i, :) = [0, .5, .5] + ones(1,3)*(0.5)*i / lineNumber;
end

figure(3)
figure('units','pixels','position',[0 0 1920 1080]) 

curve = animatedline('LineWidth', 1.5, 'Color',colors(i,:), MaximumNumPoints= 400);
curve1 = animatedline('LineWidth', 1.5, 'Color',colors(2,:), MaximumNumPoints= 400);
curve2 = animatedline('LineWidth', 1.5, 'Color', colors(3,:), MaximumNumPoints= 400);
curve3 = animatedline('LineWidth', 1.5, 'Color', colors(4,:), MaximumNumPoints= 400);



set(gca,'XColor', 'none','YColor','none', 'ZColor', 'none')

set(gca, 'color', 'none');
axis equal
g = gcf;

%g.WindowState = 'maximized';
set(gcf,'Color','k');
speed = 5;

xlim(lims(1:2));
ylim(lims(3:4));
zlim(lims(5:6));
view(43,24);


for i=1:speed:length(tspan)
    camorbit(1/20, 0)
    camzoom(1 + (1e-4))
    addpoints(curve, x(i,1), x(i,2), x(i,3));
    addpoints(curve1, x(i,4), x(i,5), x(i,6));
    addpoints(curve2, x(i,7), x(i,8), x(i,9));
    addpoints(curve3, x(i,10), x(i,11), x(i,12));



    title(sprintf("Trajectory at time %.2f s", t(i)));
    drawnow;
    %pause(dt / playbackSpeed);

    % if output == 1
    %     frame = getframe(gcf);
    %     img =  frame2im(frame);
    %     [img,cmap] = rgb2ind(img,256);
    %     if i == 1
    %         imwrite(img,cmap,'TrajAnimation.gif','gif','LoopCount',Inf, 'DelayTime', 1/60);
    %     else
    %         imwrite(img,cmap,'TrajAnimation.gif','gif','WriteMode','append', 'DelayTime', 1/60);
    %     end
    % end

    if output == 1
        frame = getframe(gcf);
        writeVideo(writerObj,frame)
    end

end

close(writerObj)
disp('Video File Written')

