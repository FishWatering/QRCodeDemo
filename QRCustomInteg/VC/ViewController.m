//
//  ViewController.m
//  QRCustomInteg
//
//  Created by 李萍 on 2018/5/9.
//  Copyright © 2018年 李萍. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+CustomColor.h"
#import "DetailViewController.h"

#import "QRCodeCustom.h"

#define img_w_h 300
@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *scanImageView;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor colorWithHex:0x123456];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"扫" style:UIBarButtonItemStylePlain target:self action:@selector(scanAction)];
    
    
    UITextView *textView = [UITextView new];
    textView.text = @"等待传入二维码生成所需内容";
    textView.textColor = [UIColor TextColor];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(@(100));
        make.right.equalTo(@(-10));
        make.height.equalTo(@(100));
    }];
    self.textView = textView;
    
    UIButton *button = [UIButton new];
    [button setTitle:@"生成二维码" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.top.equalTo(textView.mas_bottom).offset(10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@(50));
    }];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgView = [UIImageView new];
    imgView.backgroundColor = [UIColor ThemeColor];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button.mas_centerX);
        make.top.equalTo(button.mas_bottom).with.offset(20);
        make.width.and.height.equalTo(@(img_w_h));
    }];
    self.scanImageView = imgView;
    imgView.userInteractionEnabled = YES;
    //长按手势 识别二维码
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(scanViewLongGesAction:)];
    longGes.minimumPressDuration = 1;
    [imgView addGestureRecognizer:longGes];
    
    
    
    //监听软键盘 //Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickForHiddenKeyBoard)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)scanAction
{
    [self.navigationController pushViewController:[DetailViewController new] animated:YES];
}

#pragma mark - buttonAction

- (void)buttonAction
{
    if (self.textView.text.length > 0) {
        /*
         1、直接写
         */
//        [self setFilter:self.textView.text];
        
        /*
         2、整合
         */
        self.scanImageView.image = [QRCodeCustom createQRCodeWithMessage:self.textView.text completionImageSize:CGSizeMake(300, 300)];
        
    }
}

#pragma mark - long ges
- (void)scanViewLongGesAction:(UILongPressGestureRecognizer *)longGes
{
    NSMutableString *mutString = @"".mutableCopy;
    
    if (longGes.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan ....");
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"选择" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /*
             1、直接写
             */
            //截图 再读取
            /*
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.view.layer renderInContext:context];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            //识别二维码
            CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
            CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
            
            NSArray *features = [detector featuresInImage:ciImage];
            for (CIQRCodeFeature *feature in features) {
                NSLog(@"msg = %@",feature.messageString); // 打印二维码中的信息
                [mutString appendString:feature.messageString];
            }
            */
            
            /*
             2、整合
             */
            [mutString appendString:[QRCodeCustom readQRCode:self.view]];
            
            
            
            UIAlertController *alertVc2 = [UIAlertController alertControllerWithTitle:@"扫描结果" message:mutString preferredStyle:UIAlertControllerStyleAlert];
            
            [alertVc2 addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertVc2 animated:YES completion:nil];
        }]];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"保存当前二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /*
             1、直接写
             */
            /*
            UIImageWriteToSavedPhotosAlbum(self.scanImageView.image,
                                           self,
                                           @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),
                                           NULL); // 写入相册
             */
            
            /*
             2、整合
             */
            [QRCodeCustom saveQRCodeImage:self.scanImageView compleTarget:self];
            
        }]];
        
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
        
        ///////////
        
        
        
    } else {
        NSLog(@"end .......");
    }
}

// 完善回调

-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片保存成功！" preferredStyle:1];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:1 handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSLog(@"savefailed");
    }
}

#pragma mark - keyboard

- (void)keyboardWillAppear:(NSNotification *)notif
{
    NSLog(@"keyboard show...");
}

- (void)keyboardHidden:(NSNotification *)notif
{
    //    [self.textView endEditing:YES];
    NSLog(@"keyboard hidden...");
}

- (void)clickForHiddenKeyBoard
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




//生成二维码
- (void)setFilter:(NSString *)dataString
{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    self.scanImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:img_w_h];//重绘二维码,使其显示清晰
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *laterImage = [UIImage imageWithCGImage:scaledImage];
    
    CGColorSpaceRelease(cs);
    CGImageRelease(bitmapImage);
    CGContextRelease(bitmapRef);
    CGImageRelease(scaledImage);
    
    
    return laterImage;
}

@end
