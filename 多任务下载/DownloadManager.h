//
//  DownloadManager.h
//  多任务下载
//
//  Created by Mac OS X on 2017/5/13.
//  Copyright © 2017年 Haooing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (instancetype)sharedManager;


//下载主方法
- (void)downloadWithUrlString:(NSString *)urlStr progress:(void(^)(float progress))progressBlock finishWithFilePath:(void(^)(NSString *filePath))filePathBlock;

- (BOOL)checkIsDownloadWithUrlStr:(NSString *)url;

- (void)pauseDoenloadWithUrlStr:(NSString *)urlStr;

@end
