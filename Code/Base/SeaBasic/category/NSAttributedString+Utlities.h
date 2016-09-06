//
//  NSAttributedString+Utlities.h

//
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (Utlities)

/**获取富文本框大小
 *@param with 每行最大宽度
 *@return 富文本框大小
 */
- (CGSize)boundsWithConstraintWidth:(CGFloat) width;

@end
