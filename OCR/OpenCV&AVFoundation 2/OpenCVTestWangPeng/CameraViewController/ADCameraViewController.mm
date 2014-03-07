 //
//  ADCameraViewController.m
//  AVFoundationCamera
//
//  Created by  wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "ADCameraViewController.h"
#import "UIImage+OpenCV.h"
#import "opencv2/opencv.hpp"

@interface ADCameraViewController ()
{
    
}
@property(nonatomic,strong)UIView *previewView;

@property(nonatomic,strong)UIImageView *drawImageView;
@property(nonatomic,assign)int whiteBalanceCount;
@property(nonatomic,assign)BOOL isCompleteFocus;
@property(nonatomic,assign)BOOL isComplete2Frame;
@property(nonatomic,strong)AVCaptureDevice* device;
@end

@implementation ADCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.whiteBalanceCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //创建视图
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _previewView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_previewView];
    
    
    self.drawView = [[ADPreviewView alloc] initWithFrame:_previewView.bounds];
    _drawView.backgroundColor = [UIColor clearColor];
    _drawView.delegate = self;
    [self.view addSubview:_drawView];
    
    self.drawImageView = [[UIImageView alloc] initWithFrame:_previewView.bounds];
    _drawImageView.backgroundColor = [UIColor redColor];
    // [_drawView addSubview:_drawImageView];
    
    _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    _centerLabel.text = @"检测中";
    _centerLabel.backgroundColor = [UIColor blackColor];
    _centerLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_centerLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(10, 410, 80, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMainVc:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    self.helper = [ADCameraHelper sharedInstance];
    
    //小窗口显示图片
    UIImageView *littleWidow = [[UIImageView alloc] initWithFrame:CGRectMake(-70, self.view.frame.size.height - 390, 460, 320)];
    littleWidow.backgroundColor = [UIColor redColor];
    //  [self.view addSubview:littleWidow];
    
    [[ADCameraHelper sharedInstance] setCaptureReallyImage:^(UIImage *captureImage){
        if (captureImage) {
            
            //在此对图片用openCV作处理
            
            [self performSelectorOnMainThread:@selector(setCurrentImage:) withObject:captureImage waitUntilDone:NO];
            
            [self processFrameWithImage:captureImage];
            
        }
        
    }];
    //预览窗口
    
    [ADCameraHelper embedPreviewInView:_previewView];

    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [_device addObserver:self forKeyPath:@"adjustingWhiteBalance" options:NSKeyValueObservingOptionNew  context:nil];
    
    [_device addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];
    
    [_device addObserver:self forKeyPath:@"adjustingExposure" options:(NSKeyValueObservingOptionNew |
                                                                      NSKeyValueObservingOptionOld) context:nil];
    
    _isComplete2Frame = NO;
    _isCompleteFocus = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"add ob!!!!!!");
    
    if ([keyPath isEqualToString:@"adjustingWhiteBalance"]) {
        
        NSLog(@"----------------------------白平衡%hhd", _device.isAdjustingWhiteBalance);
        
//        if (device.adjustingWhiteBalance) {
//            if (self.whiteBalanceCount == 2) {
//                self.whiteBalanceCount = 3;
//            }
//        }else{
//            if (self.whiteBalanceCount == 1) {
//                self.whiteBalanceCount = 2;
//            }else if(self.whiteBalanceCount == 3){
//                
//                self.whiteBalanceCount = 4;
//                
////                self.whiteBalanceCount = 10;
////                [ADCameraHelper captureStillImageWithBlock:^(UIImage *captureImage){
////                    
////                    ADViewPhotoViewController *viewPhotoVc = [[ADViewPhotoViewController alloc] init];
////                    viewPhotoVc.photoImage = captureImage;
////                    [self.navigationController pushViewController:viewPhotoVc animated:YES];
////                    
////                }];
//            }
//        }
        
        BOOL adjustedWhiteBalance =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:0]];
        NSLog(@"是否白平衡结束 %d",adjustedWhiteBalance);
        
    }
    
    if ([keyPath isEqualToString:@"adjustingFocus"]) {
        
        NSLog(@"---------------------------对焦：%d", _device.adjustingFocus);
        BOOL adjustedFocus =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:0]];
        NSLog(@"是否对焦 %d",adjustedFocus);
        
        if (adjustedFocus) {
            _isCompleteFocus = YES;
        }else{
            _isCompleteFocus = NO;
        }
    }
    
    if ([keyPath isEqualToString:@"adjustingExposure"]) {
        NSLog(@"-----曝光：%d", _device.isAdjustingExposure);
    }
    
}


