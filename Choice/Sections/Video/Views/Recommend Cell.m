//
//  Recommend Cell.m
//  Choice
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "Recommend Cell.h"
#import "Play.h"
#import "AAACell.h"
#import "VideoPlayController.h"
@interface Recommend_Cell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation Recommend_Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dataArray = [NSMutableArray array];
        [self addAllViews];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (_dataArray != dataArray) {
        [_dataArray release];
        _dataArray = [dataArray retain];
    }
//    NSLog(@"-----------%@", dataArray);
    [self.collectionView reloadData];
}

- (void)addAllViews

{
    self.backgroundColor = [UIColor colorWithRed:233/255.0 green:225/255.0 blue:178/255.0 alpha:0.2];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(140, 100);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120) collectionViewLayout:flowLayout];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self.contentView addSubview:_collectionView];
    
    
    
    [self.collectionView registerClass:[AAACell class] forCellWithReuseIdentifier:@"cell"];
    
}



#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AAACell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
    
    Play *play = self.dataArray[indexPath.row];
    
//    NSLog(@"%@", play.title);
    
    [cell configureTagLabelWithPlay:play];
    
    return cell;
}





//
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.dataArray.count == 10) {
        
        
        Play *play = self.dataArray[indexPath.row];
        if (self.owner) {
            
            
            self.owner.aID = play.rsId;
            self.owner.moduleID = play.moduleID;
            
            [self.owner GETData];
        }
        
    }
    
    
    

    
}









- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
