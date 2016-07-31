//
//  JSCarouselViewController.m
//  JSCarouselDemo
//
//  Created by 乔同新 on 16/6/13.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "JSCarouselViewController.h"
#import "JSCarouselLayout.h"
#import "JSCarouselViewModel.h"
#import "JSCarouselUIService.h"

#import "ZGLineLayout.h"
#import "ZGTanTanLayout.h"

@interface JSCarouselViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView    *carouselCollectionView;

@property (nonatomic, strong) JSCarouselViewModel *viewModel;

@property (nonatomic, strong) JSCarouselUIService *service;

@property (nonatomic, retain) UILabel *indexLabel;

@property (nonatomic, assign) NSInteger allCount;


/** testTanTan */
@property (nonatomic, strong) UICollectionView *tanCollectionView;

@end

@implementation JSCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testTanTan];
}

- (void)testTanTan
{
    self.view.backgroundColor = [UIColor whiteColor];
    ZGTanTanLayout *tanLayout = [[ZGTanTanLayout alloc] init];
    self.tanCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:tanLayout];
    self.tanCollectionView.backgroundColor = [UIColor redColor];
    self.tanCollectionView.dataSource = self;
    self.tanCollectionView.delegate = self;
    [self.tanCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"tanCollectionViewCell"];
    [self.view addSubview:self.tanCollectionView];
}

- (void)jscarouse
{
    self.title = @"JSCarousel";
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.automaticallyAdjustsScrollViewInsets = NO;
    /*  */
    [self.view addSubview:self.carouselCollectionView];
    /*  */
    [self.viewModel getData];
    [self.carouselCollectionView reloadData];
    /*  */
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.carouselCollectionView.frame), self.view.frame.size.width, 20)];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.font = [UIFont systemFontOfSize:13];
    _allCount = [self.viewModel.data count];
    _indexLabel.text = [NSString stringWithFormat:@"浏览记录(1/%li)",_allCount];
    [self.view addSubview:_indexLabel];

}

#pragma mark - lazy load

- (JSCarouselViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[JSCarouselViewModel alloc] init];
    }
    return _viewModel;
}

- (JSCarouselUIService *)service{
    
    if (!_service) {
        _service = [[JSCarouselUIService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}

//- (UICollectionView *)carouselCollectionView{
//    
//    if (!_carouselCollectionView) {
//        
//        JSCarouselLayout *layout                = [[JSCarouselLayout alloc] init];
//        __weak typeof (self)weakSelf            = self;
//        layout.carouselSlideIndexBlock          = ^(NSInteger index){
//            weakSelf.indexLabel.text = [NSString stringWithFormat:@"浏览足迹(%li/%li)",index+1,_allCount];
//        };
//        layout.itemSize                         = CGSizeMake(190, 262);
//        _carouselCollectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 270)
//                                                     collectionViewLayout:layout];
//        _carouselCollectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//        _carouselCollectionView.dataSource      = self.service;
//        _carouselCollectionView.delegate        = self.service;
//        _carouselCollectionView.showsHorizontalScrollIndicator = NO;
//        _carouselCollectionView.showsVerticalScrollIndicator = NO;
//        [_carouselCollectionView registerNib:[UINib nibWithNibName:@"JSCarouselGoodsCell" bundle:nil]
//                  forCellWithReuseIdentifier:@"JSCarouselGoodsCell"];
//    }
//    return _carouselCollectionView;
//}

// ZGLineLayout
- (UICollectionView *)carouselCollectionView
{
    if (!_carouselCollectionView) {
        ZGLineLayout *lineLayout = [[ZGLineLayout alloc] init];
        _carouselCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 270) collectionViewLayout:lineLayout];
        _carouselCollectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _carouselCollectionView.dataSource      = self.service;
        _carouselCollectionView.delegate        = self.service;
        _carouselCollectionView.showsHorizontalScrollIndicator = NO;
        _carouselCollectionView.showsVerticalScrollIndicator = NO;
        [_carouselCollectionView registerNib:[UINib nibWithNibName:@"JSCarouselGoodsCell" bundle:nil]
                  forCellWithReuseIdentifier:@"JSCarouselGoodsCell"];
    }
    return _carouselCollectionView;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tanCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - UICollectionViewDelegate


@end
