%读文件信息
%对于大文件不能直接读,后议
video = VideoReader(file_path);

FrameRate = video.FrameRate;
NumberOfFrames = video.NumberOfFrames;
Height = video.Height;
Width = video.Width;
