//
//  MWDetailTravelCellTableViewCell.m
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "MWDetailTravelCellTableViewCell.h"
#import "Header.h"
#import "RowDetailModel.h"
#import "UIImageView+WebCache.h"
#import "RowDetailModel.h"
#define Kspace 10
@interface MWDetailTravelCellTableViewCell ()

@property (nonatomic , retain) UILabel *textLab;
@property (nonatomic , retain) UILabel *local_timeLable;
@property (nonatomic , retain) UIImageView *clockView;

@property (nonatomic , retain) UILabel *dateLabel;



// 图片的展示高度（按比例缩小后）
@property (nonatomic , assign) NSInteger photo_H;
@end

@implementation MWDetailTravelCellTableViewCell

- (void)dealloc
{
    [_dateLabel release];
    [_clockView release];
    [_textLab release];
    [_local_timeLable release];
    [_photoImage release];
    self.detailModel = nil;
    [super dealloc];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    
    return self;
}


#pragma mark - 添加控件
- (void)addSubviews
{
    self.photo_H = 0;
    self.photoImage = [UIImageView new];
    self.photoImage.frame = CGRectMake(Kspace, 4 * Kspace, kSW - 2 * Kspace, self.photo_H);
    self.photoImage.layer.cornerRadius = 7;
    self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.photoImage];
    [self.photoImage release];
    
    self.textLab = [UILabel new];
    self.textLab.numberOfLines = 0;
    self.textLab.font = [UIFont systemFontOfSize:12];
    self.textLab.frame = CGRectMake(Kspace, Kspace + self.photo_H + self.photoImage.frame.origin.y, kSW - 2 * Kspace, 0);
    [self.contentView addSubview:self.textLab];
    [self.textLab release];
    
    self.dateLabel = [UILabel new];
    self.dateLabel.frame = CGRectMake(Kspace, Kspace, kSW, 20);
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel release];
    
    self.local_timeLable = [UILabel new];
    self.local_timeLable.numberOfLines = 0;
    self.local_timeLable.font = [UIFont systemFontOfSize:10];
    self.local_timeLable.frame = CGRectMake(2 * Kspace, 0, kSW - 2 * Kspace, 30);
    self.local_timeLable.textColor = [UIColor grayColor];
    [self.dateLabel addSubview:self.local_timeLable];
    [self.local_timeLable release];
    
    self.clockView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 8.5, 13, 13)];
    self.clockView.image = [UIImage imageNamed:@"clock_gray"];
    [self.dateLabel addSubview:self.clockView];
    [self.clockView release];
    
}


- (void)setDetailModel:(RowDetailModel *)detailModel {
    if (_detailModel != detailModel) {
        [_detailModel release];
        _detailModel = [detailModel retain];
    }
    // 判断是否为空
    if (detailModel) {
        self.textLab.text = detailModel.text;
        self.local_timeLable.text = detailModel.local_time;
 
        [self.photoImage sd_setImageWithURL:[NSURL URLWithString:detailModel.photo]  placeholderImage:[UIImage imageNamed:@"poi_bg_placeholder"]];
        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        
        // 动态改变frame参数
        CGRect photoFrame = self.photoImage.frame;
        photoFrame.size.height = [self calculatePhotoHWith:detailModel];
        self.photoImage.frame = photoFrame;
        
        
        CGRect textFrame = self.textLab.frame;
        textFrame.size.height = [[self class] calculateTextHeightWith:detailModel.text];
        if ([detailModel.photo isEqualToString:@""]) {
            textFrame.origin.y = 4*Kspace;
        }else{
            textFrame.origin.y = CGRectGetMaxY(self.photoImage.frame) + Kspace;
        }
        self.textLab.frame = textFrame;
        //self.textLab.backgroundColor = [UIColor cyanColor];
    }
    
    // 实验新方法
    detailModel.cellHeight = CGRectGetMaxY(self.textLab.frame) + Kspace;
  
}

// 计算图片高度(按比例)
- (NSInteger)calculatePhotoHWith:(RowDetailModel *)model {
    if ([model.photo isEqualToString:@""]) {
        self.photo_H = 0;
        
    }else{
        NSInteger w = [[model.photo_info objectForKey:@"w"] integerValue];
        NSInteger h = [[model.photo_info objectForKey:@"h"] integerValue];
        if (w > 0) {
            self.photo_H = (NSInteger)(h * (kSW - 2 * Kspace)/w);
        }
    
    }
    return _photo_H;
}



////string	__NSCFString *	@"这一次好像重新爱上了自拍(੭ु˶˭̵̴⃙⃚⃘᷄ᗢ˭̴̵⃙⃚⃘᷅˶)੭ु⁾"	0x00007ff8638df9f0

// 计算文字高度
+ (CGFloat)calculateTextHeightWith:(NSString *)text {
//     NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+(੭ु˶˭̵̴⃙⃚⃘᷄ᗢ˭̴̵⃙⃚⃘᷅˶)੭ु⁾"];
//     NSString *string = [[text componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];

    NSString *string = [NSString stringWithFormat:@"%@", text];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGFloat height = [string boundingRectWithSize:CGSizeMake(kSW - 2 * Kspace, MAXFLOAT) options:options attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.height;
    
 
    return (NSInteger)height+2;
}

// 返回cell高度
+ (CGFloat)getCellHeightWithModel:(RowDetailModel *)detailModel {
    float h = [[self class] calculateTextHeightWith:detailModel.text];
    MWDetailTravelCellTableViewCell *cell = [[MWDetailTravelCellTableViewCell new] autorelease];
    float h2 = [cell calculatePhotoHWith:detailModel];
    if ([detailModel.photo isEqualToString:@""]) {
        return h + 5*Kspace;
    }
   
    return h + 6*Kspace + h2;
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}





































- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
