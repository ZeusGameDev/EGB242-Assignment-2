% why does this exist? saving images each time you rerun the script wastes
% a lot of time. To save all the images for use in the report set
% in any file
% global saveImages;
% saveImages = 1;


% this should be used after a plot, ex:
% figure(1)
% plot(x, y);
% saveaswrapper(gcf) % gcf is a variable that always contains the current figure
% gcf -> get current figure
function saveimagewrapper(handle)
    prefix = dbstack("-completenames",1).name;
    global saveImages;
    if saveImages==1
        saveas(handle,sprintf("images\\%s_fig%d.svg",prefix,handle().Number),"svg");
    end
end
