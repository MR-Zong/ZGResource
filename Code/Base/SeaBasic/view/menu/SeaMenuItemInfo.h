//
//  SeaMenuItemInfo.h

//

#import <UIKit/UIKit.h>

/**菜单按钮信息
 */
@interface SeaMenuItemInfo : NSObject

/**标题
 */
@property(nonatomic,copy) NSString *title;

/**按钮图标
 */
@property(nonatomic,strong) UIImage *icon;

/**按钮背景图片
 */
@property(nonatomic,strong) UIImage *backgroundImage;

/**按钮边缘数据
 */
@property(nonatomic,copy) NSString *badgeNumber;

/**按钮宽度
 */
@property(nonatomic,assign) CGFloat itemWidth;

/**构造方法
 *@param title 标题
 *@return 已初始化的 SeaMenuItemInfo
 */
+ (id)infoWithTitle:(NSString*) title;

@end
