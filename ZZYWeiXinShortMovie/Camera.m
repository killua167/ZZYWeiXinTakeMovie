//
//  Camera.m
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//

#import "Camera.h"

@implementation Camera
-(instancetype)init{
    if (self = [super init]) {
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetMedium];
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        //添加输入
        _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
        if ([_session canAddInput:_deviceInput]) {
            [_session addInput:_deviceInput];
        }
        //添加输出
        _deviceVideoOutput = [[AVCaptureVideoDataOutput alloc]init];
        [_deviceVideoOutput setVideoSettings:
         [NSDictionary dictionaryWithObject:
          [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                     forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        _deviceVideoOutput.alwaysDiscardsLateVideoFrames = YES;
        if ([_session canAddOutput:_deviceVideoOutput]) {
            [_session addOutput:_deviceVideoOutput];
        }
        //配置默认帧数1秒10帧
        [_session beginConfiguration];
        if ([_device lockForConfiguration:&error]) {
            [_device setActiveVideoMaxFrameDuration:CMTimeMake(1, 10)];
            [_device setActiveVideoMinFrameDuration:CMTimeMake(1, 10)];
            [_device unlockForConfiguration];
        }
        [_session commitConfiguration];
        [self focusAtPoint:_cameraView.center];
    }
    return self;
}
//预览层嵌入
-(void)embedLayerWithView:(UIView *)view{
    _cameraView = view;
    if (_session == nil) {
        return;
    }
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    //设置layer大小
    _videoPreviewLayer.frame = view.layer.bounds;
    //layer填充状态
    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //设置摄像头朝向
    _videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [view.layer addSublayer:_videoPreviewLayer];
    //创建对焦手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToFocus:)];
    [view addGestureRecognizer:tapGesture];
    //初始化对焦提示框
    focusView = [[UIView alloc]init];
    focusView.layer.borderWidth = 2;
    focusView.layer.borderColor = [UIColor greenColor].CGColor;
    [_videoPreviewLayer addSublayer:focusView.layer];
    [self focusViewAnimation:view.center];
}
//点击手势响应方法
-(void)tapToFocus:(UITapGestureRecognizer*)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:_cameraView];
    CGPoint focusPoint = CGPointMake(point.x/_cameraView.frame.size.width, point.y/_cameraView.frame.size.height);
    [self focusAtPoint:focusPoint];
    //    [self continuousFocusAtPoint:focusPoint];
    [self focusViewAnimation:point];
    NSLog(@"x%f,y%f",focusView.frame.origin.x,focusView.frame.origin.y);
}
//设置自动对焦
-(void)focusAtPoint:(CGPoint)point{
    if ([_device isFocusPointOfInterestSupported] && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        if ([_device lockForConfiguration:&error]) {
            [_device setFocusPointOfInterest:point];
            [_device setFocusMode:AVCaptureFocusModeAutoFocus];
            [_device unlockForConfiguration];
        }
    }
}
//设置连续对焦
-(void)continuousFocusAtPoint:(CGPoint)point{
    if ([_device isFocusPointOfInterestSupported] && [_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSError *error = nil;
        if ([_device lockForConfiguration:&error]) {
            [_device setFocusPointOfInterest:point];
            [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [_device unlockForConfiguration];
        }
    }
}
//对焦提示框动画
-(void)focusViewAnimation:(CGPoint)point{
    focusView.frame = CGRectMake(0, 0, 80, 80);
    focusView.center = point;
    focusView.alpha = 1;
    [UIView animateWithDuration:0.5 animations:^{
        focusView.frame = CGRectMake(0, 0, 60, 60);
        focusView.center = point;
    } completion:^(BOOL finished) {
        focusView.alpha = 0;
        [UIView animateWithDuration:0.1 animations:^{
            focusView.alpha = 1;
        } completion:^(BOOL finished) {
            focusView.alpha = 0;
        }];
    }];
}
//配置自定义拍摄帧数
- (void)setFrameNum:(NSInteger)frameNum{
    _frameNum = frameNum;
    [_session beginConfiguration];
    NSError *error;
    if ([_device lockForConfiguration:&error]) {
        [_device setActiveVideoMaxFrameDuration:CMTimeMake(1, (int)_frameNum)];
        [_device setActiveVideoMinFrameDuration:CMTimeMake(1, (int)_frameNum)];
        [_device unlockForConfiguration];
    }
    [_session commitConfiguration];
}
//开始拍摄
-(void)startCamera{
    [_session startRunning];
}
//停止拍摄
-(void)stopCamera{
    [_session stopRunning];
}
@end
