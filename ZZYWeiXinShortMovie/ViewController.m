//
//  ViewController.m
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//

#import "ViewController.h"
#import "TakeMovieViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *setFrameTF;
@property (weak, nonatomic) IBOutlet UITextField *setCameraTimeTF;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (strong, nonatomic) NSArray *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)takeAction:(id)sender {
    [_setFrameTF resignFirstResponder];
    [_setCameraTimeTF resignFirstResponder];
    //帧数默认范围3-120
    TakeMovieViewController *TMVC = [[TakeMovieViewController alloc]initWithFrameNum:[_setFrameTF.text integerValue]
                                                                          cameraTime:[_setCameraTimeTF.text floatValue]
                                                                        resultImages:^(NSArray *images) {
                                                                            self.images = images;
                                                                            
                                                                            self.ImageView.hidden = NO;
                                                                            self.ImageView.animationImages = self.images;
                                                                            self.ImageView.animationDuration = 5;
                                                                            self.ImageView.animationRepeatCount = 0;
                                                                            [self.ImageView startAnimating];
                                                                          }];
    
    
//    TMVC.frameNum = [_setFrameTF.text integerValue];
//    TMVC.cameraTime = [_setCameraTimeTF.text floatValue];
    [self.navigationController pushViewController:TMVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
