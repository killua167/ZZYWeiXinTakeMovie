# ZZYWeiXinTakeMovie V1.1.1
##仿微信拍摄小视频功能
有重拍功能，可以设置拍摄多帧数和最长拍摄时间。
###使用和设置如下：
```
TakeMovieViewController *TMVC = [[TakeMovieViewController alloc]initWithFrameNum:60 cameraTime:5 resultImages:^(NSArray *images) {
}];
[self.navigationController pushViewController:TMVC animated:YES];

```
####说明：
TMVC.frameNum = 15;//你设置的帧数，即1秒捕捉多少帧，iPhone5 默认3-60fps,iPhone5s以上默认3-120fps
TMVC.cameraTime = 5;//你设置多拍摄时间

感谢星星，thanks for the stars!