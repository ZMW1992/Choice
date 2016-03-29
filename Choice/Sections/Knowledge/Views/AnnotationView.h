//
//  AnnotationView.h
//  MapTest4
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 LiYaJun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface AnnotationView : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
#pragma mark 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic,retain) UIImage *image;

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
