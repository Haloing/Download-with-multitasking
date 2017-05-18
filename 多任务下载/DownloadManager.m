//
//  DownloadManager.m
//  多任务下载
//
//  Created by Mac OS X on 2017/5/13.
//  Copyright © 2017年 Haooing. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager ()<NSURLSessionDownloadDelegate>

@property (nonatomic, copy) void(^pathBlock)(NSString *filePath);

//下载进度回调缓存池
@property (nonatomic, strong) NSMutableDictionary *downloadDict;

//下载操作缓存池
@property (nonatomic, strong) NSMutableDictionary *sessionDict;

@end

@implementation DownloadManager{
    
    //定义全局的NSURLSession
    NSURLSession *_downloadSession;
    
}

+ (instancetype)sharedManager{
    
    static id instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
    
}

#pragma mark
#pragma mark - 重写单例实例化方法，实现

- (instancetype)init{
    
    if (self  = [super init]) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _downloadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        
        self.downloadDict = [[NSMutableDictionary alloc] init];
        
        self.sessionDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (BOOL)checkIsDownloadWithUrlStr:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionDownloadTask *downloadTask = [self.sessionDict objectForKey:url];
    
    if (downloadTask == nil) {
        
        return NO;
        
    }
    
    return YES;
}

- (void)pauseDoenloadWithUrlStr:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionDownloadTask *downloadTask = [self.sessionDict objectForKey:url];
    
    if (downloadTask) {
        
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            
            NSString *filePath = [NSString stringWithFormat:@"/Users/a123/Desktop/%@.tmp",[url lastPathComponent]];
            
            [resumeData writeToFile:filePath atomically:YES];
            
            NSLog(@"pausetmp文件路径:%@",filePath);
            
            //清楚缓存池里面的缓存
            [self.sessionDict removeObjectForKey:url];
            
            [self.downloadDict removeObjectForKey:downloadTask];
            
        }];
        
    }
}

- (void)downloadWithUrlString:(NSString *)urlStr progress:(void (^)(float))progressBlock finishWithFilePath:(void (^)(NSString *))filePathBlock{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSString *filePath = [NSString stringWithFormat:@"/Users/a123/Desktop/%@.tmp",[url lastPathComponent]];
    
    NSLog(@"downloadtmp文件路径:%@",filePath);
    
    NSData *resumeData = [NSData dataWithContentsOfFile:filePath];
    
    NSURLSessionDownloadTask *downloadTask;
    
    if (resumeData != nil) {
        
        downloadTask = [_downloadSession downloadTaskWithResumeData:resumeData];
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
        
    }else{
        
        downloadTask = [_downloadSession downloadTaskWithURL:url];
        
    }
    
    self.pathBlock = filePathBlock;
    
    [self.downloadDict setObject:progressBlock forKey:downloadTask];
    
    [self.sessionDict setObject:downloadTask forKey:url];
    
    [downloadTask resume];
    
}

#pragma mark
#pragma mark - 实现代理方法，监听下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:
                   (nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:
                   (int64_t)bytesWritten totalBytesWritten:
                   (int64_t)totalBytesWritten totalBytesExpectedToWrite:
                   (int64_t)totalBytesExpectedToWrite{
    
    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    
    void(^progressBlock)(float progress) = [self.downloadDict objectForKey:downloadTask];
    
    if (progressBlock) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
            progressBlock(progress);
            
        }];
        
    }
}

//下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSString *finishStr;
    
    NSString *str = [downloadTask.currentRequest.URL.absoluteString lastPathComponent];
    
    NSString *savePath = [NSString stringWithFormat:@"/Users/a123/Desktop/%@",str];
    
    BOOL isDownload = [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:savePath error:NULL];
    
    NSLog(@"下载完成");
    
    if (isDownload) {
        
        finishStr = savePath;
        
    }else{
        
        finishStr = @"下载错误";
    }
    
    self.pathBlock(savePath);
    
    [self.downloadDict removeObjectForKey:downloadTask];
    
    [self.sessionDict removeObjectForKey:downloadTask.response.URL.absoluteString];
    
}
@end
