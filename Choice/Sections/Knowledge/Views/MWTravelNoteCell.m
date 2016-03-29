//
//  MWTravelNoteCell.m
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "MWTravelNoteCell.h"
#import "Header.h"
#import "TravelNoteModel.h"
#import "SecondNoteModel.h"
#import "UIImageView+WebCache.h"



@implementation MWTravelNoteCell

- (void)dealloc
{
    [_dateLabel release];
    [_userName release];
    [_userView release];
    [_place release];
    [_viewCount release];
    [_dayLable release];
    [_minView release];
    [_title release];
    [_backgroundImage release];
    self.travelNoteModel = nil;
    self.authorModel = nil;
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self addSubviews];
    }
    return self;
}

- (void)setTravelNoteModel:(TravelNoteModel *)travelNoteModel {
    if (_travelNoteModel != travelNoteModel) {
        [_travelNoteModel release];
        _travelNoteModel = [travelNoteModel retain];
    }
    if (travelNoteModel) {
        [self.backgroundImage sd_setImageWithURL:[NSURL URLWithString:travelNoteModel.cover_image_default] placeholderImage:[UIImage imageNamed:@"poi_bg_placeholder@2x"]];
        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        self.title.text = travelNoteModel.name;
        self.dayLable.text = [NSString stringWithFormat:@"%@天", travelNoteModel.day_count];
        self.viewCount.text = [NSString stringWithFormat:@"%@次浏览", travelNoteModel.view_count];
        self.place.text = travelNoteModel.popular_place_str;
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[travelNoteModel.first_day intValue]];
        
        self.dateLabel.text = [[NSString stringWithFormat:@"%@", dateTime] substringToIndex:10];
        
    }
  
}


// 给cell添加控件
- (void)addSubviews
{
    // 添加背景image
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kSW - 20, kSW*0.53)];
    self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImage.layer.cornerRadius = 7;
    self.backgroundImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backgroundImage];
    [self.backgroundImage release];
    
    // 添加title
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.08, kSW*0.053, kSW, 30)];
    self.title.textColor = [UIColor whiteColor];
    self.title.font = [UIFont boldSystemFontOfSize:17];
    [self.backgroundImage addSubview:self.title];
    [self.title release];
    
    // 添加minView
    self.minView = [[UIImageView alloc] initWithFrame:CGRectMake(kSW*0.053, kSW*0.143, 3, kSW*0.106)];
    self.minView.backgroundColor = [UIColor greenColor];
    self.minView.image = [UIImage imageNamed:@"bg_navigationBar@2x"];
    [self.backgroundImage addSubview:self.minView];
    [self.minView release];
    
    // 添加时间label
    self.dayLable = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.29, kSW*0.12, 40, 30)];
    self.dayLable.font = [UIFont boldSystemFontOfSize:12];
    self.dayLable.textColor = [UIColor whiteColor];
    [self.backgroundImage addSubview:self.dayLable];
    [self.dayLable release];
    
    // 添加浏览次数label
    self.viewCount = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.40, kSW*0.12, kSW, 30)];
    self.viewCount.font = [UIFont boldSystemFontOfSize:12];
    self.viewCount.textColor = [UIColor whiteColor];
    [self.backgroundImage addSubview:self.viewCount];
    [self.viewCount release];
    
    // 添加地点label
    self.place = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.08, kSW*0.186, kSW, 30)];
    self.place.font = [UIFont boldSystemFontOfSize:12];
    self.place.textColor = [UIColor whiteColor];
    [self.backgroundImage addSubview:self.place];
    [self.place release];
    
    // 添加作者头像
    self.userView = [[UIImageView alloc] initWithFrame:CGRectMake(kSW*0.08, kSW*0.4, 30, 30)];
    self.userView.backgroundColor = [UIColor whiteColor];
    [self.userView.layer setCornerRadius:CGRectGetHeight([self.userView bounds]) / 2];
    self.userView.layer.masksToBounds = YES;
    [self.backgroundImage addSubview:self.userView];
    [self.userView release];
    
    // 添加作者姓名
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.186, kSW*0.4, kSW, 30)];
    self.userName.font = [UIFont boldSystemFontOfSize:12];
    self.userName.textColor = [UIColor whiteColor];
    [self.backgroundImage addSubview:self.userName];
    [self.userName release];
    
    // 添加日期label
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.08,  kSW*0.12, 100, 30)];
    self.dateLabel.font = [UIFont boldSystemFontOfSize:12];
    self.dateLabel.textColor = [UIColor whiteColor];
    [self.backgroundImage addSubview:self.dateLabel];
    [self.dateLabel release];
}



// 懒加载
/*
- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kSW-20, kSW*0.53)];
        self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImage.layer.cornerRadius = 7;
        self.backgroundImage.layer.masksToBounds = YES;
        [self.backgroundImage release];
        
    }
    return [[_backgroundImage retain] autorelease];
}

- (UILabel *)title {
    if (!_title) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.08, kSW*0.053, kSW, 30)];
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont boldSystemFontOfSize:17];
        [self.title release];
    }
    return [[_title retain] autorelease];
}

- (UIImageView *)minView {
    if (!_minView) {
        self.minView = [[UIImageView alloc] initWithFrame:CGRectMake(kSW*0.053, kSW*0.143, 3, kSW*0.106)];
        self.minView.backgroundColor = [UIColor greenColor];
        self.minView.image = [UIImage imageNamed:@"bg_navigationBar@2x"];
      
        [self.minView release];
    }
    return [[_minView retain] autorelease];
}

- (UILabel *)dayLable {
    if (!_dateLabel) {
        self.dayLable = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.29, kSW*0.12, 40, 30)];
        self.dayLable.font = [UIFont boldSystemFontOfSize:12];
        self.dayLable.textColor = [UIColor whiteColor];
      
        [self.dayLable release];
    }
    return [[_dateLabel retain] autorelease];
}
// 浏览次数label
- (UILabel *)viewCount {
    if (!_viewCount) {
        self.viewCount = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.4, kSW*0.12, kSW, 30)];
        self.viewCount.font = [UIFont boldSystemFontOfSize:12];
        self.viewCount.textColor = [UIColor whiteColor];
    }
    return [[_viewCount retain] autorelease];
}

// 地点label
- (UILabel *)place {
    if (!_place) {
        self.place = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.08, kSW*0.186, kSW, 30)];
        self.place.font = [UIFont boldSystemFontOfSize:12];
        self.place.textColor = [UIColor whiteColor];
       
    }
    return [[_place retain] autorelease];
}

 // 作者头像
- (UIImageView *)userView {
    if (!_userView) {
        self.userView = [[UIImageView alloc] initWithFrame:CGRectMake(kSW*0.08, kSW*0.4, 30, 30)];
        self.userView.backgroundColor = [UIColor whiteColor];
        [self.userView.layer setCornerRadius:CGRectGetHeight([self.userView bounds]) / 2];
        self.userView.layer.masksToBounds = YES;
        
        [self.userView release];
    }
    return [[_userView retain] autorelease];
}

- (UILabel *)userName {
    if (!_userName) {
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.186, kSW*0.4, kSW, 30)];
        self.userName.font = [UIFont boldSystemFontOfSize:12];
        self.userName.textColor = [UIColor whiteColor];
       
        [self.userName release];
    }
    return [[_userName retain] autorelease];
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.08,  kSW*0.12, 100, 30)];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:12];
        self.dateLabel.textColor = [UIColor whiteColor];
       
        [self.dateLabel release];
    }
    return [[_dateLabel retain] autorelease];
}
*/



















- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
