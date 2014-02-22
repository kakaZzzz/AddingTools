//
//  ADCameraHelper.m
//  AVFoundationCamera
//
//  Created by wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "ADCameraHelper.h"
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>

@implementation ADCameraHelper
@synthesize image;

@synthesize isProcessingImage = _isProcessingImage;

static ADCameraHelper *sharedInstance = nil;

- (void)initialize
{
    NSLog(@"ADCameraHelper初始化.....");
    //正在处理生成图片为NO
    self.isProcessingImage = NO;
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];//丫的这个几个级别不一样还会导致程序crash
    
    
    [self configurateTakePhote];
    
    
    
    //2.创建、配置输入设备
//  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//	NSError *error;
//	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
//	if (!captureInput)
//	{
//		NSLog(@"Error: %@", error);
//		return;
//	}
//    [self.session addInput:captureInput];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
    if ([self.session canAddInput:_videoInput]) {
        [self.session addInput:_videoInput];
    }
   // self.videoInput = newVideoInput;
   
    //3.创建、配置输出  image输出
    self.captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [_captureOutput setOutputSettings:outputSettings];
    
    //配置输出 video输出
    self.output = [[AVCaptureVideoDataOutput alloc] init];
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [_output setSampleBufferDelegate:self queue:queue];
    
    //[output setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];

    // Specify the pixel format
    _output.videoSettings =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [_output setAlwaysDiscardsLateVideoFrames:YES];//丢弃延迟的影格
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
    //output.minFrameDuration = CMTimeMake(1, 15);
    
//    AVCaptureConnection *connection = [_output connectionWithMediaType:AVMediaTypeVideo];
//    [connection setVideoMaxFrameDuration:CMTimeMake(1, 20)];
//    [connection setVideoMinFrameDuration:CMTimeMake(1, 10)];


	[self.session addOutput:_output];
    
    
    
}
- (id) init
{
	if (self = [super init]) [self initialize];
	return self;
}

- (void)configurateTakePhote
{
    AVCaptureDevice *  device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *deviceError;
    if (device.hasFlash) {
        NSLog(@"device.hasFlash turning flash mode on");
        [device lockForConfiguration:&deviceError];
        device.flashMode = AVCaptureFlashModeOn;
        [device unlockForConfiguration];
    }
    else {
        NSLog(@"Device does not have Flash");
    }
    
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        NSLog(@"Enabling ContinuousAutoFocus");
        [device lockForConfiguration:&deviceError];
        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        [device unlockForConfiguration];
    }
    else {
        NSLog(@"Device does not support ContinuousAutoFocus");
    }
    
    if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        NSLog(@"Enabling ContinuousAutoExposure");
        [device lockForConfiguration:&deviceError];
        device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        [device unlockForConfiguration];
    }
    else {
        NSLog(@"Device does not support ContinuousAutoExposure");
    }
    
    if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        NSLog(@"Enabling ContinuousAutoWhiteBalance");
        [device lockForConfiguration:&deviceError];
        device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
        [device unlockForConfiguration];
    }
    else {
        NSLog(@"Device does not support ContinuousAutoWhiteBalance");
    }
}

/**
 *  插入预览视图到主视图中
 *
 *  @param aView 背景视图
 */
-(void) embedPreviewInView: (UIView *) aView {
    
    if (!_session) return;
    NSLog(@"实时显示的镜头内容");
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession: _session];
    _preview.frame = aView.bounds;
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer: _preview];
    
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate协议方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // Create a UIImage from the sample buffer data
    NSLog(@"实时输出图像的代理方法");
    UIImage *outImage = [self imageFromSampleBuffer:sampleBuffer];
   // NSLog(@"丫的照片%@",outImage);
    
    // < Add your code here that uses the image >
    //丫的在这里处理outImage可以用吗？内存地址会不会立马释放？
    
    _captureReallyImage(outImage);

//    if (!_serialQueue) {
//        self.serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
//    }
//    
//    dispatch_sync(_serialQueue, ^{
//        //使用_image的操作
//        _captureReallyImage(outImage);
//    });
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    /**
     *  第一种方法
     *
     *  @param imageBuffer
     *
     *  @return
     */
    // Get the base address of the pixel buffer
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,
                                                              NULL);
    // Create a bitmap image from data supplied by our data provider
    
    //得到cgImage的一种方法
