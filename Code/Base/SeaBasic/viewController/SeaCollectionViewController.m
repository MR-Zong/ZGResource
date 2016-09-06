//
//  SeaCollectionViewController.m

//

#import "SeaCollectionViewController.h"
#import "SeaBasic.h"

@interface SeaCollectionViewController ()


@end

@implementation SeaCollectionViewController

/**构造方法
 *@param layout 布局方式，传nil会使用默认的布局
 *@return 一个初始化的 SeaCollectionViewController 对象
 */
- (id)initWithFlowLayout:(UICollectionViewFlowLayout*) layout
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.curPage = 1;
        if(layout == nil)
        {
            _layout = [[UICollectionViewFlowLayout alloc] init];
            _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            _layout.minimumInteritemSpacing = 5.0;
            _layout.minimumLineSpacing = 5.0;
        }
        else
        {
            self.layout = layout;
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithFlowLayout:nil];
}


#pragma mark- public method

/**初始化视图 子类必须调用该方法
 */
- (void)initialization
{
    CGRect frame = CGRectMake(0, 0, _width_, self.contentHeight);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.backgroundView = nil;
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.scrollView = _collectionView;
    [self.view addSubview:_collectionView];
}


#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSLog(@"UICollectionViewCell 创建失败");
    }
    
    return cell;
}


@end
