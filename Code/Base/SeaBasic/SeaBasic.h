//
//  base.h
//  Sea
//
//

#import "SeaUtlities.h"
#import "SeaUtilities.h"
#import "SeaViewControllerHeaders.h"
#import "SeaViewHeaders.h"
#import "SeaCacheCrash.h"
#import "SeaAlbumAssetsViewController.h"
#import "SeaImageCropViewController.h"
#import "SeaDetectVersion.h"
#import "SeaHttpRequest.h"
#import "SeaNetworkQueue.h"
#import "SeaFileManager.h"
#import "SeaImageCacheTool.h"
#import "SeaUserDefaults.h"
#import "ChineseToPinyin.h"
#import "SeaBasicInitialization.h"

//基本信息头文件

#ifndef SeaBase_h
#define SeaBase_h

//发布(release)的项目不打印日志
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#define SeaDebug 1
#else
#define NSLog(...) {}
#define SeaDebug 0
#endif


//不需要在主线程上使用 dispatch_get_main_queue
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


//获取当前系统版本
#define _ios9_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define _ios8_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define _ios7_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define _ios6_1_ ([[UIDevice currentDevice].systemVersion floatValue] >= 6.1)
#define _ios6_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
#define _ios5_1_ ([[UIDevice currentDevice].systemVersion floatValue] >= 5.1)
#define _ios5_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0)

//手机屏幕的宽度和高度
#define _width_ MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define _height_ MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width)


//选项卡高度
#define _tabBarHeight_ 49.0

//导航栏高度
#define _navigationBarHeight_ 44.0

//状态栏高度
#define _statusHeight_ 20.0

//工具条高度
#define _toolBarHeight_ 44.0

//视图主要背景颜色
#define _SeaViewControllerBackgroundColor_ [SeaBasicInitialization sea_backgroundColor]

/**按钮背景颜色
 */
#define WMButtonBackgroundColor [SeaBasicInitialization sea_buttonBackgroundColor]

//app主色调
#define _appMainColor_ [SeaBasicInitialization sea_appMainColor]

//导航栏背景颜色
#define _navigationBarBackgroundColor_ [SeaBasicInitialization sea_navigationBarColor]

///状态栏样式
#define WMStatusBarStyle [SeaBasicInitialization sea_statusBarStyle]

///导航栏tintColor 和按钮标题颜色
#define WMTintColor [SeaBasicInitialization sea_tintColor]


//网络状态不好加载数据失败提示信息
#define _alertMsgWhenBadNetwork_ [SeaBasicInitialization sea_alertMsgWhenBadNetwork]

//分割线颜色
#define _separatorLineColor_ [SeaBasicInitialization sea_separatorLineColor]
#define _separatorLineWidth_ [SeaBasicInitialization sea_separatorLineWidth]

//主要字体名称
#define MainFontName [SeaBasicInitialization sea_mainFontName]

//数字字体、英文字体
#define MainNumberFontName [SeaBasicInitialization sea_mainNumberFontName]

///主题红色
#define WMRedColor [UIColor colorFromHexadecimal:@"F3273F"]

///保税商品背景颜色
#define WMPaymentGreenColor [UIColor colorFromHexadecimal:@"6DB26F" alpha:0.8]

///完税商品背景颜色
#define WMDutyFeeBlueColor [UIColor colorFromHexadecimal:@"5797BD" alpha:0.8]

///自营商品背景颜色
#define WMSelfRedColor [UIColor colorFromHexadecimal:@"AB434C" alpha:0.8]

//主要字体颜色
#define MainGrayColor [SeaBasicInitialization sea_mainTextColor]///#666666
#define MainTextColor MainGrayColor

//灰色背景颜色
#define MainDefaultBackColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]



/**域名
 */
static NSString *const SeaNetworkDomainName = @"www.lanisland.com";

/**所有网络请求的路径
 */
//http://www.icanin.cn/index.php/api -- 爱康
//http://o2o-store.shopex123.com/yingtaoshe/index.php/api -- 测试
static NSString *const SeaNetworkRequestURL = @"http://www.lanisland.com/index.php/api";

/**网络请求签名token
 */
//73719b2f03b66b4cefe8e064cb3f7eecb78763cad6b89738ce99c5a1466a3c78 -- 测试
//1a910bd1ffeb2ae7afb974c2cc512bc7b42d79392b2cb1b93b702e7dc9fbf6e0 -- 爱康
static NSString *const SeaNetworkECStoreSignatureToken = @"82ad8da91caf9d6556097b2163e0716e185612c9f082ceaca598791534ef758d";



#pragma mark- user

//头像大小
#define WMHeadImageSize 320

//店招大小
#define WMShopForImageSize CGSizeMake(_width_, _width_ / 2.8)


#endif
