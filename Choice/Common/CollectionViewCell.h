//
//  CollectionViewCell.h
//  Choice
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelNoteModel;
@class BGNews;
@class Video;
@interface CollectionViewCell : UITableViewCell

- (void)initWithTravelModel:(TravelNoteModel *)travelModel;
- (void)initWithNewsModel:(BGNews *)newsModel;
- (void)initWithVideoModel:(Video *)videoModel;

@end
