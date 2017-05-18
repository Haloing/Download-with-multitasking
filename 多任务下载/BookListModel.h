//
//  BookListModel.h
//  多任务下载
//
//  Created by Mac OS X on 2017/5/12.
//  Copyright © 2017年 Haooing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookListModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic ,copy) NSString *path;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) float progress;

+ (instancetype)initWithDict:(NSDictionary *)dict;

@end
