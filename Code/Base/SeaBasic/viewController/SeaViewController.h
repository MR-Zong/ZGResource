//
//  SeaViewController.h

//
//

#import <UIKit/UIKit.h>


/**控制视图的基类
 */
@interface SeaViewController : UIViewController

///xcode 7中xib的子视图不会在viewDidLoad中加载，在vewiDidAppear中加载 子类重新该方法
- (void)sea_viewDidLoad;

@end
