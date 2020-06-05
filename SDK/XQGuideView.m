//
//  XQGuideView.m
//  XQTestGuideDemo
//
//  Created by WXQ on 2020/4/13.
//  Copyright © 2020 WXQ. All rights reserved.
//

#import "XQGuideView.h"

#import <Masonry/Masonry.h>

@interface XQGuideView ()

/// <#note#>
@property (nonatomic, strong) UILabel *guideLab;

/// <#note#>
@property (nonatomic, strong) UIImageView *arrowImgView;

/// <#note#>
@property (nonatomic, strong) UIButton *skipBtn;

/// <#note#>
@property (nonatomic, strong) UIButton *nextBtn;

/// <#note#>
@property (nonatomic, strong) UIButton *previousBtn;

/// <#note#>
@property (nonatomic, copy) NSArray <XQGuideModel *> *modelArr;

/// <#note#>
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation XQGuideView

static XQGuideView *guideView_ = nil;

+ (void)showWithModelArr:(NSArray <XQGuideModel *> *)modelArr {
    if (guideView_) {
        return;
    }
    
    guideView_ = [XQGuideView new];
    guideView_.modelArr = modelArr;
    
    [[UIApplication sharedApplication].keyWindow addSubview:guideView_];
    [guideView_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    [guideView_ show];
    [guideView_ refreshMask];
}

+ (void)showWithRectArr:(NSArray <NSValue *> *)rectArr {
    
}

+ (void)hide {
    if (!guideView_) {
        return;
    }
    
    [guideView_ hide];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrowImgView = [UIImageView new];
        [self addSubview:self.arrowImgView];
        
        self.guideLab = [UILabel new];
        [self addSubview:self.guideLab];
        
        //        self.skipBtn = [UIButton new];
        //        [self addSubview:self.skipBtn];
        
        self.nextBtn = [UIButton new];
        [self addSubview:self.nextBtn];
        
        self.previousBtn = [UIButton new];
        [self addSubview:self.previousBtn];
        
        
        // 布局
        
        [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12);
            make.bottomMargin.equalTo(self).offset(-12);
        }];
        
        [self.previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.bottomMargin.equalTo(self).offset(-12);
        }];
        
        
        // 设置属性
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [self.nextBtn addTarget:self action:@selector(respondsToNext) forControlEvents:UIControlEventTouchUpInside];
        
        [self.previousBtn setTitle:@"上一步" forState:UIControlStateNormal];
        [self.previousBtn addTarget:self action:@selector(respondsToPrevious) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.guideLab.textColor = [UIColor whiteColor];
        self.guideLab.font = [UIFont boldSystemFontOfSize:18];
        self.guideLab.numberOfLines = 0;
        
        //        [self test_path];
        
    }
    return self;
}

- (void)show {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    self.alpha = 1;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        guideView_ = nil;
    }];
}

- (void)dealloc {
    NSLog(@"%@, %s", NSStringFromClass([self class]), __func__);
}


