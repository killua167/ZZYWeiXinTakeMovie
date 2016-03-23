//
//  StartButton.h
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartButton : UIView
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) UILabel *label;
-(void)disappearAnimation;
-(void)appearAnimation;
@end
