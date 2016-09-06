//
//  SeaTableViewController.h
//  Sea

//

#import "SeaScrollViewController.h"

/**列表控制视图
 */
@interface SeaTableViewController : SeaScrollViewController<UITableViewDelegate,UITableViewDataSource>

/**信息列表
 */
@property(nonatomic,readonly) UITableView *tableView;

/**列表风格
 */
@property(nonatomic,assign) UITableViewStyle style;

/**分割线 是否满屏，default is 'NO'
 */
@property(nonatomic,assign) BOOL cellSeparatorFullScreen;

/**构造方法
 *@param style 列表风格
 *@return 一个初始化的 SeaTableViewController 对象
 */
- (id)initWithStyle:(UITableViewStyle) style;



@end
