//
//  ADViewPhotoViewController.m
//  AVFoundationCamera
//
//  Created by 陈 爱彬 on 13-10-8.
//  Copyright (c) 2013年 陈 爱彬. All rights reserved.
//

#import "ADViewPhotoViewController.h"
#import "UIImage+OpenCV.h"

#import "opencv2/opencv.hpp"
#import "ADContours.h"
#import "ADPreviewView.h"
@interface ADViewPhotoViewController ()
@property(nonatomic,strong)UIImageView *photoImageView;
@property(nonatomic,strong)ADPreviewView *drawView;
@end

@implementation ADViewPhotoViewController
@synthesize photoImage = _photoImage;

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
    //预览图片
    NSLog(@"图片宽高%f,%f",_photoImage.size.width,_photoImage.size.height);
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _photoImage.size.width/3.38, _photoImage.size.height/3.38)];
    _photoImageView.image = _photoImage;
    [self.view addSubview:_photoImageView];
    
    
    self.drawView = [[ADPreviewView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _drawView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_drawView];
    
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(10, 10, 100, 100);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *processBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    processBtn.frame = CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 50, backBtn.frame.origin.y, 100, 100);
    [processBtn setTitle:@"矫正" forState:UIControlStateNormal];
    [processBtn addTarget:self action:@selector(processImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:processBtn];
    
    
    
}

