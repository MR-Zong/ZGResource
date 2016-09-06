//
//  SeaLabel.h

//

#import <UIKit/UIKit.h>

@class SeaLabel;

@protocol SeaLabelDelegate <NSObject>

/**点击链接
 */
- (void)label:(SeaLabel*) label didSelectURL:(NSURL*) URL;

@end

/**自定义标签，可识别链接，点击时可打开该链接
 *使用coreText实现，在设置富文本的时候要使用 coreText的属性，否则会出现无法预料的后果
 *如 设置字体颜色要用 kCTForegroundColorAttributeName，而不是 NSForegroundColorAttributeName
 */
@interface SeaLabel : UIView<UIGestureRecognizerDelegate>

/**要显示的文本
 */
@property(nonatomic,copy) NSString *text;

/**富文本
 */
@property(nonatomic,copy) NSAttributedString *attributedText;

/**文本颜色
 */
@property(nonatomic,strong) UIColor *textColor;

/**字体
 */
@property(nonatomic,strong) UIFont *font;

/**内容对齐方式
 */
@property(nonatomic,assign) NSTextAlignment textAlignment;

/**是否识别链接，default is 'YES'
 */
@property(nonatomic,assign) BOOL identifyURL;

/**URL 样式 默认蓝色字体加下划线
 */
@property(nonatomic,strong) NSDictionary *URLAttributes;

/**点击的高亮颜色 default is '_UIKitTintColor_'
 */
@property(nonatomic,strong) UIColor *highlightColor;

/**文字与边框的距离 default is 'UIEdgeInsetsZero'
 */
@property(nonatomic,assign) UIEdgeInsets textInsets;

/**最小行高度 default 24.0
 */
@property(nonatomic,assign) CGFloat minLineHeight;

/**文字与文字间的距离 default 1.0
 */
@property(nonatomic,assign) CGFloat wordSpace;

@property(nonatomic,weak) id<SeaLabelDelegate> delegate;

/**获取默认的富文本
 *@param string 要生成富文本的字符串
 *@return 根据 font textColor textAlignment 生成的富文本
 */
- (NSMutableAttributedString*)defaultAttributedTextFromString:(NSString*) string;

@end
