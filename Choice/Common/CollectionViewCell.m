//
//  CollectionViewCell.m
//  Choice
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Header.h"
#import "TravelNoteModel.h"
#import "BGNews.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#define kSpace 5.0
@interface CollectionViewCell ()
@property (nonatomic, retain) UIImageView *imaView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@end



@implementation CollectionViewCell


- (void)dealloc
{
    self.imaView = nil;
    self.titleLabel = nil;
    self.titleLabel = nil;
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubView];
    }
    return self;
}


- (void)addSubView {
    self.imaView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpace, kSpace, kSW*0.25, kSW*0.2)];
    //_imaView.backgroundColor = [UIColor yellowColor];
    _imaView.layer.cornerRadius = 7;
    _imaView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imaView];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.25+2*kSpace, kSpace, kSW - kSW*0.25-4*kSpace, kSW*0.2*2/3)];
   // _titleLabel.backgroundColor = [UIColor cyanColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSW*0.25+2*kSpace, CGRectGetMaxY(self.titleLabel.frame), self.titleLabel.frame.size.width, kSW*0.2/3)];
   // _timeLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_timeLabel];
 
}


- (void)initWithTravelModel:(TravelNoteModel *)travelModel {
    self.titleLabel.text = travelModel.name;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:travelModel.cover_image_default]];
//    self.imaView.image = [UIImage imageWithData:data];
    [self.imaView sd_setImageWithURL:[NSURL URLWithString:travelModel.cover_image_default]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"收藏于: %@", travelModel.time];
    _timeLabel.font = [UIFont systemFontOfSize:10.0];
    _timeLabel.tintColor = [UIColor lightGrayColor];
}


- (void)initWithNewsModel:(BGNews *)newsModel {
    
    self.titleLabel.text = newsModel.post_title;
    NSData *data = [newsModel.smeta dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSURL *url = [NSURL URLWithString:dic[@"thumb"]];
    [self.imaView sd_setImageWithURL:url];
    
    self.timeLabel.text = [NSString stringWithFormat:@"收藏于: %@", newsModel.time];
    _timeLabel.font = [UIFont systemFontOfSize:10.0];
    _timeLabel.tintColor = [UIColor lightGrayColor];
   
}



- (void)initWithVideoModel:(Video *)videoModel {
    self.titleLabel.text = videoModel.title;
    NSURL *url = [NSURL URLWithString:videoModel.thumbnail];
    [self.imaView sd_setImageWithURL:url];
    self.timeLabel.text = [NSString stringWithFormat:@"收藏于: %@", videoModel.time];
    _timeLabel.font = [UIFont systemFontOfSize:10.0];
    _timeLabel.tintColor = [UIColor lightGrayColor];
    
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
