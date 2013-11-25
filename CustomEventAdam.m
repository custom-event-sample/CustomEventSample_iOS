//
//  CustomEventAdam.m
//  CustomEvent
//

#import "CustomEventAdam.h"

@implementation CustomEventAdam
@synthesize delegate;

#pragma mark GADCustomEventBanner
// AdMob custom event callback. Adam 배너광고를 요청하기 위해 AdMob이 호출해줌.
- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)customEventRequest
{
    UIViewController *viewController = [self.delegate viewControllerForPresentingModalView];
 
    NSLog(@"Adam Custom Event : requestBannerAd with %@", serverParameter);
    
    AdamAdView *_adView = [AdamAdView sharedAdView];
    if (![_adView.superview isEqual:viewController.view])
    {
        // Adam 배너광고의 경우 320x48 사이즈로 애드몹과는 세로 사이즈에 차이가 있음.
        // 320x50 가운데 정렬을 위해 y position을 1.0으로 지정.
        _adView.frame = CGRectMake(0.0, 1.0, 320.0, 48.0);
        [viewController.view addSubview:_adView];
    }
    _adView.delegate = self;
    _adView.clientId = serverParameter;
    
    // AdMob에서 refresh 주기를 관리하도록 Adam 자체 광고 refresh는 막아둠.
    if (_adView.usingAutoRequest) [_adView stopAutoRequestAd];
    
    // Adam AdView의 경우 requestAd를 하면 바로 광고가 노출되므로 광고 호출 후에 hidden 처리하여 노출을 막고 실제 광고가 수신되었을 때 보이게 함.
    _adView.hidden = YES;
    [_adView requestAd];
    
}

// Adam Banner
#pragma mark - AdamAdViewDelegate
- (void)didReceiveAd:(AdamAdView *)adView
{
    NSLog(@"Adam Custom Event : Received");
    
#ifdef _FAILURE_TEST_
    // mediation 동작을 확인하기 위해서 임의로 광고 실패 상황을 만듬.
    if (0  == (arc4random() % 2))
    {
        NSError *failTestError = [NSError errorWithDomain:@"failure test." code:-99999 userInfo:nil];
        [self didFailToReceiveAd:adView error:failTestError];
        return;
    }
#endif
    // requestBannerAd에서 add했던 view를 제거함.
    [adView removeFromSuperview];
    adView.hidden = NO;
    
    // 배너광고 view를 AdMob mediation으로 전달.
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)didFailToReceiveAd:(AdamAdView *)adView error:(NSError *)error
{
    NSLog(@"Adam Custom Event : didFailToReceiveAd : %@", error);
    
    // requestBannerAd에서 add했던 view를 제거함.
    [adView removeFromSuperview];
    
    // AdMob custom event에 배너광고 요청이 실패했음을 알림.
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)willOpenFullScreenAd:(AdamAdView *)adView
{
    NSLog(@"Adam Custom Event : will open");
    
    // AdMob custom event에 광고가 클릭되어 열리게 될 것임을 알림.
    [self.delegate customEventBanner:self clickDidOccurInAd:adView];
}
@end
