//
//  SeaViewController.m

//
//

#import "SeaViewController.h"

#define _barButtonItemSpace_ 6.0

#define _backItemHeight_ 30.0
#define _backItemWidth_ 25.0

@interface SeaViewController ()

///是否是第一次出现
@property(nonatomic,assign) BOOL isFirstAppear;

@end

@implementation SeaViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.statusBarHidden = NO;
        self.hideTabBar = YES;
        self.iconTintColor = [SeaBasicInitialization sea_tintColor];
    }
    return self;
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- 视图消失出现

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SeaTabBarController *tabBarController = self.Sea_TabBarController;
    if(tabBarController)
    {
        [tabBarController setTabBarHidden:self.hideTabBar animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.isFirstAppear)
    {
        self.isFirstAppear = YES;
        [self sea_viewDidLoad];
    }
}

///xcode 7中xib的子视图不会在viewDidLoad中加载，在vewiDidAppear中加载
- (void)sea_viewDidLoad
{
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    SeaTabBarController *tabBarController = self.Sea_TabBarController;
//    if(tabBarController)
//    {
//        [tabBarController setTabBarHidden:!self.hideTabBar animated:YES];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}




#pragma mark- super method

//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
//{
//    UIViewController *viewController = viewControllerToPresent;
//    
//    if([viewController isKindOfClass:[UINavigationController class]])
//    {
//        viewController = [[(UINavigationController*)viewControllerToPresent viewControllers] lastObject];
//    }
//    
//    if([viewController isKindOfClass:[SeaViewController class]])
//    {
//        SeaViewController *vc = (SeaViewController*)viewController;
//        vc.Sea_TabBarController = self.Sea_TabBarController;
//    }
//    
//    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
//}
//
#pragma mark- UIStatusBar

/**用于 present ViewController 的 statusBar 隐藏状态控制
 */
- (BOOL)prefersStatusBarHidden
{
    return self.statusBarHidden;
}

@end
