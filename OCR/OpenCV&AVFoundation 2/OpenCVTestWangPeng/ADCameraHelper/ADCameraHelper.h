//
//  ADCameraHelper.h
//  ISTPetsV2
//
//  Created by wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^CaptureImageBlock)(UIImage *);

typedef void (^CaptureReallyImageBlock)(UIImage *aImage);//实时取景

@interface ADCameraHelper : NSObject
<AVCaptureVideoDataOutputSampleBufferDelegate>
{
  
    UIImage *image;
   
    
}
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureStillImageOutput *captureOutput;
@property (nonatomic,strong)AVCaptureVideoDataOutput *output;
@property (nonatomic,strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,assign) BOOL isProcessingImage;
@property (nonatomic,copy) CaptureImageBlock captureBlock;
@property (nonatomic,copy) CaptureReallyImageBlock captureReallyImage;
@property (nonatomic,strong) dispatch_queue_t serialQueue;
/**
 *  单例
 *
 *  @return 返回实例对象
 */
+ (id) sharedInstance;
/**
 *	启动相机取景
 */
+ (void)startRunning;
/**
 *	停止相机取景
 */
+ (void)stopRunning;
/**
 *	获取当前拍照得到的image
 *
 *	@return	拍照得到的image
 */
+ (UIImage *)image;
/**
 *	将相机取景画面显示在view上
 *
 *	@param	aView	要被显示的view视图
 */
+ (void)embedPreviewInView:(UIView *)aView;
/**
 *	拍照
 */
+ (void)captureStillImage;
/**
 *	带block的拍照
 *
 *	@param	block	block参数
 */
+ (void)captureStillImageWithBlock:(CaptureImageBlock)block;
/**
 *	翻转相机前/后摄像头
 *
 *	@return	是否翻转成功
 */
+ (BOOL)toggleCamera;
/**
 *	是否在使用后置摄像头取景
 *
 *	@return	当前是否正使用后置摄像头
 */
+ (BOOL)isBackFacingCamera;
/**
 *	设备后置摄像头是否支持闪光灯
 *
 *	@return	设备后置摄像头是否支持闪光灯
 */
+ (BOOL)isBackCameraSupportFlash;
/**
 *	设备后置摄像头闪光灯是否支持自动模式
 *
 *	@return	设备后置摄像头闪光灯是否支持自动模式
 */
+ (BOOL)isBackCameraFlashSupportAutoMode;
/**
 *	设备后置摄像头闪光灯是否支持开启模式
 *
 *	@return	设备后置摄像头闪光灯是否支持开启模式
 */
+ (BOOL)isBackCameraFlashSupportOnMode;
/**
 *	设备后置摄像头闪光灯是否支持关闭模式
 *
 *	@return	设备后置摄像头闪光灯是否支持关闭模式
 */
+ (BOOL)isBackCameraFlashSupportOffMode;
/**
 *	将设备后置摄像头闪光灯模式置为自动
 */
+ (void)changeBackCameraFlashModeToAuto;
/**
 *	将设备后置摄像头闪光灯模式置为开启
 */
+ (void)changeBackCameraFlashModeToOn;
/**
 *	将设备后置摄像头闪光灯模式置为关闭
 */
+ (void)changeBackCameraFlashModeToOff;

@end
