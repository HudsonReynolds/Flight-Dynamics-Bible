%Misc figures and code that we often reuse

%% HEADER FOR FUNCTIONS AND FILES:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSP FLIGHT DYNAMICS:
%
% Title: FILENAME
% Author: INSERT NAME - Created: INSERT DATE
%
% Description: INSERT FUNCTION DESCRIPTION
%
% Inputs: 
% VAR = DESRIPTION [UNITS], REPEAT FOR ALL
%
% Outputs:
% VAR = DESCRIPTION [UNITS], REPEAT FOR ALL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% English units for the trajectory plot
% figure(2)
% 
% hfig = figure;  % save the figure handle in a variable
% 
% fname = 'Cartesian Elements English';
% 
% picturewidth = 20; % set this parameter and keep it forever
% hw_ratio = .6; % feel free to play with this ratio
% set(findall(hfig,'-property','FontSize'),'FontSize',16) % adjust fontsize to your document
% set(hfig,'DefaultLineLineWidth',1)
% 
% posArrayFt = posArray * m2ft;
% velArrayFt = velArray * m2ft;
% 
% hold on
% plot(timeArray, posArrayFt(:,1), 'Color', colorlist(1));
% plot(timeArray, posArrayFt(:,2), 'Color', colorlist(2));
% plot(timeArray, posArrayFt(:,3), 'Color', colorlist(3));
% 
% xlim([0, 100]);
% title("Rocket Cartesian Elements in Earth Frame (English Units)")
% xlabel("Time (s)")
% ylabel("Distance [ft]")
% 
% yyaxis right
% plot(timeArray, velArrayFt(:,1), 'Color', colorlist(4), 'LineStyle','-');
% plot(timeArray, velArrayFt(:,2), 'Color', colorlist(5), 'LineStyle','-');
% plot(timeArray, velArrayFt(:,3), 'Color', colorlist(6), 'LineStyle','-');
% ylabel("Velocity[ft/s]")
% legend("$X$","$Y$","$Z$", "$V_x$", "$V_y$", "$V_z$");
% 
% ax = gca;
% ax.YAxis(1).Color = 'k';
% ax.YAxis(2).Color = 'k';
% 
% grid on
% 
% set(findall(hfig,'-property','Box'),'Box','off') % optional
% set(findall(hfig,'-property','Interpreter'),'Interpreter','latex') 
% set(findall(hfig,'-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
% set(hfig,'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
% pos = get(hfig,'Position');
% set(hfig,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
% %print(hfig,fname,'-dpdf','-painters','-fillpage')
% print(hfig,fname,'-dpng','-r300')
% % Earth Frame Rocket Velocity:
% % figure(2)
% % plot(timeArray, velArray);
% % xlim([0, endTime]);
% % title("Rocket velocity in Earth Frame")
% % xlabel("Time (s)")
% % ylabel("Velocity")
% % legend("X","Y","Z");