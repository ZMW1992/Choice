//
//  VideoCell.m
//  Choice
//
//  Created by lanouhn on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "VideoCell.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "Header.h"
@interface VideoCell ()
@property (nonatomic, retain) UIImageView *coverImage;        // 缩略图
@property (nonatomic, retain) UILabel *titleLabel;   // 视频标题
@property (nonatomic, retain) UILabel *viewCountLabel;    // 浏览次数
@property (nonatomic, retain) UILabel *commentCountLabel; // 评论数
@property (nonatomic, retain) UILabel *timeLabel; // 视频时长


@end


@implementation VideoCell


- (void)dealloc {
    self.coverImage = nil;
    self.titleLabel = nil;
    self.viewCountLabel = nil;
    self.commentCountLabel = nil;
    self.timeLabel = nil;

    [super dealloc];
}


- (void)assignForCellSubviews:(Video *)video{

    self.titleLabel.text = video.title;
    self.viewCountLabel.text = [NSString stringWithFormat:@"浏览量:%ld", video.viewCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"评论数量:%ld", video.commentcount];
    NSString *str = [self TimeformatFromSeconds:video.duration];
    self.timeLabel.text = [NSString stringWithFormat:@"时长:%@", str];
    
    
    
    // 图片异步加载
    NSURL *url = [NSURL URLWithString:video.thumbnail];
    [self.coverImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
  
}


-(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}


// 重写自定义cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.coverImage];
        [self.coverImage addSubview:self.titleLabel];
        [self.coverImage addSubview:self.viewCountLabel];
        [self.coverImage addSubview:self.commentCountLabel];
        [self.coverImage addSubview:self.timeLabel];
        
        
        
    }
    
    return  self;
}




// 懒加载

- (UIImageView *)coverImage {
    
    if (!_coverImage) {
        self.coverImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kSW-20, 0.43*kSW)] autorelease];
        _coverImage.layer.cornerRadius = 7;
        _coverImage.layer.masksToBounds = YES;
        _coverImage.backgroundColor = [UIColor redColor];
        _coverImage.image = [UIImage imageNamed:@"zhanwei"];
        
        
    }
    return [[_coverImage retain]autorelease];
}



- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 0.43*kSW-15, kSW-20, 10)]autorelease];
        //_titleLabel.backgroundColor = [UIColor cyanColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
        _titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
        
    }
    return [[_titleLabel retain]autorelease];
}


- (UILabel *)viewCountLabel {
    
    if (!_viewCountLabel) {
        self.viewCountLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 0.34*kSW, 70, 10)]autorelease];
        //_viewCountLabel.backgroundColor = [UIColor blueColor];
        _viewCountLabel.textColor = [UIColor whiteColor];
        _viewCountLabel.font = [UIFont systemFontOfSize:10.0];
    }
    
    return [[_viewCountLabel retain]autorelease];
}


- (UILabel *)commentCountLabel {
    
    if (!_commentCountLabel) {
        self.commentCountLabel = [[[UILabel alloc]initWithFrame:CGRectMake(80, 0.34*kSW, 50, 10)]autorelease];
        //_commentCountLabel.backgroundColor = [UIColor yellowColor];
        _commentCountLabel.textColor = [UIColor whiteColor];
        _commentCountLabel.font = [UIFont systemFontOfSize:10.0];
    }
    
    return [[_commentCountLabel retain]autorelease];
}


- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        self.timeLabel = [[[UILabel alloc]initWithFrame:CGRectMake(140, 0.34*kSW, 70, 10)]autorelease];
        
        //_timeLabel.backgroundColor = [UIColor greenColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10.0];
    }
    
    return [[_timeLabel retain]autorelease];
}








- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
