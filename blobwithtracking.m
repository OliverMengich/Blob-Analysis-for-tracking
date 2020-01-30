video = vision.VideoFileReader('singleball.mp4');
player = vision.DeployableVideoPlayer('Location',[50 100]);


fgDetector = vision.ForegroundDetector(...
'NumTrainingFrames',10,'InitialVariance',0.05);
blob = vision.BlobAnalysis(...
    'AreaOutputPort',true,...
    'MinimumBlobArea',70,...
    'CentroidOutputPort',true);
while ~isDone(video)
    
frame = step(video);
fgmask = step(fgDetector,frame);

[~,y,bbox] = step(blob,fgmask);

   th = multithresh(rgb2gray(frame));
    BW = rgb2gray(frame)>th;
    %bbox = bbox(1:3);
    release(blob)
    centroids = step(blob,BW);
    ballsCounted = int32(size(centroids,1));  
    txt = sprintf('Staple count: %d', ballsCounted);
    J = insertObjectAnnotation(frame,'rectangle',bbox,'Ball');
    It = insertText(J,[10 280],txt,'FontSize',22); 
    
    step(player,It);
   pause(0.2) 
end