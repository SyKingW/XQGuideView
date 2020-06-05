//
//  XQGuideViewModel.h
//  XQTestGuideDemo
//
//  Created by WXQ on 2020/4/13.
//  Copyright © 2020 WXQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQGuideModel : NSObject

/// 要显示的视图
@property (nonatomic, strong) UIView *view;

/// 要空白的位置
/// 如 view 字段已有数据, 则以 view 字段为优先
@property (nonatomic) CGRect rect;

/// 提示文字
@property (nonatomic, copy) NSString *guideContent;

/// 对着显示视图的图片
//@property (nonatomic, copy) UIImage *arrowImg;

@end

NS_ASSUME_NONNULL_END
