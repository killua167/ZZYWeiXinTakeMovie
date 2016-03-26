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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)takeAction:(id)sender {
    TakeMovieViewController *TMVC = [[TakeMovieViewController alloc]init];
    TMVC.frameNum = [_setFrameTF.text integerValue];
    TMVC.cameraTime = [_setCameraTimeTF.text floatValue];
    [self.navigationController pushViewController:TMVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
