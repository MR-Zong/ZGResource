//
//  SeaNetworkQueue.m

//

#import "SeaNetworkQueue.h"
#import "SeaURLConnection.h"
#import "SeaFileManager.h"
#import "SeaBasic.h"

@interface SeaNetworkQueue ()<SeaURLConnectionDelegate>

/**请求队列
 */
@property(nonatomic,strong) NSOperationQueue *queue;

/**正在执行的请求
 */
@property(nonatomic,strong) NSMutableDictionary *processRequestDic;

@property(nonatomic,weak) id<SeaNetworkQueueDelegate> delegate;


@end

@implementation SeaNetworkQueue

/**构造方法
 *@param delegate 队列代理
 *@return 一个实例
 */
- (id)initWithDelegate:(id<SeaNetworkQueueDelegate>) delegate
{
    self = [super init];
    if(self)
    {
        _maxConcurrentOperationCount = 4;
        self.delegate = delegate;
        self.processRequestDic = [NSMutableDictionary dictionary];
        self.shouldCancelAllRequestWhenOneFail = YES;
        self.showQueueProgress = NO;
        self.showRequestProgress = NO;
    }
    
    return self;
}

#pragma mark- dealloc

- (void)dealloc
{
    [_queue cancelAllOperations];
}

#pragma mark- property setup 

- (void)setShouldCancelAllRequestWhenOneFail:(BOOL)shouldCancelAllRequestWhenOneFail
{
    if(_shouldCancelAllRequestWhenOneFail != shouldCancelAllRequestWhenOneFail)
    {
        _shouldCancelAllRequestWhenOneFail = shouldCancelAllRequestWhenOneFail;
    }
}

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount
{
    if(_maxConcurrentOperationCount != maxConcurrentOperationCount)
    {
        _maxConcurrentOperationCount = maxConcurrentOperationCount;
        self.queue.maxConcurrentOperationCount = _maxConcurrentOperationCount;
    }
}

#pragma mark- public method

/**添加请求 如 [addRequestWithURL:url param:nil identifier:identifier]
 */
- (void)addRequestWithURL:(NSString*) url identifier:(NSString*) identifier
{
    [self addRequestWithURL:url param:nil identifier:identifier];
}

/**添加请求
 *@param url 请求地址
 *@param param 请求参数，如果是get请求，传nil，如果post请求没有参数 传一个初始化的 NSDictionary
 *@param identifier 请求标识
 */
- (void)addRequestWithURL:(NSString*) url param:(NSDictionary*) param identifier:(NSString*) identifier
{
    [self addRequestWithURL:url param:param files:nil filesKey:nil identifier:identifier];
}

/**添加请求
 *@param url 请求地址
 *@param param 请求参数，如果是get请求，传nil，如果post请求没有参数 传一个初始化的 NSDictionary
 *@param files 文件路径，数组元素是 NSString
 *@param key 文件key
 *@param identifier 请求标识
 */
- (void)addRequestWithURL:(NSString*) url param:(NSDictionary*) param files:(NSArray*) files filesKey:(NSString*) key identifier:(NSString*) identifier
{
    NSAssert(identifier != nil, @"addRequestWithURL:(NSString*) url param:(NSDictionary*) param identifier:(NSString*) identifier , identifier 不能为nil");
    
    [self createQueue];
    
    SeaURLRequest *request = [[SeaURLRequest alloc] initWithURL:url];
    [request addPostValueFromDictionary:param];
    [request addFileFromFiles:files fileKey:key];
    
    SeaURLConnection *conn = [[SeaURLConnection alloc] initWithDelegate:self request:request];
    conn.downloadTemporayPath = [SeaFileManager getTemporaryFile];
    conn.name = identifier;
    
    if(_showRequestProgress || _showQueueProgress)
    {
        conn.showDownloadProgress = YES;
        conn.showUploadProgress = YES;
    }
    
    [self.processRequestDic setObject:conn forKey:identifier];
    
    [self.queue addOperation:conn];
}

/**开始下载
 */
- (void)startDownload
{
    [self.queue setSuspended:NO];
}

/**重新设置
 */
- (void)reset
{
    [self.queue cancelAllOperations];
    [self.processRequestDic removeAllObjects];
    _totalBytesToDownload = 0;
    _totalBytesDidDownload = 0;
    _totalBytesDidUpload = 0;
    _totalBytesToUpload = 0;
}

/**取消某个请求
 *@param identifier 请求标识
 */
