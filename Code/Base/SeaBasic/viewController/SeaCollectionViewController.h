//
//  SeaCollectionViewController.h

//

#import "SeaScrollViewController.h"


/**网格视图控制器
 */
@interface SeaCollectionViewController : SeaScrollViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

/**构造方法
 *@param layout 布局方式，传nil会使用默认的布局
 *@return 一个初始化的 SeaCollectionViewController 对象
 */
- (id)initWithFlowLayout:(UICollectionViewFlowLayout*) layout;

/**信息列表
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**布局方式
 */
@property(nonatomic,strong) UICollectionViewFlowLayout *layout;


@end
