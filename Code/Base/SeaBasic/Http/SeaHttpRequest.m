//
//  SeaHttpRequest.m

//

#import "SeaHttpRequest.h"
#import "SeaFileManager.h"
#import "SeaURLConnection.h"


@interface SeaHttpRequest ()<SeaURLConnectionDelegate>

//网络请求
@property(nonatomic,strong) SeaURLConnection *conn;

@end

@implementation SeaHttpRequest

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initilization];
    }
    return self;
}

- (id)initWithDelegate:(id<SeaHttpRequestDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
        [self initilization];
    }
    return self;
}

- (id)initWithDelegate:(id<SeaHttpRequestDelegate>)delegate identifier:(NSString *)identifier
{
    self = [super init];
    if(self)
    {
        self.delegate = delegate;
        self.identifier = identifier;
        [self initilization];
    }
    return self;
}

- (void)initilization
{
    self.timeOut = 60.0;
    self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    self.showDownloadProgress = NO;
    self.showUploadProgress = NO;
}

#pragma mark- property

- (void)setConn:(SeaURLConnection *)conn
{
    if(_conn != conn)
    {
        [_conn cancel];
        _conn = conn;
        _conn.downloadTemporayPath = [SeaFileManager getTemporaryFile];
        _conn.showUploadProgress = self.showUploadProgress;
        _conn.showDownloadProgress = self.showDownloadProgress;
    }
}

- (BOOL)requesting
{
    return [self.conn isExecuting];
}

#pragma mark-内存管理

- (void)dealloc
{
    [_conn cancel];
}

#pragma mark-publick

#pragma mark- get请求

/**get请求 可设置缓存协议
 *@param url get请求路径
 *@param cachePolicy 缓存协议
 */
- (void)downloadWithURl:(NSString *)url cache:(NSURLRequestCachePolicy)cachePolicy
{
    SeaURLRequest *request = [SeaURLRequest requestWithURL:url cachePolicy:cachePolicy imeoutInterval:self.timeOut];
    
    self.conn = [[SeaURLConnection alloc] initWithDelegate:self request:request];
    [self.conn startWithoutOperationQueue];
}

/**get请求 使用默认的缓存协议
 *@param url get请求路径
 */
- (void)downloadWithURL:(NSString *)url
{
    [self downloadWithURl:url cache:self.cachePolicy];
}

#pragma mark- post请求

/**post请求 可设置缓存协议
 *@param url post请求路径
 *@param dic 请求参数
 *@param cachePolicy 缓存协议
 */
- (void)downloadWithURL:(NSString *)url dic:(NSDictionary *)dic cache:(NSURLRequestCachePolicy)cachePolicy
{
    SeaURLRequest *request = [SeaURLRequest requestWithURL:url cachePolicy:cachePolicy imeoutInterval:self.timeOut];
    [request addPostValueFromDictionary:dic];
    
    self.conn = [[SeaURLConnection alloc] initWithDelegate:self request:request];
    
    [self.conn startWithoutOperationQueue];
}

/**post请求 使用默认的缓存协议
 *@param url post请求路径
 *@param dic 请求参数
 */
- (void)downloadWithURL:(NSString *)url dic:(NSDictionary *)dic
{
    [self downloadWithURL:url dic:dic cache:self.cachePolicy];
}

/**可上传文件的post请求 文件参数不能重复
 *@param url post请求路径
 *@param paraDic 请求参数
 *@param fileDic 文件参数
 */
- (void)downloadWithURL:(NSString *)url paraDic:(NSDictionary *)paraDic fileDic:(NSDictionary *)fileDic
{
    SeaURLRequest *request = [SeaURLRequest requestWithURL:url cachePolicy:self.cachePolicy imeoutInterval:self.timeOut];
    [request addPostValueFromDictionary:paraDic];
    [request addFileFromDictionary:fileDic];
    
    self.conn = [[SeaURLConnection alloc] initWithDelegate:self request:request];
    [self.conn startWithoutOperationQueue];
}

/**可上传文件的post请求 文件参数可以重复
 *@param url post请求路径
 *@param paraDic 请求参数
 *@param fileArray 文件路径，数组元素是 NSString
 *@param key 文件参数
 */
- (void)downloadWithURL:(NSString *)url paraDic:(NSDictionary *)paraDic files:(NSArray *)fileArray filesKey:(NSString *)key
{
    SeaURLRequest *request = [SeaURLRequest requestWithURL:url cachePolicy:self.cachePolicy imeoutInterval:self.timeOut];
    [request addPostValueFromDictionary:paraDic];
    [request addFileFromFiles:fileArray fileKey:key];
    
    self.conn = [[SeaURLConnection alloc] initWithDelegate:self request:request];
    [self.conn startWithoutOperationQueue];
}


#pragma mark- cancel

/**取消 请求
 */
- (void)cancelRequest
{
    self.conn = nil;
}


#pragma mark- SeaURLConnection delegate

- (void)connectionDidFail:(SeaURLConnection *)conn
{
    NSLog(@"SeaURLConnection fail ,url = %@", conn.request.request.URL);
    
    if([self.delegate respondsToSelector:@selector(httpRequest:didFailed:)])
    {
        [self.delegate httpRequest:self didFailed:conn.errorCode];
    }
    
    if(self.completionHandler)
    {
        self.completionHandler(self, nil, conn.errorCode);
    }
    
    //self.conn = nil;
}

- (void)connectionDidUpdateProgress:(SeaURLConnection *)conn
{
    if([self.delegate respondsToSelector:@selector(httpRequest:didUpdateUploadProgress:downloadProgress:)])
    {
        [self.delegate httpRequest:self didUpdateUploadProgress:conn.uploadProgress downloadProgress:conn.downloadProgress];
    }
    
    if(self.progressHandler)
    {
        self.progressHandler(self, conn.uploadProgress, conn.downloadProgress);
    }
}

- (void)connectionDidFinishLoading:(SeaURLConnection *)conn
{
    NSData *data = conn.responseData;
    if([self.delegate respondsToSelector:@selector(httpRequest:didFailed:)])
    {
        [self.delegate httpRequest:self didFinishedLoading:data];
    }
    
    if(self.completionHandler)
    {
        self.completionHandler(self, data, SeaHttpErrorCodeNoError);
    }
    
   // self.conn = nil;
}


#pragma mark- add param
/**给http请求添加参数
 */
- (void)addPostValue:(id<NSObject>) value forKey:(NSString*) key
{
    if(self.conn)
    {
        [self.conn.request addPostValue:value forKey:key];
    }
}

/**给http请求添加文件
 */
- (void)addFiles:(NSArray *)files forKey:(NSString *)key
{
    if(self.conn)
    {
        [self.conn.request addFileFromFiles:files fileKey:key];
    }
}




@end
