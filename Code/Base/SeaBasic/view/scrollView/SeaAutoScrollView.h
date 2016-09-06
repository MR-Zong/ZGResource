//
//  SeaAutoScrollView.h

//

#import "SeaScrollView.h"

/**自动滚动的scrollVie 可用于广告栏
 */
@interface SeaAutoScrollView : SeaScrollView

/**动画间隔 default is '5.0'
 */
@property(nonatomic,assign) NSTimeInterval animatedTimeInterval;


/**开始动画
 */
- (void)startAnimate;

/**停止动画
 */
- (void)stopAnimate;

@end
