//
//  SeaFullImagePreviewView.h

//

#import <UIKit/UIKit.h>
#import "SeaFullImagePreviewCell.h"

@class SeaFullImagePreviewView;

/**完整图片预览 代理
 */
@protocol SeaFullImagePreviewViewDelegate <NSObject>

@optional
/**将进入满屏
 */
- (void)fullImagePreviewviewWillEnterFullScreen:(SeaFullImagePreviewView*) view;

/**已经进入满屏
 */
- (void)fullImagePreviewviewDidEnterFullScreen:(SeaFullImagePreviewView *) view;

/**将退出满屏
 */
- (void)fullImagePreviewviewWillExistFullScreen:(SeaFullImagePreviewView*) view;

/**已经退出满屏
 */
- (void)fullImagePreviewviewDidExistFullScreen:(SeaFullImagePreviewView*) view;

/**选择某个cell
 */
- (void)fullImagePreviewview:(SeaFullImagePreviewView*) view didSelectCellAtIndex:(NSInteger) index;

@end

/**完整图片预览
 */
@interface SeaFullImagePreviewView : UIView

/**图片路径集合 ，数组元素是 NSString
 */
@property(nonatomic,retain) NSArray *source;

/**当前显示的图片下标
 */
@property(nonatomic,assign) NSInteger visibleIndex;

/**是否可以缩放
 */
@property(nonatomic,assign) BOOL zoomEnable;

/**以前的父视图 退出全屏后使用
 */
@property(nonatomic,weak) UIView *previousSuperView;

/**以前的大小 退出全屏后使用
 */
@property(nonatomic,assign) CGRect previousFrame;

@property(nonatomic,weak) id<SeaFullImagePreviewViewDelegate> delegate;


/**构造方法
 *@param source 图片路径集合 ，数组元素是 NSString
 *@param index 当前显示的图片下标
 *@return 一个初始化的 SeaFullImagePreviewView 对象
 */
- (id)initWithSource:(NSArray*) source visibleIndex:(NSInteger) index;

/**显示全屏预览
 *@param show 是否显示
 *@param rect 起始位置大小，可以通过 - (CGRect)convertRect:(CGRect)rect toWindow:(UIWindow *)window 方法来获取
 *@param flag 是否动画
 */
- (void)setShowFullScreen:(BOOL) show fromRect:(CGRect) rect flag:(BOOL) flag;


/**重新加载数据
 */
- (void)reloadData;

/**获取可见的cell
 */
- (SeaFullImagePreviewCell*)visibleCell;

@end
