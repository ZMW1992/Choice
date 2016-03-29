//
//  DescriptionCell.m
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "DescriptionCell.h"
//#import "Video.h"
#import "Play.h"
#import "Header.h"
@interface DescriptionCell ()

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *playLabel;
@property (nonatomic, retain) UILabel *playCountLabel;
@property (nonatomic, retain) UILabel *commentLabel;
@property (nonatomic, retain) UILabel *commentCountLabel;
@property (nonatomic, retain) UILabel *descriptionLabel;



@end


@implementation DescriptionCell


- (void)dealloc {
    self.titleLabel = nil;
    self.playLabel = nil;
    self.playCountLabel = nil;
    self.commentLabel = nil;
    self.commentCountLabel = nil;
    self.descriptionLabel = nil;
    
    [super dealloc];
}



- (void)assignForCellSubviews:(Play *)play {
    
    self.backgroundColor = [UIColor colorWithRed:233/255.0 green:225/255.0 blue:178/255.0 alpha:0.2];
    
    
    self.titleLabel.text = play.title;
    
    CGRect TR = self.titleLabel.frame;
    TR.size.height = [play.title boundingRectWithSize:CGSizeMake(kSW-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size.height;
    self.titleLabel.frame = TR;

    
    self.playLabel.text = @"播放";
    self.playLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame), 20, 20);
    
    
    //self.playCountLabel.text = [NSString stringWithFormat:@"%ld", play.viewCount];
    
    self.playCountLabel.text = [[NSNumber numberWithInteger:play.viewCount] stringValue];
        self.playCountLabel.frame = CGRectMake(30, CGRectGetMaxY(self.titleLabel.frame), 30, 20);
    
    self.commentLabel.text = @"评论";
        self.commentLabel.frame = CGRectMake(70, CGRectGetMaxY(self.titleLabel.frame), 20, 20);
    
    //self.commentCountLabel.text = [NSString stringWithFormat:@"%ld", play.commentcount];
    self.commentCountLabel.text = [[NSNumber numberWithInteger:play.commentcount] stringValue];
        self.commentCountLabel.frame = CGRectMake(90, CGRectGetMaxY(self.titleLabel.frame), 30, 20);
    
    self.descriptionLabel.text = play.descr;
    
    CGRect r = CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame)+20, kSW-20, 0);
    r.size.height = [play.descr boundingRectWithSize:CGSizeMake(kSW-20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]} context:nil].size.height;
    self.descriptionLabel.frame = r;
    
}


// 重写自定义cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.playLabel];
        [self.contentView addSubview:self.playCountLabel];
        [self.contentView addSubview:self.commentLabel];
        [self.contentView addSubview:self.commentCountLabel];
        [self.contentView addSubview:self.descriptionLabel];
        
//        self.backgroundColor = [UIColor orangeColor];
        
    }
    
    return self;
    
}






// 懒加载
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(5, 10, kSW-20, 0)] autorelease];
//        _titleLabel.backgroundColor = [UIColor yellowColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.numberOfLines = 0;
    }
    
    return [[_titleLabel retain] autorelease];
}


- (UILabel *)playLabel {
    
    if (!_playLabel) {
        self.playLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame), 10, 20)] autorelease];
//        _playLabel.backgroundColor = [UIColor redColor];
        _playLabel.font = [UIFont systemFontOfSize:8.0];
    }
    
    return [[_playLabel retain] autorelease];
}


- (UILabel *)playCountLabel {
    
    if (!_playCountLabel) {
        self.playCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60, CGRectGetMaxY(self.titleLabel.frame), 30, 20)] autorelease];
//        _playCountLabel.backgroundColor = [UIColor cyanColor];
        _playCountLabel.font = [UIFont systemFontOfSize:8.0];
    }
    
    return [[_playCountLabel retain] autorelease];
}


- (UILabel *)commentLabel {
    if (!_commentLabel) {
        self.commentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(self.titleLabel.frame), 10, 20)] autorelease];
//        _commentLabel.backgroundColor = [UIColor grayColor];
    
        _commentLabel.font = [UIFont systemFontOfSize:8.0];
    }
    
    return [[_commentLabel retain] autorelease];
}


- (UILabel *)commentCountLabel {
    
    if (!_commentCountLabel) {
        self.commentCountLabel = [[[UILabel alloc] init] autorelease];
//        _commentCountLabel.backgroundColor = [UIColor blueColor];
        _commentCountLabel.font = [UIFont systemFontOfSize:8.0];
    }
    
    return [[_commentCountLabel retain] autorelease];
}


- (UILabel *)descriptionLabel {
    
    if (!_descriptionLabel) {
        self.descriptionLabel = [[[UILabel alloc] init] autorelease];
//        _descriptionLabel.backgroundColor = [UIColor greenColor];
        _descriptionLabel.font = [UIFont systemFontOfSize:10.0];
        _descriptionLabel.numberOfLines = 0;
    }
    
    return [[_descriptionLabel retain] autorelease];
}










- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
