//
//  SeaAlertView.h

//

#import <UIKit/UIKit.h>

//默认高度和宽度
#define _seaAlertViewWidth_ 160.0
#define _seaAlertViewHeight_ 80.0

/**信息提示框
 */
@interface SeaPromptView : UIView

/**信息内容
 */
@property(nonatomic,readonly) UILabel *messageLabel;

/**是否正在动画中
 */
@property(nonatomic,readonly) BOOL isAnimating;

/**是否要移除当提示框隐藏时，default is 'YES'
 */
@property(nonatomic,assign) BOOL removeFromSuperViewAfterHidden;

/**构造方法
 *@param frame 提示框大小位置
 *@param aMessage 要显示的信息
 *@return 一个初始化的 SeaAlertView
 */
- (id)initWithFrame:(CGRect)frame message:(NSString*)aMessage;

/**显示提示框并设置多少秒后消失
 *@param delay 消失延时时间
 */
- (void)showAndHideDelay:(NSTimeInterval) delay;

@end