- (void)cancelRequestWithIdentifier:(NSString*) identifier
{
    NSAssert(identifier != nil, @"cancelRequestWithIdentifier: , identifier 不能为nil");
    
    SeaURLConnection *conn = [self.processRequestDic objectForKey:identifier];
    if(conn)
    {
        [conn cancel];
        [self.processRequestDic removeObjectForKey:identifier];
    }
}

/**取消所有请求
 */
- (void)cancelAllRequest
{
    [self reset];
}

/**相关下载是否正在进行中
 *@param identifier 请求标识
 */
- (BOOL)isRequestingWithIdentifier:(NSString*) identifier
{
    if([NSString isEmpty:identifier])
        return NO;
    return [self.processRequestDic objectForKey:identifier] != nil;
}

#pragma mark- queue

//创建请求队列
- (void)createQueue
{
    if(!self.queue)
    {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = _maxConcurrentOperationCount;
        [self.queue setSuspended:YES];
    }
}

//所有请求完成
- (void)queueDidFinish
{
    if([self.delegate respondsToSelector:@selector(networkQueueDidFinish:)])
    {
        [self.delegate networkQueueDidFinish:self];
    }
    
    if(self.queueCompletionHandler)
    {
        self.queueCompletionHandler(self);
    }
}

#pragma mark- SeaURLConnection delegate

//单个请求完成
- (void)connectionDidFinishLoading:(SeaURLConnection *)conn
{
    dispatch_main_async_safe(^(void){
        
        NSData *data = conn.responseData;
        if([self.delegate respondsToSelector:@selector(networkQueue:requestDidFinishWithData:identifier:)])
        {
            [self.delegate networkQueue:self requestDidFinishWithData:data identifier:conn.name];
        }
        
        if(self.requestCompletionHandler)
        {
            self.requestCompletionHandler(self, data, conn.errorCode, conn.name);
        }
        
        [self.processRequestDic removeObjectForKey:conn.name];
        
        if(self.processRequestDic.count == 0)
        {
            [self queueDidFinish];
        }
    });
}

//单个请求失败
- (void)connectionDidFail:(SeaURLConnection *)conn
{
    dispatch_main_async_safe(^(void){
        
        if([self.delegate respondsToSelector:@selector(networkQueue:requestDidFailWithError:identifier:)])
        {
            [self.delegate networkQueue:self requestDidFailWithError:conn.errorCode identifier:conn.name];
        }
        
        if(self.requestCompletionHandler)
        {
            self.requestCompletionHandler(self, nil, conn.errorCode, conn.name);
        }
        
        [self.processRequestDic removeObjectForKey:conn.name];
        
        if(self.shouldCancelAllRequestWhenOneFail)
        {
            [self reset];
            [self queueDidFinish];
        }
        else if(self.processRequestDic.count == 0)
        {
            [self queueDidFinish];
        }
    });
}

- (void)connectionDidGetDownloadSize:(SeaURLConnection *)conn
{
    _totalBytesToDownload += conn.totalBytesToDownload;
}

- (void)connectionDidGetUploaddSize:(SeaURLConnection *)conn
{
    _totalBytesToUpload += conn.totalBytesToUpload;
}

- (void)connectionDidUpdateProgress:(SeaURLConnection *)conn
{
    _totalBytesDidDownload += conn.totalBytesDidDownload;
    _totalBytesDidUpload += conn.totalBytesDidUpload;
    
    if(_showRequestProgress)
    {
        if([self.delegate respondsToSelector:@selector(networkQueue:didUpdateUploadProgress:downloadProgress:identifier:)])
        {
            [self.delegate networkQueue:self didUpdateUploadProgress:conn.uploadProgress downloadProgress:conn.downloadProgress identifier:conn.name];
        }
        
        if(self.requestProgressHandler)
        {
            self.requestProgressHandler(self, conn.uploadProgress, conn.downloadProgress, conn.name);
        }
    }
    
    if(_showQueueProgress)
    {
        if([self.delegate respondsToSelector:@selector(networkQueue:didUpdateQueueUploadProgress:downloadProgress:)])
        {
             [self.delegate networkQueue:self didUpdateQueueUploadProgress:(double)_totalBytesDidUpload / (double)MAX(_totalBytesToUpload, 1) downloadProgress:(double)_totalBytesDidDownload / (double)MAX(_totalBytesToDownload, 1)];
        }
       
        if(self.queueProgressHandler)
        {
            self.queueProgressHandler(self, (double)_totalBytesDidUpload / (double)MAX(_totalBytesToUpload, 1), (double)_totalBytesDidDownload / (double)MAX(_totalBytesToDownload, 1));
        }
    }
}

@end
