//
//  Camera.h
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface Camera : NSObject
{
    //会话层
    AVCaptureSession *_session;
    //创建 配置输入设备
    AVCaptureDevice *_device;
    //显示层
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    UIView *focusView;
}
@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *deviceVideoOutput;
@property (nonatomic,strong) UIView *cameraView;
@property (nonatomic,assign) NSInteger frameNum;
//开始拍摄
-(void)startCamera;
//停止拍摄
-(void)stopCamera;
//预览层嵌入
-(void)embedLayerWithView:(UIView *)view;
@end