//    CGImageRef cgImage =
//    CGImageCreate(width,
//                  height,
//                  8,
//                  32,
//                  bytesPerRow,
//                  colorSpace,
//                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
//                  provider,
//                  NULL,
//                  true,
//                  kCGRenderingIntentDefault);
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
     CGContextRelease(context);
    
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

//    /**
//     *  第二种方法
//     */
//    
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
//                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    // 根据这个位图context中的像素数据创建一个Quartz image对象
//    CGImageRef cgImage = CGBitmapContextCreateImage(context);
//    // 解锁pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    
//    // 释放context和颜色空间
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
    
    // Create and return an image object representing the specified Quartz image
    UIImage *outImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return outImage;
}

    //
-(void)captureimage
{
    //将处理图片状态值置为YES
    //获取连接
    self.isProcessingImage = YES;
    //get connection
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    __block ADCameraHelper *objSelf = self;
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         if (imageSampleBuffer != NULL) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             NSLog(@"开始生成图片");
             UIImage *tempImage = [[UIImage alloc] initWithData:imageData];
             objSelf.image = tempImage;
             //将处理图片状态值置为NO
             objSelf.isProcessingImage = NO;
         }
//         CFDictionaryRef exifAttachments =
//         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
//         if (exifAttachments) {
//             // Do something with the attachments.
//         }
//         // Continue as appropriate.
//         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
//         UIImage *t_image = [[UIImage alloc] initWithData:imageData] ;
//#if 1
//         image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0 orientation:UIImageOrientationUp];
//         [t_image release];
//#else
//         image = [t_image resizedImage:CGSizeMake(image.size.width, image.size.height) interpolationQuality:kCGInterpolationDefault];
//#endif
     }];
}
- (void)captureImage:(CaptureImageBlock)block{
    
    
    NSLog(@"拍照-------");
    //get connection
//    if (_captureBlock){
//        Block_release(_captureBlock);
//            }
//    captureBlock = Block_copy(block);
    _captureBlock = block;
    //将处理图片状态值置为YES
    //获取连接
    self.isProcessingImage = YES;
    //get connection
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    __block ADCameraHelper *objSelf = self;
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         if (imageSampleBuffer != NULL) {
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             NSLog(@"开始生成图片");
             UIImage *tempImage = [[UIImage alloc] initWithData:imageData];
             objSelf.image = tempImage;
             //将处理图片状态值置为NO
             objSelf.isProcessingImage = NO;
             
             //返回图片
             objSelf->_captureBlock(objSelf.image);

         }
         
         }];
//    //get UIImage
//    __block ADCameraHelper *objSelf = self;
//    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
//     
//     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
//         if (imageSampleBuffer != NULL) {
//             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
//            
//             NSLog(@"开始生成图片");
//             UIImage *tempImage = [[UIImage alloc] initWithData:imageData];
//             objSelf.image = tempImage;
//             
//             //返回图片
//             objSelf->_captureBlock(objSelf.image);
//         }
//     }];
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

