//
//  UIImageView+SeaImageCacheTool.h

//

#import <UIKit/UIKit.h>
#import "SeaImageCacheTool.h"

/**图片缓存类目
 */
@interface UIImageView (SeaImageCacheTool)

/**图片服务器路径
 */
@property(nonatomic,readonly) NSString *sea_imageURL;

/**缩略图大小 default is 'self.bounds.size',如果值 为CGSizeZero表示不使用缩略图，可设置bounds.size
 */
@property(nonatomic,assign) CGSize sea_thumbnailSize;

/**显示加载指示器，当加载图片时 default is 'NO'
 */
@property(nonatomic,assign) BOOL sea_showLoadingActivity;

/**未加载图片显示的内容
 */
@property(nonatomic,strong) UIColor *sea_placeHolderColor;

/**未加载时显示的图片 default is 'nil'
 */
@property(nonatomic,strong) UIImage *sea_placeHolderImage;

/**加载指示器
 */
@property(nonatomic,strong) UIActivityIndicatorView *sea_actView;

/**加载指示器样式 default is 'UIActivityIndicatorViewStyleGray'
 */
@property(nonatomic,assign) UIActivityIndicatorViewStyle sea_actStyle;


/**设置图片路径
 *@param url 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL;

/**设置图片路径
 *@param url 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion;

/**设置图片路径
 *@param url 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL progress:(SeaImageCacheToolProgressHandler) progress;

/**设置图片路径
 *@param url 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress;

@end