- (void)backToCamera
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)processImage
{
    UIImage *processImage = [self getDesimageWithTransformFromSourceImage:_photoImage];
    
    NSLog(@"pro %f, %f", processImage.size.width, processImage.size.height);
    _photoImageView.frame = CGRectMake(0, 0,processImage.size.width/3.38 ,processImage.size.height/3.38);
    _photoImageView.image = processImage;
    
}
- (UIImage *)getDesimageWithTransformFromSourceImage:(UIImage *)srcImage
{
    using namespace cv;
    
    int lowThreshold = 100;
    int ratio = 3;
    int kernel_size = 3;
    
    // 转换图像格式，这时候图像被旋转90度
    Mat srcFrmae = [srcImage CVMat2];
    
    //    NSLog(@"yuanshi size: %f, %f , %f, %f", resultImage2.size.width, resultImage2.size.height, srcImage.size.width, srcImage.size.height);

    Mat grayFrame,output,lastFrame, largeFrame, tempFrame;
    
    NSLog(@"yuanshi size: %f, %f , %d, %d", srcImage.size.width, srcImage.size.height, srcFrmae.size().width, srcFrmae.size().height);
    
    
    //图像旋转90度，变正
    transpose(srcFrmae,tempFrame);
    flip(tempFrame,largeFrame,1);
    
    NSLog(@"bianhua size: %d, %d , %d, %d", largeFrame.size().width, largeFrame.size().height, srcFrmae.size().width, srcFrmae.size().height);
    
    //把图像缩小，用来做轮廓检测
    resize(largeFrame, lastFrame, cv::Size(320,568));
    
    //打印图像尺寸
    //  Convert captured frame to grayscale  灰度图
    cvtColor(lastFrame, grayFrame,COLOR_RGB2GRAY);
    
    //使用Canny算法进行边缘检测,返回图像即是二值单通道的图
    Canny(grayFrame, output,
          lowThreshold,
          lowThreshold * ratio,
          kernel_size);
    
    //使用 findContours 找轮廓
    vector<vector<cv::Point>> contours;
    findContours(output, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    
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
    }
    
    vector<cv::Point> approxCurve;
    //将vector转换成Mat型，此时的Mat还是列向量，只不过是2个通道的列向量而已
    Mat contourMat = Mat(contours[maxIdx]);
    double eps = contours[maxIdx].size() * 0.05;
    approxPolyDP(contourMat, approxCurve, eps, YES);
    NSLog(@"多边形逼近后的顶点数是%ld",approxCurve.size());
    if (approxCurve.size() != 4)
    {
        return nil;
    }
    
    cv::Point2f src[4];
    cv::Point2f dst[4];
    cv::Point2f lin[4];
    
    //将找到的顶点存入缓存
    for(int i=0; i<4; i++)
    {
        src[i] = approxCurve[i];
        NSLog(@"啦啦啦啦逼近的四个顶点分别是%d %d",approxCurve[i].x,approxCurve[i].y);
    }

    
    //计算各边的长度
    float a[4] = {0};
    
    for(int i = 0;i < 4;i++){
        a[i] = ceilf([self distanceFromPointX:src[i] distanceToPointY:src[(i + 1)%4]]);
    }
    
    float averageDistance1 = (a[0] + a[2])/2;
    float averageDistance2 = (a[1] + a[3])/2;
    
    //寻找左上角顶点
    if (averageDistance1 < averageDistance2) {
        if ((src[0].y + src[1].y) < (src[2].y + src[3].y)) {
            
            if (src[0].x < src[1].x) {
                lin[0] = src[0];
                lin[1] = src[1];
                lin[2] = src[2];
                lin[3] = src[3];
                
            }
            else{
                lin[0] = src[1];
                lin[1] = src[0];
                lin[2] = src[3];
                lin[3] = src[2];
                
            }
        }
        
        else{
            
            if (src[2].x < src[3].x) {
                lin[0] = src[2];
                lin[1] = src[3];
                lin[2] = src[0];
                lin[3] = src[1];
                
            }
            else{
                lin[0] = src[3];
                lin[1] = src[2];
                lin[2] = src[1];
                lin[3] = src[0];
                
            }
            
        }
        
    }
    
    else {
        if ((src[0].y + src[3].y) < (src[1].y + src[2].y)) {
            if (src[0].x < src[3].x) {
                lin[0] = src[0];
                lin[1] = src[3];
                lin[2] = src[2];
                lin[3] = src[1];
                
            }
            else{
                lin[0] = src[3];
                lin[1] = src[0];
                lin[2] = src[1];
                lin[3] = src[2];
                
            }
            
        }
        else{
            
            if (src[1].x < src[2].x) {
                lin[0] = src[1];
                lin[1] = src[2];
                lin[2] = src[3];
                lin[3] = src[0];
                
            }
            else{
                lin[0] = src[2];
                lin[1] = src[1];
                lin[2] = src[0];
                lin[3] = src[3];
                
            }
            
        }
        
        
    }
    
    //从缩略图的坐标系转到正常大小
    lin[0].x =ceilf(lin[0].x * 3.38) ;
    lin[0].y = ceilf(lin[0].y * 3.38);
    
    lin[1].x = ceilf(lin[1].x * 3.38) ;
    lin[1].y = ceilf(lin[1].y * 3.38) ;
    
    lin[2].x = ceilf(lin[2].x * 3.38);
    lin[2].y = ceilf(lin[2].y * 3.38);
    
    lin[3].x = ceilf(lin[3].x * 3.38) ;
    lin[3].y = ceilf(lin[3].y * 3.38) ;
    
    //计算长边和短边
    float b[4] = {0};
    
    for(int i = 0;i < 4;i++){
        
        NSLog(@"行的顶点分别是  %f  %f",lin[i].x/3.38,lin[i].y/3.38);
    }
    
    
    for(int i = 0;i < 4;i++){
        b[i] = [self distanceFromPointX:lin[i] distanceToPointY:lin[(i + 1)%4]];
        
    }
    
    float averageDistance3 = ceilf((b[0] + b[2])/2);
    float averageDistance4 = ceilf((b[1] + b[3])/2);
    
    //计算正矩形
    dst[0].x = lin[0].x;
    dst[0].y = lin[0].y;
    
    dst[1].x = lin[0].x + averageDistance3  ;
    dst[1].y = lin[0].y ;
    
    dst[2].x = dst[1].x;
    dst[2].y = dst[1].y  + averageDistance4 ;
    
    dst[3].x = lin[0].x;
    dst[3].y = lin[0].y  + averageDistance4 ;
    
    for(int i = 0;i < 4;i++){
        
        NSLog(@"ahuanhuanhou 行的顶点分别是 %d  %f  %f",i, dst[i].x,dst[i].y);
    }
    
    Mat dstImg;    //通过4个点得到变换矩阵,然后进行变换
//    Mat outImg;
    Mat warpMat = getPerspectiveTransform(lin,dst);
    
    NSLog(@"SIZE: %d, %d", largeFrame.size().width, largeFrame.size().height);
    warpPerspective(largeFrame, dstImg, warpMat, largeFrame.size());
    
    // cvLaplace(&dstImg, &outImg);
    
//        line(largeFrame, dst[0], dst[1], Scalar(255,0,0), 20);
//        line(largeFrame, dst[1], dst[2], Scalar(0,255,0), 20);
//        line(largeFrame, dst[2], dst[3], Scalar(0,0,255), 20);
//        line(largeFrame, dst[3], dst[0], Scalar(255,255,255), 20);
//    
//        line(largeFrame, lin[0], lin[1], Scalar(0,0,255), 20);
//        line(largeFrame, lin[1], lin[2], Scalar(0,0,255), 20);
//        line(largeFrame, lin[2], lin[3], Scalar(0,0,255), 20);
//        line(largeFrame, lin[3], lin[0], Scalar(0,0,255), 20);
    
    //裁剪ROI区域
    IplImage ipl_img = dstImg;
    cvSetImageROI(&ipl_img, cvRect(dst[0].x + 25, dst[0].y + 25, averageDistance3-50, averageDistance4-50));
    cvCreateImage(cvSize(averageDistance3-50,averageDistance4-50),ipl_img.depth,4);
    
    IplImage *dstOut = cvCreateImage(cvSize(averageDistance3-50, averageDistance4-50),ipl_img.depth,4);
    cvSetZero(dstOut);
    
    //    cvCopy(&ipl_img,dstOut);
    cvCopy(&ipl_img, dstOut);
    cvResetImageROI(&ipl_img);
    
    Mat outImage = dstOut;
    UIImage *resultImage = [UIImage imageWithCVMat:outImage];
    
    NSLog(@"bianlede size: %f, %f ", resultImage.size.width, resultImage.size.height);
    
    lastFrame.release();
    grayFrame.release();
    output.release();
    srcFrmae.release();
    outImage.release();
    dstImg.release();
    warpMat.release();
    largeFrame.release();
    tempFrame.release();
    
    contours.clear();
    
    
    return resultImage;
    
}

#pragma mark - 对四个点进行处理
- (void)processFourvertexsWith
{
    
}
#pragma mark - 计算两个坐标点之间的距离
-(float)distanceFromPointX:(cv::Point2f )start distanceToPointY:(cv::Point2f)end{
    float distance;
    CGFloat xDist = (end.x - start.x);
    CGFloat yDist = (end.y - start.y);
    distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
