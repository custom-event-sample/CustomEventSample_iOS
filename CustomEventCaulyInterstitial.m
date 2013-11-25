//
//  CustomEventCaulyInterstitial.m
//  CustomEvent
//

#import "CustomEventCaulyInterstitial.h"

@implementation CustomEventCaulyInterstitial
// Will be set by the AdMob SDK.
@synthesize delegate;

#pragma mark -
#pragma mark GADCustomEventInterstitial

// AdMob custom event callback. Cauly 전면광고를 요청하기 위해 AdMob이 호출해줌.
- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
                                     label:(NSString *)serverLabel
                                   request:(GADCustomEventRequest *)customEventRequest
{
    CaulyAdSetting * adSetting = [CaulyAdSetting globalSetting];
    [CaulyAdSetting setLogLevel:CaulyLogLevelAll];
    // AdMob mediation UI상에 입력한 값이 serverParameter 인자로 전달됨.
    adSetting.appCode = serverParameter;
    
    // Cauly의 경우 초기화할 때 view controller를 지정해야 하므로 appliaction의 root view controller를 얻어오기 위한 코드를 추가.
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    // view controller에 null을 지정한 경우 에러가 발생하고 광고를 불러오지 못함.
    _interstitialAd = [[CaulyInterstitialAd alloc] initWithParentViewController:rootViewController];
    
    _interstitialAd.delegate = self; // 전면 delegate 설정
    [_interstitialAd startInterstitialAdRequest]; // Cauly 전면광고 요청

}

// AdMob custom event callback.
// AdMob SDK의 [GADInterstitial presentFromRootViewController:]가 호출될 때 실행됨.
- (void)presentFromRootViewController:(UIViewController *)rootViewController
{
    NSLog(@"presentFromRootViewController");
    _interstitialAd.parentController = rootViewController;
    
    // show를 호출하지 않으면 전면광고가 보여지지 않음.
    [_interstitialAd show];
}

#pragma mark - CaulyInterstitialAdDelegate

// Cauly 전면광고 정보 수신 성공
- (void)didReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd isChargeableAd:(BOOL)isChargeableAd
{
    NSLog(@"didReceiveInterstitialAd");
    
    // AdMob custom event에 전면광고가 성공했음을 알림
    [self.delegate customEventInterstitial:self didReceiveAd:interstitialAd];
}

// Cauly 전면광고가 닫혔을 때
- (void)didCloseInterstitialAd:(CaulyInterstitialAd *)interstitialAd
{
    NSLog(@"didCloseInterstitialAd");
    
    // AdMob custom event에 전면광고가 닫힘을 알림
    [self.delegate customEventInterstitialDidDismiss:self];
}

// Cauly 전면광고가 보여지기 직전
- (void)willShowInterstitialAd:(CaulyInterstitialAd *)interstitialAd
{
    NSLog(@"willShowInterstitialAd");
    
    // AdMob custom event에 전면광고가 보여지기 직전임을 알림
    [self.delegate customEventInterstitialWillPresent:self];
}

// Cauly 광고 정보 수신 실패
- (void)didFailToReceiveInterstitialAd:(CaulyInterstitialAd *)interstitialAd errorCode:(int)errorCode
                              errorMsg:(NSString *)errorMsg
{
    NSLog(@"didFailToReceiveInterstitialAd : %d(%@)", errorCode, errorMsg);
    
    // AdMob custom event에 전면광고가 실패했음을 알려 다음 mediation network을 호출하도록 함
    NSError *failedError = [NSError errorWithDomain:errorMsg code:errorCode userInfo:nil];
    [self.delegate customEventInterstitial:self didFailAd:failedError];
}
@end
