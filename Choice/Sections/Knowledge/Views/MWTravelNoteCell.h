//
//  MWTravelNoteCell.h
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TravelNoteModel;
@class SecondNoteModel;

@interface MWTravelNoteCell : UITableViewCell
@property (nonatomic , retain) UIImageView *backgroundImage;
@property (nonatomic , retain) UILabel *title;
@property (nonatomic , retain) UIImageView *minView;
@property (nonatomic , retain) UILabel *dayLable;
@property (nonatomic , retain) UILabel *viewCount;
@property (nonatomic , retain) UILabel *place;
@property (nonatomic , retain) UIImageView *userView;
@property (nonatomic , retain) UILabel *userName;
@property (nonatomic , retain) UILabel *dateLabel;

@property (nonatomic, retain) TravelNoteModel *travelNoteModel;
@property (nonatomic, retain) SecondNoteModel *authorModel;

@end
