//
//  SeaHttpRequest.h

//

#import <Foundation/Foundation.h>
#import "SeaHttpInterface.h"

@class SeaHttpRequest;

///使用block时，如果block有使用成员变量，属性时要用 __weak修饰，防止循环引用

/**完成回调 使用属性中的 identifier 请求标识 来识别是哪个请求
 *@param conn 网络请求对象
 *@param data 请求返回的数据
 *@param code 请求状态码，0则请求成，否则请求失败
 *@param
 */
typedef void(^SeaHttpRequestCompletionHandler)(SeaHttpRequest *request, NSData *data, SeaHttpErrorCode code);

/**进度回调 showUploadProgress 必须设置为 YES，showDownloadProgress 必须设置为 YES，在主线程上调用，使用属性中的 identifier 请求标识 来识别是哪个请求
 *@param conn 网络请求对象
 *@param uploadProgress 上传进度，范围 0 ~ 1.0
 *@param downloadProgress 下载进度，范围 0 ~ 1.0
 */
typedef void(^SeaHttpRequestProgressHandler)(SeaHttpRequest *request, float uploadProgress, float downloadProgress);

/**http请求代理
 */
@protocol SeaHttpRequestDelegate <NSObject>


///以下代理可使用 request属性中的 identifier 请求标识 来识别是哪个请求

/**请求失败
 */
- (void)httpRequest:(SeaHttpRequest*) request didFailed:(SeaHttpErrorCode) error;

/**请求完成
 */
- (void)httpRequest:(SeaHttpRequest *)request didFinishedLoading:(NSData*) data;

@optional

/**更新进度条
 */
- (void)httpRequest:(SeaHttpRequest *)request didUpdateUploadProgress:(float) progress downloadProgress:(float) downlodProgress;

@end

/**http请求 一次只能执行一次请求，如果要并发执行多个请求，请使用 SeaNetworkQueue
 */
@interface SeaHttpRequest : NSObject

@property(nonatomic,weak) id<SeaHttpRequestDelegate> delegate;

/**超时时间 default is '60.0'
 */
@property(nonatomic,assign) NSTimeInterval timeOut;

/**缓存协议 default is 'NSURLRequestUseProtocolCachePolicy'
 */
@property(nonatomic,assign) NSURLRequestCachePolicy cachePolicy;

/**是否显示上传进度 default is 'NO'
 */
@property(nonatomic,assign) BOOL showUploadProgress;

/**是否显示下载进度 default is 'NO'
 */
@property(nonatomic,assign) BOOL showDownloadProgress;

/**请求标识
 */
@property(nonatomic,copy) NSString *identifier;

/**请求完成回调
 */
@property(nonatomic,copy) SeaHttpRequestCompletionHandler completionHandler;

/**进度回调
 */
@property(nonatomic,copy) SeaHttpRequestProgressHandler progressHandler;

/**是否正在请
 */
@property(nonatomic,readonly) BOOL requesting;

//构造方法
- (id)init;
- (id)initWithDelegate:(id<SeaHttpRequestDelegate>) delegate;
- (id)initWithDelegate:(id<SeaHttpRequestDelegate>)delegate identifier:(NSString*) identifier;

#pragma mark- get请求

/**get请求 可设置缓存协议
 *@param url get请求路径
 *@param cachePolicy 缓存协议
 */
- (void)downloadWithURl:(NSString*) url cache:(NSURLRequestCachePolicy) cachePolicy;

/**get请求 使用默认的缓存协议
 *@param url get请求路径
 */
- (void)downloadWithURL:(NSString*) url;

#pragma mark- post请求

/**post请求 可设置缓存协议
 *@param url post请求路径
 *@param dic 请求参数
 *@param cachePolicy 缓存协议
 */
- (void)downloadWithURL:(NSString*) url dic:(NSDictionary*) dic cache:(NSURLRequestCachePolicy) cachePolicy;

/**post请求 使用默认的缓存协议
 *@param url post请求路径
 *@param dic 请求参数
 */
- (void)downloadWithURL:(NSString*) url dic:(NSDictionary*) dic;

/**可上传文件的post请求 文件参数不能重复
 *@param url post请求路径
 *@param paraDic 请求参数
 *@param fileDic 文件参数
 */
- (void)downloadWithURL:(NSString *)url paraDic:(NSDictionary*) paraDic fileDic:(NSDictionary*) fileDic;

/**可上传文件的post请求 文件参数可以重复
 *@param url post请求路径
 *@param paraDic 请求参数
 *@param fileArray 文件路径，数组元素是 NSString
 *@param key 文件参数
 */
- (void)downloadWithURL:(NSString *)url paraDic:(NSDictionary *)paraDic files:(NSArray*) fileArray filesKey:(NSString*) key;

#pragma mark- cancel

/**取消 请求
 */
- (void)cancelRequest;

#pragma mark- add param

/**给http请求添加参数
 */
- (void)addPostValue:(id<NSObject>) value forKey:(NSString*) key;

/**给http请求添加文件
 *@param files 数组元素是文件路径，NSString对象
 */
- (void)addFiles:(NSArray*) files forKey:(NSString *)key;


@end
