# ZZYWeiXinTakeMovie
##仿微信拍摄小视频功能
有重拍功能，可以设置拍摄多帧数和最长拍摄时间。
###使用和设置如下：
```
TakeMovieViewController *TMVC = [[TakeMovieViewController alloc]init];
TMVC.frameNum = 15;//你设置的帧数，及1秒捕捉多少帧
TMVC.cameraTime = 5;//你设置多拍摄时间
[self.navigationController pushViewController:TMVC animated:YES];
```
