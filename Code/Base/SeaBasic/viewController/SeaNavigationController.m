//
//  SeaNavigationController.m
//  Sea

//
//

#import "SeaNavigationController.h"

@interface SeaNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

/**原来的样式
 */
@property(nonatomic,assign) UIStatusBarStyle orgStyle;

@end

@implementation SeaNavigationController


+ (void)initialize
{
    //设置默认导航条
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:[SeaNavigationController class], nil];
    
    NSDictionary *dic = nil;
    

    dic = [NSDictionary dictionaryWithObjectsAndKeys:[SeaBasicInitialization sea_tintColor], NSForegroundColorAttributeName, [UIFont fontWithName:MainFontName size:20.0], NSFontAttributeName, nil];

    
   // navigationBar.translucent = NO; ios 7.0会崩溃
    UIColor *color = _navigationBarBackgroundColor_;

    UIImage *image = [UIImage imageWithColor:color size:CGSizeMake(1,1)];
    [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
   // navigationBar.barTintColor = color;
    
    navigationBar.tintColor = [SeaBasicInitialization sea_tintColor];
//    navigationBar.backIndicatorImage = [UIImage imageNamed:@"back_icon"];
//    navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back_icon"];

    [navigationBar setTitleTextAttributes:dic];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _targetStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        self.orgStyle = [UIApplication sharedApplication].statusBarStyle;
    }
    return self;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//   
//    //这里要把状态栏样式还原
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //设置选项卡和隐藏状态
    if([viewController isKindOfClass:[SeaViewController class]])
    {
        SeaViewController *tmp = [self.viewControllers lastObject];
        if([tmp isKindOfClass:[SeaViewController class]])
        {
            SeaViewController *vc = (SeaViewController*)viewController;
            vc.hidesBottomBarWhenPushed = tmp.hidesBottomBarWhenPushed;
            vc.Sea_TabBarController = tmp.Sea_TabBarController;
        }
    }
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    
    __weak SeaNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return  [super popToRootViewControllerAnimated:animated];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
    
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers firstObject] )
        {
            return NO;
        }
        else
        {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
        }
    }
    
    return YES;
}


- (void)setTargetStatusBarStyle:(UIStatusBarStyle)targetStatusBarStyle
{
    _targetStatusBarStyle = targetStatusBarStyle;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    [self setNeedsStatusBarAppearanceUpdate];

}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.targetStatusBarStyle;
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    SeaViewController *vc = [self.viewControllers lastObject];
    
    UIViewController *viewController = viewControllerToPresent;
    
    if([viewController isKindOfClass:[UINavigationController class]])
    {
        viewController = [[(UINavigationController*)viewControllerToPresent viewControllers] lastObject];
    }
    
    if([vc isKindOfClass:[SeaViewController class]] && [viewController isKindOfClass:[SeaViewController class]])
    {
        SeaViewController *tmp = (SeaViewController*)viewController;
        tmp.Sea_TabBarController = vc.Sea_TabBarController;
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
