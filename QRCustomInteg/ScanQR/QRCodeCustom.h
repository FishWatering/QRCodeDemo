//
//  QRCodeCustom.h
//  QRCustomInteg
//
//  Created by 李萍 on 2018/5/10.
//  Copyright © 2018年 李萍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeCustom : NSObject

/*
 创建的二维码图片的宽,高
 */
@property (nonatomic, assign) CGFloat imageQRCodeWidth;
@property (nonatomic, assign) CGFloat imageQRCodeHeight;

/*
 
 创建二维码
 message 生成二维码所带的信息
 
 return 返回生成的二维码图片
 */
+ (UIImage *)createQRCodeWithMessage:(NSString *)message completionImageSize:(CGSize)size;

/*
 识别二维码
 bgView 二维码所在View
 
 return 打印二维码中的信息
 */
+ (NSString *)readQRCode:(UIView *)bgView;

/*
 保存二维码图片
 imageView 二维码所在imageView
 completionTarget 二维码所在控制器 self
 
  */
+ (void)saveQRCodeImage:(UIImageView *)imageView compleTarget:(__nullable id )completionTarget;
@property (nonatomic, copy) void (^saveCompletion)(NSError *error);

/*
 扫描二维码
 */
//- (void)sacnQRCodeWithView;

@end

////
@interface QRCodeCustomView : UIView

@end