#pragma mark - openCV对图像进行处理
// Perform image processing on the last captured frame and display the results
- (UIImage *)processFrameWithImage:(UIImage *)aImage
{
    
    using namespace cv;
    
    int lowThreshold = 100;
    int ratio = 3;
    int kernel_size = 3;
    
    Mat lastFrame = [aImage CVMat];
    Mat grayFrame, detFrame,output;
    
    resize(lastFrame, lastFrame, cv::Size(568,320));
    
    //打印图像尺寸
//    NSLog(@"原图像的行是 %f  列是  %f",aImage.size.width, aImage.size.height);
//    NSLog(@"行是 %d  列是  %d",lastFrame.rows,lastFrame.cols);
    // Convert captured frame to grayscale  灰度图
    cvtColor(lastFrame, grayFrame,COLOR_RGB2GRAY);
    
    //使用Canny算法进行边缘检测,返回图像即是二值单通道的图
    Canny(grayFrame, output,
          lowThreshold,
          lowThreshold * ratio,
          kernel_size);
    
    //使用 findContours 找轮廓
    vector<vector<cv::Point>> contours;
    findContours(output, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    
    double area = 0;
    
    for( int i = 0; i< contours.size(); i++ )
    {
        
        //找到面积最大的
        area = fabs(contourArea(contours[i]));
        
        //将倾斜角度算出来
        vector<cv::Point> approxCurve;
        
        //将vector转换成Mat型，此时的Mat还是列向量，只不过是2个通道的列向量而已
        Mat contourMat = Mat(contours[i]);
        double eps = contours[i].size() * 0.05;
        approxPolyDP(contourMat, approxCurve, eps, YES);//求出轮廓的封闭的曲线，保存在approxCurve，轮廓和封闭曲线直接的最大距离为1
        
        if ((area > MIN_DETECT_AREA) && (4 == approxCurve.size()) && isContourConvex(approxCurve)) {
            
            NSMutableArray *contourArray = [NSMutableArray arrayWithCapacity:1];
            for (int k = 0; k < approxCurve.size(); k++) {
                
                ADContours *contour = [[ADContours alloc] initWithPointX:approxCurve[k].x pointY:approxCurve[k].y];
                [contourArray addObject:contour];
                
            }
            
            NSLog(@"size: %zu", approxCurve.size());
            NSLog(@"size: %zu", (unsigned long)[contourArray count]);
            
            _drawView.modelArray = contourArray;
            
            if (contourArray.count == 0) {
                continue;
            }
            

            //判断是否达到拍照条件
            if ([self shouldTakePhotoWithCoutours:contourArray andArea:area]) {
                
            }
            
            [_drawView performSelectorOnMainThread:@selector(setNeedsDisplay)
                                        withObject:nil waitUntilDone:YES];
            break;
        }
        else{
            continue;
        }
        
        
    }
 
    lastFrame.release();
    grayFrame.release();
    output.release();
    
    contours.clear();
    
    return nil;
    
}


#pragma mark - 计算两个坐标点之间的距离
-(float)distanceFromPointX:(ADContours *)start distanceToPointY:(ADContours *)end{
    float distance;
    CGFloat xDist = (end.point_x - start.point_x);
    CGFloat yDist = (end.point_y - start.point_y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

#pragma mark -判断是否达到拍照条件
- (BOOL)shouldTakePhotoWithCoutours:(NSArray *)countours andArea:(double)area
{
    static int frameNumber = 0;
    ADContours *contour1 = [countours objectAtIndex:0];
    ADContours *contour2 = [countours objectAtIndex:1];
    ADContours *contour3 = [countours objectAtIndex:2];
    ADContours *contour4 = [countours objectAtIndex:3];
    float distance1 = [self distanceFromPointX:contour1 distanceToPointY:contour2];
    float distance2 = [self distanceFromPointX:contour3 distanceToPointY:contour4];
    float distance3 = [self distanceFromPointX:contour2 distanceToPointY:contour3];
    float distance4 = [self distanceFromPointX:contour1 distanceToPointY:contour4];
    
    NSLog(@"面积是：%f", area);
    
    [_centerLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%.1f", area] waitUntilDone:NO];
    
    NSLog(@"四个距离分别是%.1f   %.1f   %.1f   %.1f",distance1,distance2,distance3,distance4);
    
//    if (((fabs(distance1 - distance2) > 50 && fabs(distance1 - distance2) < 80) ||
//         (fabs(distance3 - distance4) >50 && fabs(distance3 - distance4) < 80)) &&
//        area > MIN_PHOTO_AREA) {
    
    if ((fabs(distance1 - distance2) < 80 ||
         fabs(distance3 - distance4) < 80) &&
        area > MIN_PHOTO_AREA) {
        
        _drawView.isRightStatus = YES;
        
        frameNumber ++;
        
        NSLog(@"哈哈哈哈哈%d   %d",frameNumber,_isCompleteFocus);
        
        if (_isCompleteFocus && _isComplete2Frame) {
            [self performSelectorOnMainThread:@selector(takePhoto:) withObject:Nil waitUntilDone:NO];
        }
        
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            
//        });
        
        if (frameNumber > 20) {
            
            //中心对焦
//            if ([_device isFocusPointOfInterestSupported]) {
//                NSError *error;
//                if ([_device lockForConfiguration:&error]) {
//                    [_device setFocusPointOfInterest:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
//                    
//                    NSLog(@"the interest point: %f %f",
//                          self.view.bounds.size.width/2, self.view.bounds.size.height/2);
//                    
////                    [_device setExposurePointOfInterest:CGPointMake(self.view.bounds.size.height/2, self.view.bounds.size.width/2)];
//                    
//                    //                    [_device setFocusMode:AVCaptureFocusModeAutoFocus];
//                    //                    if ([_device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
//                    //                        [_device setExposureMode:AVCaptureExposureModeAutoExpose];
//                    //                    }
//                    [_device unlockForConfiguration];
//                }
//            }
            
            _isComplete2Frame = YES;
            
            frameNumber = 0;
            
        }
        
        return YES;
        
    }
    
    else{
        
        _isComplete2Frame = NO;
        
        frameNumber = 0;
        _drawView.isRightStatus = NO;
        return NO;
    }
}

- (UIImage *)rotateImage:(UIImage *)aImage
{
    
    
    CGSize outputSize = aImage.size;
    UIGraphicsBeginImageContext(aImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    
    CGContextRotateCTM(context, ((90) / 180.0 * M_PI));
    
    CGContextTranslateCTM(context, -outputSize.width / 2, -outputSize.height / 2);
    [aImage drawInRect:CGRectMake(0, 0, outputSize.width, outputSize.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
    
}
//自动拍照
- (void)capturePictureAutomaticlyWithImage:(UIImage *)aImage
{
    NSLog(@"自动拍照了....");
    //停止录制
//    [ADCameraHelper  stopRunning];
    //初始化controller
    ADViewPhotoViewController *viewPhotoVc = [[ADViewPhotoViewController alloc] init];
    //图片赋值
    
    UIImage *resultImage = [UIImage imageWithCGImage:aImage.CGImage scale:1.0 orientation:UIImageOrientationRight];
    viewPhotoVc.photoImage = resultImage;
    [self.navigationController pushViewController:viewPhotoVc animated:YES];
}

- (void)capturePictureAutomaticly
{
    ADCameraHelper *helper = [ADCameraHelper sharedInstance];
    if (helper.captureOutput == nil){
        helper.captureOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [helper.captureOutput  setOutputSettings:outputSettings];
        
    }
    [helper.session removeOutput:helper.output];
    [helper.session addOutput:helper.captureOutput ];
    
    
    NSError *deviceError;
    [_device lockForConfiguration:&deviceError];
//    _device.torchMode = AVCaptureTorchModeOn;
    [_device unlockForConfiguration];
    
    //    [ADCameraHelper startRunning];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _isComplete2Frame = NO;
    _isCompleteFocus = NO;
    
    [_helper.session startRunning];
    
    NSError *deviceError;
    [_device lockForConfiguration:&deviceError];
    _device.torchMode = AVCaptureTorchModeOn;
    [_device unlockForConfiguration];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.whiteBalanceCount = 0;
    
    [_helper.session stopRunning];
    
    //清除绘制
    [_drawView.modelArray removeAllObjects];
    [_drawView performSelectorOnMainThread:@selector(setNeedsDisplay)
                                withObject:nil waitUntilDone:YES];
}
#pragma mark - previewView  delegate
- (void) previewView:(UIView *)preview focusAtPoint:(CGPoint)point
{
    //  focusLayer.frame = CGRectMake((touchPoint.x-25), (touchPoint.y-25), 50, 50);
    
    //确定对焦点
    CGPoint  pointOfInterest;
    CGSize frameSize = preview.frame.size;
    AVCaptureDeviceInput *videoInput = [[ADCameraHelper sharedInstance] videoInput];
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [[ADCameraHelper sharedInstance] preview];
    
    for (AVCaptureInputPort *port in videoInput.ports) {
        if ([port mediaType] == AVMediaTypeVideo) {
            CGRect cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
            CGSize apertureSize = cleanAperture.size;
            CGFloat apertureRatio = apertureSize.height / apertureSize.width;
            CGFloat viewRatio = frameSize.width / frameSize.height;
            CGFloat xc = 0.5f;
            CGFloat yc = 0.5f;
            
            if ([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                if (viewRatio > apertureRatio) {
                    CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                    xc = (point.y + ((y2 - frameSize.height) / 2.0f)) / y2;
                    yc = (frameSize.width - point.x) / frameSize.width;
                } else {
                    CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                    yc = 1.0f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                    xc = point.y / frameSize.height;
                }
                
            }
            
            pointOfInterest = (CGPoint){ xc, yc };
            break;
            
        }
        
    }
    
    //实现对焦
    
    if ([_device isFocusPointOfInterestSupported]) {
        NSError *error;
        if ([_device lockForConfiguration:&error]) {
            [_device setFocusPointOfInterest:CGPointMake(pointOfInterest.x, pointOfInterest.y)];
            [_device setExposurePointOfInterest:CGPointMake(pointOfInterest.x, pointOfInterest.y)];
            
            [_device setFocusMode:AVCaptureFocusModeAutoFocus];
            if ([_device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                [_device setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            [_device unlockForConfiguration];
        }
    }
    //动画显示聚焦点
     [(ADPreviewView *)preview drawFocusBoxAtPointOfInterest:point andRemove:YES];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回
- (void)backToMainVc:(UIButton *)btn
{
    //Back
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//拍照
- (void)takePhoto:(UIButton *)btn
{
    
    [ADCameraHelper captureStillImageWithBlock:^(UIImage *captureImage){
        
        _isCompleteFocus = NO;
        _isComplete2Frame = NO;
        
        ADViewPhotoViewController *viewPhotoVc = [[ADViewPhotoViewController alloc] init];
        viewPhotoVc.photoImage = captureImage;
        [self.navigationController pushViewController:viewPhotoVc animated:YES];
        
    }];
}


//获取图片并跳转到下一界面
- (void)getImage
{
    ADViewPhotoViewController *viewPhotoVc = [[ADViewPhotoViewController alloc] init];
    viewPhotoVc.photoImage = [ADCameraHelper image];
    [self.navigationController pushViewController:viewPhotoVc animated:YES];
}



@end
