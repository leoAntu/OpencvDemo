//
//  FaceDetector.m
//  OpenCVExample
//
//  Created by 叮咚钱包富银 on 2018/8/8.
//  Copyright © 2018年 leo. All rights reserved.
//


#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#endif
#import "FaceDetector.h"
#import "UIImage+OpenCV.h"

//c++命名空间
using namespace cv;
using namespace std;

@interface FaceDetector ()<CvVideoCameraDelegate> {
    CascadeClassifier _faceDetector;
    vector<cv::Rect> _faceRects;
    std::vector<cv::Mat> _faceImgs;
}
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) dispatch_queue_t queue;

@end
@implementation FaceDetector

- (instancetype)initWithCameraView:(UIImageView *)cameraView scale:(CGFloat)scale {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("shibie.com", DISPATCH_QUEUE_SERIAL);
        _videoCamera = [[CvVideoCamera alloc] initWithParentView:cameraView];
        _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 30;
        self.videoCamera.grayscaleMode = NO;
        self.videoCamera.delegate = self;
        self.scale = scale;
        
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
        const CFIndex CASCADE_NAME_LEN = 2048;
        char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
        CFStringGetFileSystemRepresentation( (CFStringRef)faceCascadePath, CASCADE_NAME, CASCADE_NAME_LEN);
        //加载人脸识别特征包
        _faceDetector.load(CASCADE_NAME);
        free(CASCADE_NAME);
    }
    return self;
}

- (void)startCapture {
    [self.videoCamera start];
}

- (void)stopCapture {
    [self.videoCamera stop];
}


- (UIImage *)faceWithIndex:(NSInteger)idx {
    
    cv::Mat img = self->_faceImgs[idx];
    
    UIImage *ret = [UIImage imageFromCVMat:img];
    
    return ret;
}

- (NSArray *)detectedFaces {
    NSMutableArray *facesArray = [NSMutableArray array];
    for( vector<cv::Rect>::const_iterator r = _faceRects.begin(); r != _faceRects.end(); r++ )
    {
        CGRect faceRect = CGRectMake(_scale*r->x/480., _scale*r->y/640., _scale*r->width/480., _scale*r->height/640.);
        [facesArray addObject:[NSValue valueWithCGRect:faceRect]];
    }
    return facesArray;
}

#pragma mark -- CvVideoCameraDelegate
- (void)processImage:(cv::Mat &)image {
    [self detectAndDrawFacesOn:image scale:self.scale];
}

- (void)detectAndDrawFacesOn:(cv::Mat&) img scale:(double) scale {
  
    int i = 0;
    double t = 0;
    
    //定义随机颜色数组
    const static Scalar colors[] =  { CV_RGB(0,0,255),
        CV_RGB(0,128,255),
        CV_RGB(0,255,255),
        CV_RGB(0,255,0),
        CV_RGB(255,128,0),
        CV_RGB(255,255,0),
        CV_RGB(255,0,0),
        CV_RGB(255,0,255)} ;
    
    //设置画布绘制区域并复制
    Mat gray, smallImg( cvRound (img.rows/scale), cvRound(img.cols/scale), CV_8UC1 );
    cvtColor( img, gray, COLOR_BGR2GRAY );
    resize( gray, smallImg, smallImg.size(), 0, 0, INTER_LINEAR );
    equalizeHist( smallImg, smallImg );
    
    
    t = (double)cvGetTickCount();
    double scalingFactor = 1.1;
    int minRects = 2;
    cv::Size minSize(30,30);
    
    self->_faceDetector.detectMultiScale( smallImg, self->_faceRects,
                                         scalingFactor, minRects, 0,
                                         minSize );
    
    t = (double)cvGetTickCount() - t;
    std::vector<cv::Mat> faceImages;
    
    for( std::vector<cv::Rect>::const_iterator r = _faceRects.begin(); r != _faceRects.end(); r++, i++ )
    {
        cv::Mat smallImgROI;
        cv::Point center;
        Scalar color = colors[i%8];
        std::vector<cv::Rect> nestedObjects;
        //画框
        rectangle(img,
                  cvPoint(cvRound(r->x*scale), cvRound(r->y*scale)),
                  cvPoint(cvRound((r->x + r->width-1)*scale), cvRound((r->y + r->height-1)*scale)),
                  color, 1, 8, 0);
        smallImgROI = smallImg(*r);
        
        faceImages.push_back(smallImgROI.clone());
    }
    //可以加锁
    self->_faceImgs = faceImages;
}
@end
