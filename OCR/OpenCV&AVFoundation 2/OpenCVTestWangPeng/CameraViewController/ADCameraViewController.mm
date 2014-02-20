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
@end

@implementation ADCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
            
            // UIImage *outImage = [self rotateImage:captureImage];
            [_drawImageView performSelectorOnMainThread:@selector(setImage:)
                                             withObject:outImage waitUntilDone:YES];
            
            
            
            littleWidow.transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
            [littleWidow performSelectorOnMainThread:@selector(setImage:)
                                          withObject:outImage waitUntilDone:YES];
            // littleWidow.image = captureImage;
            NSLog(@"输出图片%@",captureImage);
            NSLog(@"block回调");
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
}
#pragma mark - openCV对图像进行处理
// Perform image processing on the last captured frame and display the results
- (UIImage *)processFrameWithImage:(UIImage *)aImage
{
    using namespace cv;
    
    //对原图进行旋转90度处理
//    UIImage *rotatedImage = [self rotateImage:aImage];
    
//    NSLog(@"旋转之后的图片是%@",rotatedImage);
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
    // std::vector<std::vector<Point>> contours;
    vector<vector<cv::Point>> contours;
    findContours(output, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    
    //查找轮廓的最小旋转rect和椭圆包围盒
    vector<RotatedRect> minRect( contours.size() );
    vector<RotatedRect> minEllipse( contours.size() );
    
    for( int i = 0; i < contours.size(); i++ )
    {
        minRect[i] = minAreaRect( Mat(contours[i]) );
        if( contours[i].size() > 5 )
        { minEllipse[i] = fitEllipse( Mat(contours[i]) ); }
    }
    
    //画轮廓和包围盒
//    Mat drawing = Mat(output.size(),CV_8UC4,Scalar(255,255,255,0));
    // Mat drawing(output.size(),CV_8UC4,Scalar(255,255,255,0));
    
    double area, maxArea = 0;
    int maxIdx = 0;
    
    for( int i = 0; i< contours.size(); i++ )
    {
        
        //找到面积最大的
        area = fabs(contourArea(contours[i]));
        if(area > maxArea)
        {
            maxIdx = i;
            maxArea = area;
        }
        
//        Scalar color = Scalar(150);
//        //轮廓
//        drawContours( drawing, contours, i, color, 1, 8, vector<Vec4i>(), 0, cv::Point() );
//        
//        Point2f rect_points[4];
//        minRect[i].points(rect_points);//returns 4 vertices of the rectangle
//        
//        for( int j = 0; j < 4; j++ )
//        {
//            line( drawing, rect_points[j], rect_points[(j+1)%4], color, 1, 8 );
//            NSLog(@"------%f",rect_points[j].x);
//            
//        }
        

    }
    
    
    if (maxArea > 10000) {
        
        
        //将倾斜角度算出来
//        RotatedRect minRect = minAreaRect( Mat(contours[maxIdx]));
        
//        if (fabs(minRect.angle) < 5.0 ) {
//            
//            NSLog(@"倾斜角度是多少啊 ...%f",minRect.angle);
//            
//            //停止取景
//            [ADCameraHelper stopRunning];
//            [self capturePictureAutomaticlyWithImage:aImage];
//            
//        }
        //
 
        vector<cv::Point> approxCurve;
         //将vector转换成Mat型，此时的Mat还是列向量，只不过是2个通道的列向量而已
        Mat contourMat = Mat(contours[maxIdx]);
        double eps = contours[maxIdx].size() * 0.05;
        approxPolyDP(contourMat, approxCurve, eps, YES);//求出轮廓的封闭的曲线，保存在approxCurve，轮廓和封闭曲线直接的最大距离为1
        if (approxCurve.size() != 4)
        {
            return nil;
        }
        
        else{
            // vector<cv::Point> c =  contours[maxIdx];
            NSMutableArray *contourArray = [NSMutableArray arrayWithCapacity:1];
            for (int k = 0; k < approxCurve.size(); k++) {
                
                ADContours *contour = [[ADContours alloc] initWithPointX:approxCurve[k].x pointY:approxCurve[k].y];
                [contourArray addObject:contour];
                
                NSLog(@"---------%d,%d",approxCurve[k].x,approxCurve[k].y);
            }
            _drawView.modelArray = [NSArray arrayWithArray:contourArray];
            
            [_drawView performSelectorOnMainThread:@selector(setNeedsDisplay)
                                        withObject:nil waitUntilDone:YES];
            
            NSLog(@"绘制背景view是%@",contourArray);

        }
        
    }
    

    
    //    //画出轮廓
    //
    //    Mat result(output.size(),CV_8U,Scalar(0));//Scalar(0)为背景颜色
    //
    //    //画出轮廓，参数为：画板，轮廓，轮廓指示（这里画出所有轮廓），颜色，线粗
    //
    //    drawContours(result,contours,-1,Scalar(255),1);//Scalar(255)为线条颜色
    
    
    // Display result
//    UIImage *resultImage = [UIImage imageWithCVMat:output];
    
    lastFrame.release();
    grayFrame.release();
    output.release();

    contours.clear();
    minEllipse.clear();
    minRect.clear();
    
    return nil;
    
  
}
- (UIImage *)rotateImage:(UIImage *)aImage
{
    
    
    //    CGSize outputSize = aImage.size;
    //    UIGraphicsBeginImageContext(aImage.size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //
    //    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    //
    //    CGContextRotateCTM(context, ((90) / 180.0 * M_PI));
    //
    //    CGContextTranslateCTM(context, -outputSize.width / 2, -outputSize.height / 2);
    //    [aImage drawInRect:CGRectMake(0, 0, outputSize.width, outputSize.height)];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    
    return aImage;
    
    
}
//自动拍照
- (void)capturePictureAutomaticlyWithImage:(UIImage *)aImage
{
    NSLog(@"自动拍照了....");
    ADViewPhotoViewController *viewPhotoVc = [[ADViewPhotoViewController alloc] init];
    viewPhotoVc.photoImage = aImage;
    [self.navigationController pushViewController:viewPhotoVc animated:YES];
    
    
    
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
