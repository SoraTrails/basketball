%读文件信息
%对于大文件不能直接读,后议
video = VideoReader(file_path);

FrameRate = video.FrameRate;
NumberOfFrames = video.NumberOfFrames;
Height = video.Height;
Width = video.Width;

%用于消除视频中识别出的无效横直线
up_border = 0.17;%上边界所占比例
down_border = 0.17;%下边界所占比例
