//
//  TitleBtnAndContrChangeController.m
//  TitleAndViewChange
//
//  Created by GHZ on 2017/7/28.
//  Copyright © 2017年 hongzhong. All rights reserved.
//

#import "TitleBtnAndContrChangeController.h"
#import "UIView+Layout.h"

#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
//十六进制颜色值
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString * const ID = @"cell";
@interface TitleBtnAndContrChangeController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, weak) UIScrollView *topView;
@property(nonatomic, weak) UIButton *selectButton;
@property(nonatomic, weak) UIView *underLineView;
@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *buttonArr;
@property(nonatomic, assign) BOOL isAddTitleBtn;

@end

@implementation TitleBtnAndContrChangeController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 设置所有标题按钮
    if (_isAddTitleBtn == NO) {
        
        [self setupAllTitleBtn];
        _isAddTitleBtn = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加顶部视图
    [self setupTopView];
    // 添加CollectionView
    [self setupCollectionView];
}

#pragma mark - 添加头部视图
- (void)setupTopView {
    
    // view
    UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    _topView = topView;
    [self.view addSubview:topView];
}

- (void)setupAllTitleBtn {
    
    // btn
    NSInteger count = (NSInteger)self.childViewControllers.count;
    CGFloat btnW = kDeviceWidth/(CGFloat)count;
    CGFloat btnH = 40;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    _buttonArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorFromRGB(0xFF9803) forState:UIControlStateSelected];
        [btn setTitleColor:UIColorFromRGB(0xFF9803) forState:UIControlStateSelected | UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_topView addSubview:btn];
        [_buttonArr addObject:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            
            [self btnClick:btn];
            // 添加下划线
            UIView *underLineView = [[UIView alloc] init];
            underLineView.backgroundColor =UIColorFromRGB(0xFF9600);
            underLineView.tz_width = 60;
            underLineView.tz_height = 2;
            underLineView.tz_bottom = _topView.tz_bottom;
            underLineView.tz_centerX = btn.tz_centerX;
            _underLineView = underLineView;
            [_topView addSubview:underLineView];
        }
    }
}

- (void)setupCollectionView {
    
    // 布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kDeviceWidth, KDeviceHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    // UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, kDeviceWidth, KDeviceHeight) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor lightGrayColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    _collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // 注册cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
}

// 点击按钮
- (void)btnClick:(UIButton *)button
{
    NSInteger i = button.tag;
    // 选中按钮
    [self btnSelected:button];
    // 改变collectionView的偏移
    _collectionView.contentOffset = CGPointMake(i * kDeviceWidth, 0);
}

// 选中按钮
- (void)btnSelected: (UIButton *)button {
    
    // 选中按钮
    _selectButton.selected = NO;
    button.selected = YES;
    _selectButton = button;
    // 改变下划线的位置
    [UIView animateWithDuration:0.2 animations:^{
        _underLineView.tz_centerX = button.tz_centerX;
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    // 移除其它子控制器view
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加对应的子控制器view 到 对应cell
    UIViewController *vc = self.childViewControllers[indexPath.row];
    // 默认控制器frame有y值,每次添加的时候,必须重新去设置子控制器的frame
    vc.view.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    // 添加到contentView
    [cell.contentView addSubview:vc.view];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 获取页码
    NSInteger page = scrollView.contentOffset.x / kDeviceWidth;
    // 获取按钮
    UIButton *btn = _buttonArr[page];
    // 选中按钮
    [self btnSelected: btn];
}

@end
