//
//  SeaMenuBarItem.h

//

#import <UIKit/UIKit.h>

@class SeaNumberBadge,SeaMenuItemInfo;

/**条形菜单按钮
 */
@interface SeaMenuBarItem : UICollectionViewCell

/**按钮
 */
@property(nonatomic,readonly) UIButton *button;

/**边缘数字
 */
@property(nonatomic,readonly) SeaNumberBadge *numberBadge;

/**分隔符
 */
@property(nonatomic,readonly) UIView *separator;

///按钮信息
@property(nonatomic,strong) SeaMenuItemInfo *info;


@end
