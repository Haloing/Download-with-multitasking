//
//  BookListTableViewCell.h
//  多任务下载
//
//  Created by Mac OS X on 2017/5/12.
//  Copyright © 2017年 Haooing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookListTableViewCell;

@protocol BookListtableViewDelegate <NSObject>

- (void)downloadBtnClick:(BookListTableViewCell *)cell;

@end

@class BookListModel;

@interface BookListTableViewCell : UITableViewCell

@property(nonatomic, strong) BookListModel *model;

@property(nonatomic, weak) id<BookListtableViewDelegate> delegate;

@end
