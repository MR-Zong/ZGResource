//
//  MainViewController.m
//  画图板
//
//  Created by 609972942 on 15/12/15.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MainViewController.h"
#import "DrawView.h"
#import "ToolView.h"
#import "UIView+ZHY.h"

@interface MainViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) DrawView *drawView;

@end

@implementation MainViewController

- (void)loadView{
    [super loadView];
    
    UIView *rootView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [rootView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tool_back"]]];
    
    self.view = rootView;
}

#pragma mark 试图已经加载完毕
- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatDrawView];
    
    [self creatToolView];
}

#pragma mark 初始化drawView
- (void)creatDrawView{
    
    DrawView *drawView = [[DrawView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20)];
    
    [self.view addSubview:drawView];
    
    self.drawView = drawView;
}

#pragma mark 初始化toolView
- (void)creatToolView{
    
    ToolView *toolView = [[ToolView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44) andSelectedColorBlock:^(UIColor *color) {
        
        [self.drawView setDrawColor:color];
        
    } andSelectedWidthBlock:^(CGFloat width) {
        
        [self.drawView setDrawWidth:width];
        
    } andErraserBlock:^{
        
        [self.drawView setDrawColor:[UIColor whiteColor]];
        [self.drawView setDrawWidth:20];
        
    } andUndo:^{
        
        [self.drawView undo];
        
    } andClear:^{
        
        [self.drawView clearScreen];
        
    } andPhoto:^{
        
        [self intoImageLibrary];
        
    } andSave:^{
        
        [self saveImage];
        
    }];
    
    [self.view addSubview:toolView];
    
}


#pragma mark 进入选择照片
- (void)intoImageLibrary{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    [imagePicker setDelegate:self];
//  image可以编辑
    [imagePicker setAllowsEditing:YES];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark imagePicker的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    
    [self.drawView setDrawImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark 保存照片
- (void)saveImage{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否保存" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        
        UIImage *image =[self.view getImageFromView:self.view];
        
//      保存到相册中
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
    }
}


@end
