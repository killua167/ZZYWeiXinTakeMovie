//
//  TakeMovieViewController.h
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//

#import "ViewController.h"

@interface TakeMovieViewController : ViewController
typedef void(^resultImagesBlock)(NSArray*);
@property (nonatomic, copy) resultImagesBlock block;
@property (nonatomic,assign) CGFloat cameraTime;
@property (nonatomic,assign) NSInteger frameNum;
- (instancetype)initWithFrameNum:(NSInteger)frameNum cameraTime:(CGFloat)cameraTime resultImages:(resultImagesBlock)result;
@end