// Find a front facing camera, returning nil if one is not found
- (AVCaptureDevice *) frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// Find a back facing camera, returning nil if one is not found
- (AVCaptureDevice *) backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (BOOL) toggleCameraPosition
{
    BOOL success = NO;

    if ([self cameraCount] > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        else if (position == AVCaptureDevicePositionFront)
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        else
            goto bail;
        
        if (newVideoInput != nil) {
            [[self session] beginConfiguration];
            [[self session] removeInput:[self videoInput]];
            if ([[self session] canAddInput:newVideoInput]) {
                [[self session] addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [[self session] addInput:[self videoInput]];
            }
            [[self session] commitConfiguration];
            success = YES;
            
        } else if (error) {
            NSLog(@"切换镜头出错:%@",error);
        }
    }
    
bail:
    return success;
}
- (BOOL)isUseBackFacingCamera
{
    BOOL isUse;
    AVCaptureDevicePosition position = [[_videoInput device] position];
    
    if (position == AVCaptureDevicePositionBack){
        isUse = YES;
    }else if (position == AVCaptureDevicePositionFront){
        isUse = NO;
    }else{
        isUse = NO;
    }
    return isUse;
}
- (BOOL)isBackCameraHasFlash
{
    if ([[self backFacingCamera] hasFlash]) {
        return YES;
    }
    return NO;
}
- (BOOL)isFlashSupportAutoMode
{
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeAuto]) {
            return YES;
        }
	}
    return NO;
}
- (BOOL)isFlashSupportOnMode
{
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOn]) {
            return YES;
        }
	}
    return NO;
}
- (BOOL)isFlashSupportOffMode
{
    if ([[self backFacingCamera] hasFlash]) {
        if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOff]) {
            return YES;
        }
	}
    return NO;
}
- (void)changeFlashModeToAuto
{
    if ([[self backFacingCamera] hasFlash]) {
		if ([[self backFacingCamera] lockForConfiguration:nil]) {
			if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeAuto]) {
				[[self backFacingCamera] setFlashMode:AVCaptureFlashModeAuto];
			}
			[[self backFacingCamera] unlockForConfiguration];
		}
	}
}
- (void)changeFlashModeToOn
{
    if ([[self backFacingCamera] hasFlash]) {
		if ([[self backFacingCamera] lockForConfiguration:nil]) {
			if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOn]) {
				[[self backFacingCamera] setFlashMode:AVCaptureFlashModeOn];
			}
			[[self backFacingCamera] unlockForConfiguration];
		}
	}
}
- (void)changeFlashModeToOff
{
    if ([[self backFacingCamera] hasFlash]) {
		if ([[self backFacingCamera] lockForConfiguration:nil]) {
			if ([[self backFacingCamera] isFlashModeSupported:AVCaptureFlashModeOff]) {
				[[self backFacingCamera] setFlashMode:AVCaptureFlashModeOff];
			}
			[[self backFacingCamera] unlockForConfiguration];
		}
	}
}
#pragma mark Device Counts
- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

#pragma mark Class Interface

+ (id) sharedInstance // 
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ADCameraHelper alloc] init];
    });
    return sharedInstance;
}
+ (void) startRunning
{
	[[[ADCameraHelper sharedInstance] session] startRunning];
   
}

+ (void) stopRunning
{
	[[[ADCameraHelper sharedInstance] session] stopRunning];

}

+ (BOOL)toggleCamera
{
    return [[ADCameraHelper sharedInstance] toggleCameraPosition];
}

+ (UIImage *) image
{
    //判断图片状态状态值，如果为YES，则等待，避免因还未生成图片时取图片而造成的返回照片不正确的问题
//    BOOL shouldWait = YES;
//    while (shouldWait) {
//        if (![[ADCameraHelper sharedInstance] isProcessingImage]) {
//            NSLog(@"照片组成完毕");
//            shouldWait = NO;
//        }
//    }
    NSLog(@"取图片");
    return [[ADCameraHelper sharedInstance] image];
}

+ (void)captureStillImage
{
    [[ADCameraHelper sharedInstance] captureimage];
}

+ (void)captureStillImageWithBlock:(CaptureImageBlock)block
{
    [[ADCameraHelper sharedInstance] captureImage:block];
}

+ (void)embedPreviewInView: (UIView *) aView
{
    [[ADCameraHelper sharedInstance] embedPreviewInView:aView];
}

+ (BOOL)isBackFacingCamera
{
    return [[ADCameraHelper sharedInstance] isUseBackFacingCamera];
}

+ (BOOL)isBackCameraSupportFlash
{
    return [[ADCameraHelper sharedInstance] isBackCameraHasFlash];
}

+ (BOOL)isBackCameraFlashSupportAutoMode
{
    return [[ADCameraHelper sharedInstance] isFlashSupportAutoMode];
}

+ (BOOL)isBackCameraFlashSupportOnMode
{
    return [[ADCameraHelper sharedInstance] isFlashSupportOnMode];
}

+ (BOOL)isBackCameraFlashSupportOffMode
{
    return [[ADCameraHelper sharedInstance] isFlashSupportOffMode];
}

+ (void)changeBackCameraFlashModeToAuto
{
    [[ADCameraHelper sharedInstance] changeFlashModeToAuto];
}

+ (void)changeBackCameraFlashModeToOn
{
    [[ADCameraHelper sharedInstance] changeFlashModeToOn];
}

+ (void)changeBackCameraFlashModeToOff
{
    [[ADCameraHelper sharedInstance] changeFlashModeToOff];
}

@end
