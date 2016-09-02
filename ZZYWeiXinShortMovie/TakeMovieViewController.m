//
//  TakeMovieViewController.m
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//
#define Screen_width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#import "TakeMovieViewController.h"
#import "Camera.h"
#import "StartButton.h"
#import <QuartzCore/QuartzCore.h>
@interface TakeMovieViewController () <AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate>
{
    BOOL isStart;
    BOOL isCancel;
    CALayer *progressLayer;
    UILabel *tipsLabel;
    NSTimer *timer;
    NSInteger time;
}
@property (strong, nonatomic) Camera *camera;
@property (strong, nonatomic) UIView *cameraView;
@property (strong, nonatomic) UIImageView *preView;
@property (strong, nonatomic) StartButton *startButton;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@end

@implementation TakeMovieViewController

- (instancetype)initWithFrameNum:(NSInteger)frameNum cameraTime:(CGFloat)cameraTime resultImages:(resultImagesBlock)result{
    self = [super init];
    if (self) {
        _frameNum = frameNum;
        _cameraTime = cameraTime;
        self.block = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    isStart = NO;
    self.imagesArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor blackColor];
    [self initCameraView];//初始化摄像头
    [self initPreView];//初始化预览gif的view
    [self initStartButton];//初始化开始拍摄按钮
    //相机权限受限提示
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied ||authStatus == AVAuthorizationStatusRestricted) {
        NSLog(@"相机权限受限");
    }
    //拍摄手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    panGesture.delegate = self;
    [self.startButton addGestureRecognizer:panGesture];
    UILongPressGestureRecognizer *longPressGeture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startAction:)];
    longPressGeture.delegate = self;
    longPressGeture.minimumPressDuration = 0.1;
    [self.startButton addGestureRecognizer:longPressGeture];
    
    UIBarButtonItem *redoButton = [[UIBarButtonItem alloc]initWithTitle:@"重拍" style:UIBarButtonItemStylePlain target:self action:@selector(resetCamera:)];
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItems = @[finishButton,redoButton];
}
-(void)initCameraView{
    _cameraView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height/2)];
    [self.view insertSubview:_cameraView atIndex:0];
    [self.camera startCamera];
}
-(void)initPreView{
    [self.view addSubview:self.preView];
}
-(void)initStartButton{
    [self.view addSubview:self.startButton];
}
-(void)initProgress{
    progressLayer = [CALayer layer];
    progressLayer.backgroundColor = [UIColor greenColor].CGColor;
    progressLayer.frame = CGRectMake(0, Screen_height/2, Screen_width, 5);
    [self.view.layer addSublayer:progressLayer];
    CABasicAnimation *countTime = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    countTime.toValue = @0;
    countTime.duration = _cameraTime;
    countTime.removedOnCompletion = NO;
    countTime.fillMode = kCAFillModeForwards;
    [progressLayer addAnimation:countTime forKey:@"progressAni"];
}
-(void)panAction:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (point.y < Screen_height/2) {
        isCancel = YES;
        progressLayer.backgroundColor = [UIColor redColor].CGColor;
        tipsLabel.text = @"松手取消";
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.backgroundColor = [UIColor redColor];
    }
    else{
        isCancel = NO;
        progressLayer.backgroundColor = [UIColor greenColor].CGColor;
        tipsLabel.text = @"⬆️上移取消";
        tipsLabel.textColor = [UIColor greenColor];
        tipsLabel.backgroundColor = [UIColor clearColor];
    }
}

-(void)startAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        isStart = YES;
        isCancel = NO;
        [self.startButton disappearAnimation];
        [self initProgress];
        tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width/2-42, Screen_height/2-30, 84, 20)];
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.text = @"⬆️上移取消";
        tipsLabel.textColor = [UIColor greenColor];
        [self.view addSubview:tipsLabel];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        time = 0;
        NSLog(@"start");
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (isCancel) {
            NSLog(@"cancel");
            isStart = NO;
            [timer invalidate];
            [progressLayer removeFromSuperlayer];
            [tipsLabel removeFromSuperview];
            [self.startButton appearAnimation];
            return;
        }
        else{
            if (time < 1) {
                isStart = NO;
                [timer invalidate];
                [self.imagesArray removeAllObjects];
                [progressLayer removeFromSuperlayer];
                [self.startButton appearAnimation];
                tipsLabel.text = @"手指不要放开";
                tipsLabel.textColor = [UIColor whiteColor];
                tipsLabel.backgroundColor = [UIColor redColor];
                [UIView animateWithDuration:2.0 animations:^{
                    tipsLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    [tipsLabel removeFromSuperview];
                }];
                return;
            }
            else if(time >=1 && time < _cameraTime){
                [self finishCamera];
            }
        }
    }
}
-(void)countDown:(NSTimer*)timerer{
    time++;
    if (time >= _cameraTime) {
        [self finishCamera];
    }
    NSLog(@"%ld",(long)time);
}
-(void)resetCamera:(UIBarButtonItem*)sender{
    _cameraView.hidden = NO;
    [self.camera startCamera];
    self.startButton.hidden = NO;
    [self.startButton appearAnimation];
    self.preView.hidden = YES;
    [self.imagesArray removeAllObjects];
}
- (void)finishCamera{
    [timer invalidate];
    NSLog(@"%@",self.imagesArray);
    NSLog(@"totle=%ld",(unsigned long)self.imagesArray.count);
    [self.camera stopCamera];
    isStart = NO;
    [progressLayer removeFromSuperlayer];
    [tipsLabel removeFromSuperview];
    self.startButton.hidden = YES;
    //预览gif动画
    self.preView.animationImages = self.imagesArray;
    self.preView.animationDuration = time;
    self.preView.animationRepeatCount = 0;
    self.preView.hidden = NO;
    _cameraView.hidden = YES;
    [self.preView startAnimating];
}
-(void)done:(UIBarButtonItem*)sender{
    self.block(self.imagesArray);
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (isStart) {
        UIImage *image = [self imageFromSampleBuffer:&sampleBuffer];
        image = [self normalizedImage:image];
        [self.imagesArray addObject:image];
    }
}
-(UIImage*) imageFromSampleBuffer:(CMSampleBufferRef*)sampleBuffer{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(*sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *basdAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(basdAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image  = [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(quartzImage);
    return (image);
}
- (UIImage *)normalizedImage:(UIImage*)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy load
- (Camera*)camera{
    if (!_camera) {
        _camera = [[Camera alloc]init];
        _camera.frameNum = _frameNum;
        [_camera embedLayerWithView:_cameraView];
        dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
        [_camera.deviceVideoOutput setSampleBufferDelegate:self queue:queue];
    }
    return _camera;
}

- (UIView*)preView{
    if (!_preView) {
        _preView = [[UIImageView alloc]initWithFrame:_cameraView.bounds];
        _preView.contentMode = UIViewContentModeScaleAspectFill;
        _preView.hidden = YES;
    }
    return _preView;
}

- (StartButton*)startButton{
    if (!_startButton) {
        _startButton = [[StartButton alloc]initWithFrame:CGRectMake(Screen_width/4, Screen_height/2+Screen_height/16, Screen_width/2, Screen_width/2)];
    }
    return _startButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
