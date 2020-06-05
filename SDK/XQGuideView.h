//
//  XQGuideView.h
//  XQTestGuideDemo
//
//  Created by WXQ on 2020/4/13.
//  Copyright © 2020 WXQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQGuideModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XQGuideView : UIView

/// 显示引导图
/// @param modelArr 引导图的model
+ (void)showWithModelArr:(NSArray <XQGuideModel *> *)modelArr;

/// 隐藏视图
+ (void)hide;

/// 获取 UINavigationController 上面的按钮
/// 注意, 要在 viewDidAppear 里面调用, 才会有按钮显示出来
/// 返回的数组 view, 是从左到右
+ (NSArray <UIView *> *)getNavigationControllerButtonArrWithNC:(UINavigationController *)nc;

@end

NS_ASSUME_NONNULL_END