/// 设置遮罩
- (void)refreshMask {
    
    if (self.modelArr.count == 0) {
        
        self.layer.mask = nil;
        self.arrowImgView.hidden = YES;
        
        return;
    }
    
    self.arrowImgView.hidden = NO;
    
    if (self.selectIndex <= 0) {
        self.selectIndex = 0;
        self.previousBtn.hidden = YES;
    }else {
        self.previousBtn.hidden = NO;
    }
    
    
    if (self.selectIndex >= self.modelArr.count - 1) {
        
        self.selectIndex = self.modelArr.count - 1;
        //        self.nextBtn.hidden = YES;
        [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else {
        
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.nextBtn.hidden = NO;
        
    }
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    // 背景路径
    UIBezierPath *backPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];
    
    
    // 视图透明
    CGFloat spacing = 10;
    
    XQGuideModel *model = self.modelArr[self.selectIndex];
    
    CGRect rect = CGRectZero;
    if (model.view) {
        CGFloat vWidth = model.view.frame.size.width + spacing;
        CGFloat vHeight = model.view.frame.size.height + spacing;
        rect = [model.view convertRect:CGRectMake(-spacing/2, -spacing/2, vWidth, vHeight) toView:self];
    }else {
        rect = model.rect;
    }
    
    UIBezierPath *viewPath = [UIBezierPath bezierPathWithRect:rect];
    [backPath appendPath:[viewPath bezierPathByReversingPath]];
    
    maskLayer.path = backPath.CGPath;
    self.layer.mask = maskLayer;
    
    
    
    
    // 判断图片和文字的位置
    self.guideLab.text = model.guideContent;
    
    CGFloat centerX = rect.origin.x + rect.size.width/2;
    CGFloat centerY = rect.origin.y + rect.size.height/2;
    
#if DEBUG
    NSLog(@"wxq: %@", NSStringFromCGRect(rect));
#endif
    
    
    CGFloat xMultiplied = centerX/(width/2);
    
    // +30 是箭头不在中间的问题
    CGFloat leftX = -(width/2 - centerX) + 30;
    CGFloat rightX = (centerX - width/2) - 30;
    
    CGFloat arrowImgViewSize = 100;
    // 不判断左右了
    if (centerY > height/2) {
        // 下边
        
        if (centerX < width/2) {
            // 左
            self.arrowImgView.image = [XQGuideView imageNamed:@"guide_arrow_down"];
            [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-(height - rect.origin.y));
                make.centerX.mas_equalTo(0).offset(leftX);
                make.size.mas_equalTo(CGSizeMake(arrowImgViewSize, arrowImgViewSize));
            }];
        }else {
            // 右
            self.arrowImgView.image = [XQGuideView imageNamed:@"guide_arrow_down_right"];
            [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-(height - rect.origin.y));
                make.centerX.mas_equalTo(0).offset(rightX);
                make.size.mas_equalTo(CGSizeMake(arrowImgViewSize, arrowImgViewSize));
            }];
        }
        
        [self.guideLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.arrowImgView.mas_top);
            make.left.greaterThanOrEqualTo(self).offset(12);
            make.right.lessThanOrEqualTo(self).offset(-12);
            make.centerX.equalTo(self.arrowImgView).priorityMedium();
        }];
        
    }else {
        
        // 上边
        
        if (centerX < width/2) {
            // 左
            self.arrowImgView.image = [XQGuideView imageNamed:@"guide_arrow_up_left"];
            [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(rect.origin.y + rect.size.height);
                make.centerX.mas_equalTo(0).offset(leftX);
                make.size.mas_equalTo(CGSizeMake(arrowImgViewSize, arrowImgViewSize));
            }];
        }else {
            // 右
            self.arrowImgView.image = [XQGuideView imageNamed:@"guide_arrow_up"];
            [self.arrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(rect.origin.y + rect.size.height);
                make.centerX.mas_equalTo(0).offset(rightX);
                make.size.mas_equalTo(CGSizeMake(arrowImgViewSize, arrowImgViewSize));
            }];
        }
        
        [self.guideLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.arrowImgView.mas_bottom);
            make.left.greaterThanOrEqualTo(self).offset(12);
            make.right.lessThanOrEqualTo(self).offset(-12);
            make.centerX.equalTo(self.arrowImgView).priorityMedium();
        }];
    }
    
    }

- (void)test_path {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    // 背景路径
    UIBezierPath *backPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, height)];
    
    // 创建一个圆形path
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(80, 80) radius:50 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    [backPath appendPath:circlePath];
    
    UIBezierPath *viewPath = [UIBezierPath bezierPathWithRect:CGRectMake(30, 200, 80, 40)];
    [backPath appendPath:[viewPath bezierPathByReversingPath]];
    
    NSLog(@"%@, %@", circlePath, viewPath);
    
    maskLayer.path = backPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark - responds

- (void)respondsToNext {
    if (self.selectIndex >= self.modelArr.count - 1) {
        [self hide];
        return;
    }
    
    self.selectIndex += 1;
    [self refreshMask];
}

- (void)respondsToPrevious {
    
    self.selectIndex -= 1;
    [self refreshMask];
}


#pragma mark - class method

+ (NSArray <UIView *> *)getNavigationControllerButtonArrWithNC:(UINavigationController *)nc {
    
    NSMutableArray *muArr = [NSMutableArray array];
    
    for (UIView *v in nc.navigationBar.subviews) {
        
        // 内容
        if ([NSStringFromClass([v class]) isEqualToString:@"_UINavigationBarContentView"]) {
            
            for (UIView *v1 in v.subviews) {
                
                // 左右装按钮的视图
                if ([NSStringFromClass([v1 class]) isEqualToString:@"_UIButtonBarStackView"]) {
                    
                    for (UIView *v2 in v1.subviews) {
                        
                        // 按钮
                        if ([NSStringFromClass([v2 class]) isEqualToString:@"_UIButtonBarButton"]) {
                            [muArr addObject:v2];
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
    return muArr;
}

+ (nullable UIImage *)imageNamed:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[XQGuideView class]];
    if (@available(iOS 13.0, *)) {
        return [UIImage imageNamed:name inBundle:bundle withConfiguration:nil];
    } else {
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    }
}

@end
