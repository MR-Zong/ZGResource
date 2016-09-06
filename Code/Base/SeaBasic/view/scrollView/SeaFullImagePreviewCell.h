//
//  UBFullImagePreviewCell.h

//

#import "SeaScrollViewCell.h"

/**完整图片预览cell
 */
@interface SeaFullImagePreviewCell : UIScrollView<UIScrollViewDelegate>

/**图片
 */
@property(nonatomic,readonly) UIImageView *imageView;

/**重新布局图片当图片加载完成时
 */
- (void)layoutImageAfterLoad;

@end
