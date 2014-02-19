//
//  BTRootViewController.m
//  OpenCVTestWangPeng
//
//  Created by wangpeng on 14-2-11.
//  Copyright (c) 2014年 wangpeng. All rights reserved.
//

#import "BTRootViewController.h"
#import "UIImage+OpenCV.h"

const int kCannyAperture = 7;
@interface BTRootViewController ()


@end

@implementation BTRootViewController

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
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = [UIColor blackColor];
   [self.view addSubview:_imageView];
    
    
    self.alphaImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320 - 100)/2, 50, 100, 100)];
    _alphaImageView.userInteractionEnabled = YES;
    _alphaImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_alphaImageView];

    self.captureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _captureButton.frame = CGRectMake((320 - 100)/2, 300, 100, 50);
    [_captureButton setTitle:@"相机" forState:UIControlStateNormal];
    [_captureButton addTarget:self action:@selector(capture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_captureButton];
    
    
    // Initialise video capture - only supported on iOS device NOT simulator
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Video capture is not supported in the simulator");
#else
    _videoCapture = new cv::VideoCapture;
    if (!_videoCapture->open(CV_CAP_AVFOUNDATION))
    {
        NSLog(@"Failed to open video camera");
    }
#endif
    
    // Load a test image and demonstrate conversion between UIImage and cv::Mat
    UIImage *testImage = [UIImage imageNamed:@"testimage.jpg"];
    
    double t;
    int times = 10;
    
    //--------------------------------
    // Convert from UIImage to cv::Mat
  //  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    t = (double)cv::getTickCount();
    
    for (int i = 0; i < times; i++)
    {
        cv::Mat tempMat = [testImage CVMat];
    }
    
    t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
    
  //  [pool release];
    
    NSLog(@"UIImage to cv::Mat: %gms", t);
    
    //------------------------------------------
    // Convert from UIImage to grayscale cv::Mat
  //  pool = [[NSAutoreleasePool alloc] init];
    
    t = (double)cv::getTickCount();
    
    for (int i = 0; i < times; i++)
    {
        cv::Mat tempMat = [testImage CVGrayscaleMat];
    }
    
    t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
    
  //  [pool release];
    
    NSLog(@"UIImage to grayscale cv::Mat: %gms", t);
    
    //--------------------------------
    // Convert from cv::Mat to UIImage
    cv::Mat testMat = [testImage CVMat];
    
    t = (double)cv::getTickCount();
    
    for (int i = 0; i < times; i++)
    {
        UIImage *tempImage = [[UIImage alloc] initWithCVMat:testMat];
       // [tempImage release];
    }
    
    t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
    
    NSLog(@"cv::Mat to UIImage: %gms", t);
    
    // Process test image and force update of UI
    _lastFrame = testMat;
    
}



// Called when the user taps the Capture button. Grab a frame and process it
- (void)capture:(UIButton *)sender
{
//        if (_videoCapture && _videoCapture->grab())
//        {
//            (*_videoCapture) >> _lastFrame;
//            self.imageView.image = [UIImage imageWithCVMat:_lastFrame];
//           // [self processFrame];
//       }
//        else
//        {
//            NSLog(@"Failed to grab frame");
//        }
    [self takePhoto];

}
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"没有相机");
        return;
    }
    
    UIImagePickerController* picker=[[UIImagePickerController alloc] init];
    
    picker.delegate=self;
    picker.allowsEditing=YES;
    picker.sourceType= sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    _lastFrame = [image CVMat];
    
    [self processFrame];
    
}

// Perform image processing on the last captured frame and display the results
- (void)processFrame
{
    using namespace cv;
    
    int lowThreshold = 100;
    int ratio = 3;
    int kernel_size = 3;
    
    
    Mat grayFrame, detFrame,output;
    
    // Convert captured frame to grayscale  灰度图
    cvtColor(_lastFrame, grayFrame,COLOR_RGB2GRAY);
    
    // Perform Canny edge detection using slide values for thresholds
    
    /// 使用 3x3内核降噪
    // cv::blur(grayFrame, output, Size(3,3));
    
//    cv::Canny(grayFrame, output,
//              50 * kCannyAperture * kCannyAperture,
//              200 * kCannyAperture * kCannyAperture,
//              kCannyAperture);
    
    
    //使用 threshold 进行二值化
   // cv::threshold(grayFrame, grayFrame, 128, 255,  CV_THRESH_BINARY_INV);
    
//    //进行膨胀处理
//    
//     cv::Mat element(7,7,CV_8U,cv::Scalar(1));
//     cv::erode(grayFrame, detFrame, element);
//    
    //使用Canny算法进行边缘检测
      cv::Canny(grayFrame, output,
                  lowThreshold,
                  lowThreshold * ratio,
                  kernel_size);
    
    
    //使用 findContours 找轮廓
   // std::vector<std::vector<Point>> contours;
    vector<vector<cv::Point>> contours;
    findContours(output, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);

    //画出轮廓

    Mat result(output.size(),CV_8U,Scalar(0));
    
    //画出轮廓，参数为：画板，轮廓，轮廓指示（这里画出所有轮廓），颜色，线粗
    drawContours(result,contours,-1,Scalar(255),2);
    
        // Display result
    self.imageView.image = [UIImage imageWithCVMat:result];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
