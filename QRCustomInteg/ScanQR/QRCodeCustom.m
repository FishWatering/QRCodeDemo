//
//  QRCodeCustom.m
//  QRCustomInteg
//
//  Created by 李萍 on 2018/5/10.
//  Copyright © 2018年 李萍. All rights reserved.
//

#import "QRCodeCustom.h"

@implementation QRCodeCustom

/*
 
 创建二维码
 message 生成二维码所带的信息
 return 返回生成的二维码图片
 
 */
+ (UIImage *)createQRCodeWithMessage:(NSString *)message completionImageSize:(CGSize)size
{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    
    UIImage *image = [QRCodeCustom createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];//重绘二维码,使其显示清晰
    
    return image;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGSize)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
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

/*
 识别二维码
 bgView 二维码所在View
 
 return 打印二维码中的信息
 */
+ (NSString *)readQRCode:(UIView *)bgView
{
    NSMutableString *mutString = @"".mutableCopy;
    
    //截图 再读取
    UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [bgView.layer renderInContext:context];
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
    
    return mutString;
}

/*
 保存二维码图片
 imageView 二维码所在imageView
 completionTarget 二维码所在控制器 self
 
 */
+ (void)saveQRCodeImage:(UIImageView *)imageView compleTarget:(__nullable id )completionTarget
{
    UIImageWriteToSavedPhotosAlbum(imageView.image,
                                   completionTarget,
                                   @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),
                                   NULL); // 写入相册
}

// 完善回调
-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    self.saveCompletion(error);
}

@end


//////
@implementation QRCodeCustomView

@end
