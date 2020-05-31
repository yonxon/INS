/************************************* 文件说明****************************************
 文件说明：  图片文字居中显示按钮
 ****************************************************************************************/

#import "CenterButton.h"

@interface CenterButton ()
{
    UIView *view;
}

@end

@implementation CenterButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [self titleLabel].frame;
    
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2+10;
    center.y = (self.frame.size.height - frame.size.height) / 2;
    self.imageView.center = center;
    
    
    frame.origin.x = 10;
    frame.origin.y = self.imageView.frame.size.height + self.imageView.frame.origin.y;
    frame.size.width = self.frame.size.width;
    self.titleLabel.frame = frame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

-(void)showBadge{
    view = [UIView new];
    CGFloat VWidth = 8;
    view.frame = CGRectMake(self.frame.size.width - VWidth, 5 , VWidth, VWidth);
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
    
    [self addSubview:view];
}
-(void)removeBadge{
    view.hidden = YES;
}



@end
