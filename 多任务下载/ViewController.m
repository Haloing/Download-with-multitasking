//
//  ViewController.m
//  多任务下载
//
//  Created by Mac OS X on 2017/5/12.
//  Copyright © 2017年 Haooing. All rights reserved.
//

#import "ViewController.h"
#import "BookListModel.h"
#import "BookListTableViewCell.h"
#import "DownloadManager.h"

@interface ViewController ()<BookListtableViewDelegate>

@property (nonatomic, strong) NSArray <BookListModel *>*listArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBookList];
    
}

#pragma mark
#pragma mark - cell的代理方法
- (void)downloadBtnClick:(BookListTableViewCell *)cell{
    
    //拿到了当前点击的cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //取出选中行对应cell的模型属性
    BookListModel *model = self.listArray[indexPath.row];
    
    //下载之前先判断文件是否正在下载
    
    BOOL isDoenload = [[DownloadManager sharedManager] checkIsDownloadWithUrlStr:model.path];
    
    if (isDoenload) {
        
        //如果文件正在下载，那么就暂停
        [[DownloadManager sharedManager] pauseDoenloadWithUrlStr:model.path];
        
        
    }else{
        
        //如果文件没有正在下载，就直接下载
        [[DownloadManager sharedManager] downloadWithUrlString:model.path progress:^(float progress){
            
            BookListTableViewCell *updataCell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            model.progress = progress;
            
            updataCell.model = model;
            
            
        } finishWithFilePath:^(NSString *filePath) {
            
            NSLog(@"下载完成路径:%@",filePath);
            
        }];
        
        
    }
    
    
    
}


#pragma mark
#pragma mark - 实现数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hh" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.model = self.listArray[indexPath.row];
    
    return cell;
    
}

- (void)loadBookList{
    
    NSURL *url = [NSURL URLWithString:@"http://42.62.15.101/yyting/bookclient/ClientGetBookResource.action?bookId=30776&imei=OEVGRDQ1ODktRUREMi00OTU4LUE3MTctOUFGMjE4Q0JDMTUy&nwt=1&pageNum=1&pageSize=50&q=114&sc=acca7b0f8bcc9603c25a52f572f3d863&sortType=0&token=KMSKLNNITOFYtR4iQHIE2cE95w48yMvrQb63ToXOFc8%2A"];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil && data != nil) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSArray *listArr = result[@"list"];
            
            NSMutableArray *bookListArrayM = [NSMutableArray arrayWithCapacity:(NSInteger)result.allKeys];
            
            [listArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [bookListArrayM addObject:[BookListModel initWithDict:obj]];
                
            }];
            
            //给数据源数组赋值
            _listArray = bookListArrayM.copy;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.tableView reloadData];
                
            }];
            
        }else{
            
            NSLog(@"打印错误信息%@",error);
            
        }
        
        
    }] resume];
}
@end
