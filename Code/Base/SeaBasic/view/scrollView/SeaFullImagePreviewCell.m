//
//  UBFullImagePreviewCell.m

//

#import "SeaFullImagePreviewCell.h"
#import "SeaBasic.h"

@implementation SeaFullImagePreviewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 1.0;
        self.maximumZoomScale = 5.0;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.sea_showLoadingActivity = YES;
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.sea_actStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.sea_thumbnailSize = self.bounds.size;
        [self addSubview:_imageView];
        
    }
    return self;
}

- (void)dealloc
{
    
}


#pragma mark- scrollView delegate


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(_imageView.image)
    {
        return self.imageView;
    }
    else
    {
        return nil;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat x = (self.frame.size.width - _imageView.frame.size.width) / 2;
    x = x < 0 ? 0 : x;
    CGFloat y = (self.frame.size.height - _imageView.frame.size.height) / 2;
    y = y < 0 ? 0 : y;
    

    _imageView.center = CGPointMake(x + _imageView.frame.size.width / 2.0, y + _imageView.frame.size.height / 2.0);
}


/**重新布局图片当图片加载完成时
 */
- (void)layoutImageAfterLoad
{
    UIImage *image = self.imageView.image;
    if(image)
    {
        _imageView.frame = CGRectMake(MAX(0, (self.bounds.size.width - image.size.width) / 2.0), MAX((self.bounds.size.height - image.size.height) / 2.0, 0), image.size.width, image.size.height);
        self.contentSize = self.bounds.size;
    }
    else
    {
        _imageView.frame = self.bounds;
        self.contentSize = self.bounds.size;
    }
}

@end
