//
//  MWDetailTravelCellTableViewCell.h
//  Choice
//
//  Created by lanouhn on 16/1/10.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RowDetailModel;
@interface MWDetailTravelCellTableViewCell : UITableViewCell
@property (nonatomic , retain) UIImageView *photoImage;


@property (nonatomic, retain) RowDetailModel *detailModel;
//@property (nonatomic , assign) CGFloat cellHight;
// 返回cell高度
+ (CGFloat)getCellHeightWithModel:(RowDetailModel *)detailModel;

@end
