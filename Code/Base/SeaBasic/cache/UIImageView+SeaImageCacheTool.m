//
//  UIImageView+SeaImageCacheTool.m

//

#import "UIImageView+SeaImageCacheTool.h"
#import <objc/runtime.h>
#import "SeaBasic.h"

@implementation UIImageView (SeaImageCacheTool)

#pragma mark- property

- (void)setSea_imageURL:(NSString *)sea_imageURL
{
    objc_setAssociatedObject(self, &SeaImageCacheToolImageURL, sea_imageURL, OBJC_ASSOCIATION_RETAIN);
}

- (NSString*)sea_imageURL
{
    return objc_getAssociatedObject(self, &SeaImageCacheToolImageURL);
}

- (void)setSea_thumbnailSize:(CGSize)sea_thumbnailSize
{
    objc_setAssociatedObject(self, &SeaImageCacheToolThumbnailSize, [NSValue valueWithCGSize:sea_thumbnailSize], OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)sea_thumbnailSize
{
    NSValue *value = objc_getAssociatedObject(self, &SeaImageCacheToolThumbnailSize);
//    if(value == nil)
//    {
//        return self.bounds.size;
//    }
//    else
    {
        return [value CGSizeValue];
    }
}

- (void)setSea_showLoadingActivity:(BOOL)sea_showLoadingActivity
{
    objc_setAssociatedObject(self, &SeaImageCacheToolShowLoadingActivity, [NSNumber numberWithBool:sea_showLoadingActivity], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)sea_showLoadingActivity
{
    return [objc_getAssociatedObject(self, &SeaImageCacheToolShowLoadingActivity) boolValue];
}

- (void)setSea_placeHolderColor:(UIColor *)sea_placeHolderColor
{
    objc_setAssociatedObject(self, &SeaImageCacheToolPlaceHolderColor, sea_placeHolderColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor*)sea_placeHolderColor
{
    UIColor *color = objc_getAssociatedObject(self, &SeaImageCacheToolPlaceHolderColor);
    if(color == nil)
    {
        color = _SeaImageBackgroundColorBeforeDownload_;
    }
    
    return color;
}

- (void)setSea_placeHolderImage:(UIImage *)sea_placeHolderImage
{
    objc_setAssociatedObject(self, &SeaImageCacheToolPlaceHolderImage, sea_placeHolderImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage*)sea_placeHolderImage
{
    UIImage *placeHolder = objc_getAssociatedObject(self, &SeaImageCacheToolPlaceHolderImage);
    if(placeHolder == nil)
    {
        CGSize size = self.bounds.size;
        
        /**正方形
         */
        if(size.width == size.height)
        {
            //大的
            if(size.width > 150)
            {
                placeHolder = [UIImage imageNamed:@"placeHolder_square_big"];
            }
            else
            {
                placeHolder = [UIImage imageNamed:@"placeHolder_square_small"];
            }
        }
        else
        {
            placeHolder = [UIImage imageNamed:@"placeHolder_rect"];
        }
    }
    return placeHolder;
}

- (void)setSea_actView:(UIActivityIndicatorView *)sea_actView
{
    objc_setAssociatedObject(self, &SeaImageCacheToolActivity, sea_actView, OBJC_ASSOCIATION_RETAIN);
}

- (UIActivityIndicatorView*)sea_actView
{
    return objc_getAssociatedObject(self, &SeaImageCacheToolActivity);
}

- (void)setSea_actStyle:(UIActivityIndicatorViewStyle)sea_actStyle
{
    objc_setAssociatedObject(self, &SeaImageCacheToolActivityStyle, [NSNumber numberWithInteger:sea_actStyle], OBJC_ASSOCIATION_RETAIN);
    if(self.sea_actView != nil)
    {
        self.sea_actView.activityIndicatorViewStyle = sea_actStyle;
    }
}

- (UIActivityIndicatorViewStyle)sea_actStyle
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaImageCacheToolActivityStyle);
    if(number == nil)
    {
        return UIActivityIndicatorViewStyleGray;
    }
    else
    {
        return [number integerValue];
    }
}

#pragma mark- getImage

//设置加载状态
- (void)setupLoading:(BOOL) loading
{
    BOOL _loading = [objc_getAssociatedObject(self, &SeaImageCacheToolLoading) boolValue];
    
    if(loading == _loading)
        return;
    
    objc_setAssociatedObject(self, &SeaImageCacheToolLoading, [NSNumber numberWithBool:loading], OBJC_ASSOCIATION_RETAIN);
    if(loading)
    {
        //优先使用预载图
        if(self.sea_placeHolderImage)
        {
            self.image = self.sea_placeHolderImage;
        }
        else
        {
            self.image = nil;
            self.backgroundColor = self.sea_placeHolderColor;
        }
    }
    
    if(self.sea_showLoadingActivity)
    {
        if(loading)
        {
            if(!self.sea_actView)
            {
                UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.sea_actStyle];
                view.center = CGPointMake(self.width / 2.0, self.height / 2.0);
                [self addSubview:view];
                self.sea_actView = view;
            }
            
            [self.sea_actView startAnimating];
        }
        else
        {
            [self.sea_actView stopAnimating];
        }
    }
}

/**设置图片路径
 *@param url 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL
{
    [self sea_setImageWithURL:URL completion:nil progress:nil];
}

/**设置图片路径
 *@param url 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion
{
    [self sea_setImageWithURL:URL completion:completion progress:nil];
}

/**设置图片路径
 *@param url 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL progress:(SeaImageCacheToolProgressHandler) progress
{
    [self sea_setImageWithURL:URL completion:nil progress:progress];
}

/**设置图片路径
 *@param url 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress
{
    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
    
    //无效的url
    if([NSString isEmpty:URL])
    {
        [self setupLoading:NO];
        
        //优先使用预载图
        if(self.sea_placeHolderImage)
        {
            self.image = self.sea_placeHolderImage;
        }
        else
        {
            self.image = nil;
            self.backgroundColor = self.sea_placeHolderColor;
        }
        
        [cache cancelDownloadWithURL:self.sea_imageURL target:self];
        
        self.sea_imageURL = nil;
        if(completion)
        {
            completion(nil, NO);
        }
        return;
    }
    
    //此图片正在下载
    if([cache isRequestingWithURL:URL])
    {
        [self setupLoading:YES];
        [cache addCompletion:[self completionHandlerWithBlock:completion] thumbnailSize:self.sea_thumbnailSize target:self forURL:URL];
        return;
    }
    
    //取消以前的下载
    [cache cancelDownloadWithURL:self.sea_imageURL target:self];
    self.sea_imageURL = URL;
    
    //判断内存中是否有图片
    UIImage *thumbnail = [cache imageFromMemoryWithURL:URL thumbnailSize:self.sea_thumbnailSize];
    
    if(thumbnail)
    {
        self.image = thumbnail;
        [self setupLoading:NO];
        if(completion)
        {
            completion(thumbnail, NO);
        }
    }
    
    if(!thumbnail)
    {
        [self setupLoading:YES];
        //重新加载图片
        [cache getImageWithURL:URL thumbnailSize:self.sea_thumbnailSize completion:[self completionHandlerWithBlock:completion] target:self];
    }
}

///图片加载完成回调
- (SeaImageCacheToolCompletionHandler)completionHandlerWithBlock:(SeaImageCacheToolCompletionHandler) block
{
    //加载完成回调
    __weak UIImageView *weakSelf = self;
    SeaImageCacheToolCompletionHandler completionHandler = ^(UIImage *image , BOOL fromNetwork){
        
        [weakSelf setupLoading:NO];
        
        //渐变效果
        if(image)
        {
            if(fromNetwork)
            {
                CATransition *animation = [CATransition animation];
                animation.duration = 0.25;
                animation.type = kCATransitionFade;
                [weakSelf.layer addAnimation:animation forKey:nil];
            }
            weakSelf.image = image;
            weakSelf.backgroundColor = [UIColor clearColor];
        }
        
        if(block)
        {
            block(image, fromNetwork);
        }
    };
    
    return completionHandler;
}

///会影响父类的dealloc
//- (void)dealloc
//{
//    SeaImageCacheTool *cache = [SeaImageCacheTool sharedInstance];
//    [cache cancelDownloadWithURL:self.sea_imageURL target:self];
//}

@end
