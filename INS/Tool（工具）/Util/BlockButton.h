
#import <UIKit/UIKit.h>

typedef void(^Block)(UIButton * button);


@interface BlockButton : UIButton



@property (nonatomic, copy) Block block;


@end
