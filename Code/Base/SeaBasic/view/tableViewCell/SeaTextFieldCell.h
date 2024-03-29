//
//  SeaTextFieldCell.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/1.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///边距
#define SeaTextFieldCellMargin 10.0

///控件之间的间隔
#define SeaTextFieldCellInterval 5.0

///


/**输入框cell
 */
@interface SeaTextFieldCell : UITableViewCell

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**输入框
 */
@property(nonatomic,readonly) UITextField *textField;

/**标题宽度 default is 80.0
 */
@property(nonatomic,assign) CGFloat titleWidth;

@end


/**带有倒计时的输入框
 */
@interface SeaCountDownTextFieldCell : SeaTextFieldCell

/**倒计时
 */
@property(nonatomic,readonly) SeaCountDownButton *countDownButton;

/**获取验证码回调
 */
@property(nonatomic,copy) void(^getCodeHandler)(void);

@end

/**带有下拉箭头的输入框
 */
@interface SeaDownArrowTextFieldCell : SeaTextFieldCell



@end

///输入框cell 信息
@interface SeaTextFieldInfo : NSObject


///类名，default is SeaTextFieldCell
@property(nonatomic,copy) NSString *classString;

///倒计时按钮
@property(nonatomic,strong) SeaCountDownButton *countDownBtn;

///关联的cell，不重用
@property(nonatomic,strong) SeaTextFieldCell *cell;

@end