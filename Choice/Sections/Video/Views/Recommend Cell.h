//
//  Recommend Cell.h
//  Choice
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoPlayController;  //sh

@interface Recommend_Cell : UITableViewCell


@property (nonatomic, assign) VideoPlayController *owner; 



@property (nonatomic, retain) UICollectionView *collectionView;

@property (nonatomic, retain) NSMutableArray *dataArray;






@end
