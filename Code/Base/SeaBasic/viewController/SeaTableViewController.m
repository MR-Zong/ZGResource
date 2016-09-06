//
//  SeaTableViewController.m

//

#import "SeaTableViewController.h"
#import "SeaBasic.h"

@interface SeaTableViewController ()


@end

@implementation SeaTableViewController

/**构造方法
 *@param style 列表风格
 *@return 一个初始化的 SeaTableViewController 对象
 */
- (id)initWithStyle:(UITableViewStyle) style
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _style = style;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}


#pragma mark- public method

/**初始化视图 子类必须调用该方法
 */
- (void)initialization
{
    CGRect frame = CGRectMake(0, 0, _width_, self.contentHeight);
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:_style];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    self.scrollView = _tableView;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fuZaCellIden"];
    
    [self.view addSubview:_tableView];
}

#pragma mark- tableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.cellSeparatorFullScreen)
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        if([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (void)viewDidLayoutSubviews
{
    if(self.cellSeparatorFullScreen)
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
        if([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}


@end
