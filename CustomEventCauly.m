//
//  CustomEventCauly.m
//  CustomEvent
//

#import "CustomEventCauly.h"

@implementation CustomEventCauly
@synthesize delegate;

#pragma mark GADCustomEventBanner

// AdMob custom event callback. Cauly 배너광고를 요청하기 위해 AdMob이 호출해줌.
- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)customEventRequest
{

    // Cauly 배너광고 초기화 및 설정
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelAll];
    adSetting.appCode = serverParameter;
    
    // Cauly 자체 reloading 시간과 AdMob mediation reloading 시간이 달라져서 복잡해지는 문제를 해결하기 위해 Cauly reloading 시간을 최대(120초)로 설정하고 dynamic reload 설정도 제거한 후, AdMob 상에서 reload 시간을 120초보다 짧게 설정하는 것이 좋음.
    adSetting.reloadTime = CaulyReloadTime_120;
    adSetting.useDynamicReloadTime = NO;
    adSetting.animType = CaulyAnimNone;
    
    UIViewController *viewController = [self.delegate viewControllerForPresentingModalView];
    CaulyAdView *_adView = [[CaulyAdView alloc] initWithParentViewController:viewController];
    _adView.delegate = self;
    CGRect frame = _adView.frame;
    frame.origin.y = 1.0;
    _adView.frame = frame;
    [viewController.view addSubview:_adView];
    
    // Cauly 배너광고 시작 및 호출
    _adView.hidden = YES;
    [_adView startBannerAdRequest];
}

// Cauly Banner
#pragma mark - CaulyAdViewDelegate
- (void)didReceiveAd:(CaulyAdView *)adView isChargeableAd:(BOOL)isChargeableAd{
    NSLog(@"Cauly Custom Event : didReceiveAd");
#ifdef _FAILURE_TEST_
    // mediation 동작을 확인하기 위해서 임의로 광고 실패 상황을 만듬.
    if (0  == (arc4random() % 2))
    {
        [self didFailToReceiveAd:adView errorCode:-99999 errorMsg:@"failure test."];
        return;
    }
#endif
    
    // requestBannerAd에서 add했던 view를 제거.
    [adView removeFromSuperview];
    adView.hidden = NO;
    [self.delegate customEventBanner:self didReceiveAd:adView];
}

- (void)didFailToReceiveAd:(CaulyAdView *)adView errorCode:(int)errorCode errorMsg:(NSString *)errorMsg {

    NSLog(@"Cauly Custom Event : didFailToReceiveAd : %d(%@)", errorCode, errorMsg);
    
    // requestBannerAd에서 add했던 view를 제거.
    [adView removeFromSuperview];
    
    // AdMob custom event에 배너광고 요청이 실패했음을 알림.
    NSError *failedError = [NSError errorWithDomain:errorMsg code:errorCode userInfo:nil];
    [self.delegate customEventBanner:self didFailAd:failedError];
}

- (void)willShowLandingView:(CaulyAdView *)adView {
    NSLog(@"Cauly Custom Event : willShowLandingView");
    
    // AdMob custom event에 광고가 클릭되어 열리게 될 것임을 알림.
    [self.delegate customEventBanner:self clickDidOccurInAd:adView];
}

- (void)didCloseLandingView:(CaulyAdView *)adView {
    NSLog(@"Cauly Custom Event : didCloseLandingView");
    
    // AdMob custom event에 광고가 닫힘을 알림.
    [self.delegate customEventBannerDidDismissModal:self];
}
@end
