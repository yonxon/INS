

#import "HomeVC.h"
#import "AppDelegate.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)quit:(id)sender
{
    [USER_INFOR initData];
    [USER_INFOR saveData];
     [((AppDelegate*) AppDelegateInstance) setupLoginViewController];
}

@end
