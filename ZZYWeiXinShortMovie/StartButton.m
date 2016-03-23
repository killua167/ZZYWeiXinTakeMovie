//
//  StartButton.m
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//

#import "StartButton.h"

@implementation StartButton
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:_circleLayer.position radius:frame.size.width/2 startAngle:-M_PI endAngle:M_PI clockwise:YES];
        _circleLayer.path = path.CGPath;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.lineWidth = 3;
        _circleLayer.strokeColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_circleLayer];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 20)];
        _label.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _label.textColor = [UIColor greenColor];
        _label.text = @"按住拍";
        _label.textAlignment = NSTextAlignmentCenter;
        [_label setFont:[UIFont systemFontOfSize:20]];
        [self addSubview:_label];
    }
    return self;
}

-(void)disappearAnimation{
    CABasicAnimation *animation_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation_scale.toValue = @1.5;
    CABasicAnimation *animation_opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation_opacity.toValue = @0;
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 0.2;
    aniGroup.animations = @[animation_scale,animation_opacity];
    aniGroup.fillMode = kCAFillModeForwards;
    aniGroup.removedOnCompletion = NO;
    [_circleLayer addAnimation:aniGroup forKey:@"start"];
    [_label.layer addAnimation:aniGroup forKey:@"start1"];
}

-(void)appearAnimation{
    CABasicAnimation *animation_scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation_scale.toValue = @1;
    CABasicAnimation *animation_opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation_opacity.toValue = @1;
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 0.2;
    aniGroup.animations = @[animation_scale,animation_opacity];
    aniGroup.fillMode = kCAFillModeForwards;
    aniGroup.removedOnCompletion = NO;
    [_circleLayer addAnimation:aniGroup forKey:@"reset"];
    [_label.layer addAnimation:aniGroup forKey:@"reset1"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
