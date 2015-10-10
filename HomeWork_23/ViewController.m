#import "ViewController.h"

@interface ViewController ()
@property (weak,  nonatomic)  UIImageView* testViewImage;
@property (assign, nonatomic) CGFloat testViewRotation;
@property (assign, nonatomic) CGFloat testViewScale;

@property (strong, nonatomic) NSArray* images;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGPoint point = CGPointMake(self.view.center.x, self.view.center.y);
    CGSize  size  = CGSizeMake(494 , 360);
   
    self.images = [[NSArray alloc] init];
    
    self.testViewImage = [self imageName:8 positionPictures:point andSizeImage:size];
    [self.testViewImage startAnimating];
    
    
    // Одиночный Тап
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    // Двойной Тап
    UITapGestureRecognizer* tapDoubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tapDoubleGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapDoubleGesture];
    
    // Свайп в право
    UISwipeGestureRecognizer* rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    // Свайп в лево
    UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    
    UIRotationGestureRecognizer* rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [self.view addGestureRecognizer:rotateGesture];
    
    
}

-(void) handlePinch:(UIPinchGestureRecognizer*) pinchGesture {

    
    if (pinchGesture.state == UIGestureRecognizerStateBegan)
        self.testViewScale = 1.f;
    
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.testViewScale;
    
    CGAffineTransform currentTransform = self.testViewImage.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.testViewImage.transform = newTransform;
    
    self.testViewScale = pinchGesture.scale;

}


-(void) handleRotate:(UIRotationGestureRecognizer*) rotateGesture {

    
    if (rotateGesture.state == UIGestureRecognizerStateBegan) {
        self.testViewRotation = 0;
    }
    
    CGFloat newRotation = rotateGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentTransform = self.testViewImage.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotation);
    
    self.testViewImage.transform = newTransform;
    
    self.testViewRotation = rotateGesture.rotation;
    
}


-(void) handleDoubleTap:(UITapGestureRecognizer*) tapGesture {

    [self.testViewImage stopAnimating];
    self.testViewImage.image = [self.images objectAtIndex: 0];
    
}


-(void) handleRightSwipe:(UISwipeGestureRecognizer*) swipeGesture {

  //[self runSwipeAnimation:self.testViewImage duration:1.3 rotations:M_PI*2];

  [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
      self.testViewImage.transform = CGAffineTransformRotate(self.testViewImage.transform, M_PI);
  } completion:^(BOOL finished) {
      
      [self handleRightSwipe: swipeGesture];
  }];
}

-(void) handleLeftSwipe:(UISwipeGestureRecognizer*) swipeGesture {
    
    [self runSwipeAnimation:self.testViewImage duration:1.3 rotations:-(M_PI*2)];
}



-(void) runSwipeAnimation:(UIView*) view duration:(CGFloat) duration rotations:(CGFloat) rotations {
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue  = [NSNumber numberWithFloat:rotations];
    rotationAnimation.duration = duration;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}


-(void) handleTap:(UITapGestureRecognizer*) tapGesture {
    
    [UIView animateKeyframesWithDuration:1.3
                                   delay:0
                                 options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                              animations:^{
                                  
                                  self.testViewImage.center = [tapGesture locationInView:self.view];
                                  
                              } completion:^(BOOL finished) {
                                  NSLog(@"Все готово начальник !");
                              }];
}



-(UIImageView*) imageName:(NSInteger) howManyPictures positionPictures:(CGPoint) position andSizeImage:(CGSize) size {
    
    UIImageView* view     = [[UIImageView alloc] initWithFrame:CGRectMake(position.x, position.y, size.width, size.height)];
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    //for (NSInteger i=0; i<=howManyPictures ; i++) {
    for (NSInteger i=1; i<=howManyPictures ; i++) {
   
//        UIImage* img = [UIImage imageNamed: [NSString stringWithFormat:@"%i.gif",i]];
        UIImage* img = [UIImage imageNamed: [NSString stringWithFormat:@"%i.tiff",i]];

        [array addObject:img];
    }
    // что бы при остановке картинка не исчезала ))
    self.images = array;
    
    view.center            = position;
    view.animationImages   = array;
    view.animationDuration = 1.f;
    
    [self.view addSubview:view];
    
    view.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
