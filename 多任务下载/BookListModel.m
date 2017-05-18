//
//  BookListModel.m
//  多任务下载
//
//  Created by Mac OS X on 2017/5/12.
//  Copyright © 2017年 Haooing. All rights reserved.
//

#import "BookListModel.h"

@implementation BookListModel

+ (instancetype)initWithDict:(NSDictionary *)dict{
    
    id instance = [[self alloc] init];
    
    [instance setValuesForKeysWithDictionary:dict];
    
    return instance;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
}

@end
