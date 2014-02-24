//
//  ADCameraViewController.m
//  AVFoundationCamera
//
//  Created by  wangpeng on 14-2-15.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "ADCameraViewController.h"
#import "ADCameraHelper.h"
#import "ADViewPhotoViewController.h"
#import "UIImage+OpenCV.h"
#import "ADContours.h"
#import "ADPreviewView.h"
#import "opencv2/opencv.hpp"
@interface ADCameraViewController ()
{
    
    UIButton *flashBtn;
    ISTCameraFlashMode currentFlashMode;
}
@property(nonatomic,strong)UIView *previewView;

@property(nonatomic,strong)UIImageView *drawImageView;
@property(nonatomic,assign)int whiteBalanceCount;

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
    
    UIButton *takePhotoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePhotoBtn.frame = CGRectMake(110, 410, 100, 40);
    [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoBtn];
    UIButton *toggleCameraBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    toggleCameraBtn.frame = CGRectMake(230, 20, 80, 30);
    [toggleCameraBtn setTitle:@"前后" forState:UIControlStateNormal];
    [toggleCameraBtn addTarget:self action:@selector(toggleCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toggleCameraBtn];
    flashBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    flashBtn.frame = CGRectMake(10, 20, 80, 30);
    [flashBtn addTarget:self action:@selector(changeFlashMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    
    
    //小窗口显示图片
    UIImageView *littleWidow = [[UIImageView alloc] initWithFrame:CGRectMake(-70, self.view.frame.size.height - 390, 460, 320)];
    littleWidow.backgroundColor = [UIColor redColor];
    //  [self.view addSubview:littleWidow];
    
    [[ADCameraHelper sharedInstance] setCaptureReallyImage:^(UIImage *captureImage){
        if (captureImage) {
            
            //在此对图片用openCV作处理
            UIImage *outImage = [self processFrameWithImage:captureImage];
            
        }
        
    }];
    
    //判断支持类别
    if ([ADCameraHelper isBackCameraFlashSupportAutoMode]) {
        [flashBtn setTitle:@"自动" forState:UIControlStateNormal];
        currentFlashMode = ISTCameraFlashModeAuto;
    }else if ([ADCameraHelper isBackCameraFlashSupportOnMode]){
        [flashBtn setTitle:@"打开" forState:UIControlStateNormal];
        currentFlashMode = ISTCameraFlashModeOn;
    }else if ([ADCameraHelper isBackCameraFlashSupportOffMode]){
        [flashBtn setTitle:@"关闭" forState:UIControlStateNormal];
        currentFlashMode = ISTCameraFlashModeOff;
    }
    //后置摄像头若不支持闪光灯隐藏按钮
    if (![ADCameraHelper isBackCameraSupportFlash]) {
        flashBtn.hidden = YES;
    }
    //预览窗口
    
    [ADCameraHelper embedPreviewInView:_previewView];
    //[ADCameraHelper startRunning];
    
    AVCaptureDevice *  device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device addObserver:self forKeyPath:@"adjustingWhiteBalance" options:(NSKeyValueObservingOptionNew |
                                                                          NSKeyValueObservingOptionOld) context:nil];
    [device addObserver:self forKeyPath:@"adjustingFocus" options:(NSKeyValueObservingOptionNew |
                                                                   NSKeyValueObservingOptionOld) context:nil];
    [device addObserver:self forKeyPath:@"adjustingExposure" options:(NSKeyValueObservingOptionNew |
                                                                      NSKeyValueObservingOptionOld) context:nil];
    
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"add ob!!!!!!");
    
    AVCaptureDevice *  device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([keyPath isEqualToString:@"adjustingWhiteBalance"]) {
        
        NSLog(@"-------白平衡%hhd", device.isAdjustingWhiteBalance);
        
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
    }
    
    if ([keyPath isEqualToString:@"adjustingFocus"]) {
        NSLog(@"-----对焦：%d", device.isAdjustingFocus);
        
        if (self.whiteBalanceCount == 1 && device.isAdjustingFocus == 0) {
            self.whiteBalanceCount = 10;
            
            [ADCameraHelper captureStillImageWithBlock:^(UIImage *captureImage){
                
                ADViewPhotoViewController *viewPhotoVc = [[ADViewPhotoViewController alloc] init];
                viewPhotoVc.photoImage = captureImage;
                [self.navigationController pushViewController:viewPhotoVc animated:YES];
                
            }];
        }
    }
    
    if ([keyPath isEqualToString:@"adjustingExposure"]) {
        NSLog(@"-----曝光：%d", device.isAdjustingExposure);
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
    NSLog(@"原图像的行是 %f  列是  %f",aImage.size.width, aImage.size.height);
    NSLog(@"行是 %d  列是  %d",lastFrame.rows,lastFrame.cols);
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
            _drawView.modelArray = contourArray;
            
            [_drawView performSelectorOnMainThread:@selector(setNeedsDisplay)
                                        withObject:nil waitUntilDone:YES];
            
            if ([self shouldTakePhotoWithCoutours:contourArray andArea:area]) {
                
                [self capturePictureAutomaticlyWithImage:aImage];
                
            }
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
    
    if (_centerLabel) {
        _centerLabel.text = [NSString stringWithFormat:@"%f", area];
    }
    
    
    
    NSLog(@"四个距离分别是%.1f   %.1f   %.1f   %.1f",distance1,distance2,distance3,distance4);
    
    if (((fabs(distance1 - distance2) > 50 && fabs(distance1 - distance2) < 80) ||
         (fabs(distance3 - distance4) >50 && fabs(distance3 - distance4) < 80)) &&
          area > MIN_PHOTO_AREA) {
        
        _drawView.isRightStatus = YES;
        
        frameNumber ++;
        if ( 10 == frameNumber) {
            NSLog(@"拿到的帧数是多少%d",frameNumber);
            frameNumber = 0;
            return YES;
        }
        else{
            return NO;
        }
    }
    
    else{
        
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
    [self capturePictureAutomaticly];
    
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
    
    AVCaptureDevice *  device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *deviceError;
    [device lockForConfiguration:&deviceError];
    device.torchMode = AVCaptureTorchModeOn;
    [device unlockForConfiguration];
    
    //    [ADCameraHelper startRunning];
    if (self.whiteBalanceCount == 0) {
        self.whiteBalanceCount = 1;
        
        
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始实时取景
    [ADCameraHelper startRunning];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止取景
    [ADCameraHelper stopRunning];
    //改变output
    ADCameraHelper *helper = [ADCameraHelper sharedInstance];
    [helper.session removeOutput:helper.captureOutput];
    [helper.session addOutput:helper.output];
    self.whiteBalanceCount = 0;
    
    //清除绘制
    [_drawView.modelArray removeAllObjects];
    [_drawView performSelectorOnMainThread:@selector(setNeedsDisplay)
                                withObject:nil waitUntilDone:YES];
    
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
    //    [ADCameraHelper captureStillImage];
    //    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.5];
    
    // [ADCameraHelper captureStillImage];
    [ADCameraHelper captureStillImageWithBlock:^(UIImage *captureImage){
        
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
//切换镜头
- (void)toggleCamera:(UIButton *)btn
{
    btn.enabled = NO;
    [ADCameraHelper toggleCamera];
    btn.enabled = YES;
    if ([ADCameraHelper isBackFacingCamera]) {
        if ([ADCameraHelper isBackCameraSupportFlash]) {
            flashBtn.hidden = NO;
        }
    }else{
        flashBtn.hidden = YES;
    }
}
//切换闪光灯
- (void)changeFlashMode
{
    if (currentFlashMode == ISTCameraFlashModeAuto) {
        //切换到闪光灯为开
        if ([ADCameraHelper isBackCameraFlashSupportOnMode]) {
            [ADCameraHelper changeBackCameraFlashModeToOn];
            currentFlashMode = ISTCameraFlashModeOn;
        }else if ([ADCameraHelper isBackCameraFlashSupportOffMode]){
            //切换到闪光灯为关
            [ADCameraHelper changeBackCameraFlashModeToOff];
            currentFlashMode = ISTCameraFlashModeOff;
        }
    }else if (currentFlashMode == ISTCameraFlashModeOn) {
        //切换到闪光灯为关
        if ([ADCameraHelper isBackCameraFlashSupportOffMode]) {
            [ADCameraHelper changeBackCameraFlashModeToOff];
            currentFlashMode = ISTCameraFlashModeOff;
        }else if ([ADCameraHelper isBackCameraFlashSupportAutoMode]){
            //切换到闪光灯为自动
            [ADCameraHelper changeBackCameraFlashModeToAuto];
            currentFlashMode = ISTCameraFlashModeAuto;
        }
    }else if (currentFlashMode == ISTCameraFlashModeOff) {
        //切换到闪光灯为自动
        if ([ADCameraHelper isBackCameraFlashSupportAutoMode]) {
            [ADCameraHelper changeBackCameraFlashModeToAuto];
            currentFlashMode = ISTCameraFlashModeAuto;
        }else if ([ADCameraHelper isBackCameraFlashSupportOnMode]){
            //切换到闪光灯为开
            [ADCameraHelper changeBackCameraFlashModeToOn];
            currentFlashMode = ISTCameraFlashModeOn;
        }
    }
}
@end
