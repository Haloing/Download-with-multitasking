//
//  BookListTableViewCell.m
//  多任务下载
//
//  Created by Mac OS X on 2017/5/12.
//  Copyright © 2017年 Haooing. All rights reserved.
//

#import "BookListTableViewCell.h"
#import "BookListModel.h"

@interface BookListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation BookListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIButton *downloadButton = [[UIButton alloc] init];
    
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    
    [downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [downloadButton setTitle:@"暂停" forState:UIControlStateSelected];
    
    [downloadButton setBackgroundColor:[UIColor grayColor]];
    
    [downloadButton sizeToFit];
    
    self.accessoryView = downloadButton;
    
    [downloadButton addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark
#pragma mark - 实现按钮点击方法
- (void)downloadClick:(UIButton *)btn{
    
    self.model.isSelected = !self.model.isSelected;
    
    NSString *titleStr = self.model.isSelected == YES ? @"暂停":@"下载";
    
    [btn setTitle:titleStr forState:UIControlStateNormal];
    
    //发送代理方法，让控制器去下载音频文件
    if([self.delegate respondsToSelector:@selector(downloadBtnClick:)]){
        
        [self.delegate downloadBtnClick:self];
        
    }
        
}

- (void)setModel:(BookListModel *)model{
    
    _model = model;
    
    UIButton *btn = (UIButton *)self.accessoryView;
    
    NSString *titleStr = (self.model.isSelected == YES) ? @"暂停" : @"下载";
    
    [btn setTitle:titleStr forState:UIControlStateNormal];
    
    _nameLabel.text = model.name;
    
    _progressView.progress = model.progress;
    
}

@end
