//
//  UBPicker.h

//

#import <UIKit/UIKit.h>

#define _UBPickerHeight_ 225.0

///银行卡数据的网络标识符
#define WMGetBankInfoIden @"WMGetBankInfoIden"
///快递公司数据的网络标识符
#define WMGetShippingInfoIden @"WMGetShippingInfoIden"
/**选择器类型
 */
typedef NS_ENUM(NSInteger, UBPickerStyle)
{
    //出生日期
    UBPickerStyleBirthDay = 0,
    
    ///银行信息
    UBPickerStyleBlank = 1,
    
    ///物流
    UBPickerStyleLogistics = 2,
};

@class UBPicker;

/**选择器代理
 */
@protocol UBPickerDelegate <NSObject>

@optional

/**完成选择 通过 objectForKey:[NSNumber numberWithInteger:self.style] 获取
 */
- (void)picker:(UBPicker*) picker didFinisedWithConditions:(NSDictionary*) conditions;

/**picker将要消失
 */
- (void)pickerWillDismiss:(UBPicker*)picker;

/**picker 已经消失
 */
- (void)pickerDidDismiss:(UBPicker*)picker;

/**picker 将要出现
 */
- (void)pickerWillAppear:(UBPicker*)picker;

/**picker 已经出现
 */
- (void)pickerDidAppear:(UBPicker*) picker;

@end

/**选择器
 */
@interface UBPicker : UIView

/**时间日期选择器
 */
@property(nonatomic,readonly) UIDatePicker *datePicker;

/**选择器
 */
@property(nonatomic,readonly) UIPickerView *picker;

/**设置点击picker上方 关闭选择器 default is 'YES'
 */
@property(nonatomic,assign) BOOL closeWhenTouchMargin;

/**选择器的条件标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**银行卡信息 、 物流公司 数组元素是 NSString
 */
@property(nonatomic,strong) NSArray *infos;

/**物流公司的ID数组
 */
@property (strong,nonatomic) NSArray *shippingIDArr;

/**选中的物理公司ID
 */
@property (copy,nonatomic) NSString *shippingID;

@property(nonatomic,weak) id<UBPickerDelegate> delegate;

/**选择器的条件类型
 */
@property(nonatomic,readonly) UBPickerStyle style;

/**构造方法
 *@param superView 选择器父视图
 *@param style 选择器类型
 */
- (id)initWithSuperView:(UIView*) superView style:(UBPickerStyle) style;

/**呼出选择器
 *@param animated 是否动画
 *@param completion 出现后调用
 */
- (void)showWithAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**隐藏选择器
 *@param animated 是否动画
 *@param completion 隐藏后调用
 */
- (void)dismissWithAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
