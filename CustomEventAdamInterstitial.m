//
//  CustomEventAdamInterstitial.m
//  CustomEvent
//

#import "CustomEventAdamInterstitial.h"

@implementation CustomEventAdamInterstitial
// Will be set by the AdMob SDK.
@synthesize delegate;

#pragma mark -
#pragma mark GADCustomEventInterstitial

// AdMob custom event callback. Cauly 전면광고를 요청하기 위해 AdMob이 호출해줌.
- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
                                     label:(NSString *)serverLabel
                                   request:(GADCustomEventRequest *)customEventRequest
{
    // AdamInterstitial 객체를 생성.
    _interstitialAd = [AdamInterstitial sharedInterstitial];
    
    // AdMob mediation UI상에 입력한 값이 serverParameter 인자로 전달됨.
    // Adam의 경우, Adam 승인 이전에는 "InterstitialTestClientId"를 지정해야 테스트가 가능.
    _interstitialAd.clientId = serverParameter;
    [_interstitialAd setDelegate:self];
    
    // 전면광고를 호출하고 노출함.
    // AdMob custom event 구현상 보여주는 것은 전면광고 요청이 성공했을 때 진행하도록 되어 있으나 Adam SDK가 호출과 노출을 하나로 처리하고 있어서 예외적으로 구현함.
    [_interstitialAd requestAndPresent];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController
{
    // AdMob custom event 구현 상 [requestInterstitialAdWithParameter:label:request:] 에서는 전면광고 요청만 하고 화면에 노출하는 것은 이 시점에 하도록 되어 있으나 Adam SDK가 지원하지 못하므로 여기서는 로그만 출력해줌.
    // 이미 [requestInterstitialAdWithParameter:label:request:] 에서 전면광고는 노출된 상태임.
    NSLog(@"presentFromRootViewController");

}

#pragma mark - AdmaInterstitial Delegate
- (void)didReceiveInterstitialAd:(AdamInterstitial *)interstitial
{
    NSLog(@"didReceiveInterstitialAd");

    // AdMob custom event에 전면광고가 성공했음을 알림.
    [self.delegate customEventInterstitial:self didReceiveAd:nil];
}

- (void)didFailToReceiveInterstitialAd:(AdamInterstitial *)interstitial error:(NSError *)error
{
    NSLog(@"didFailToReceiveInterstitialAd, error: %@", error.localizedDescription);
    
    // AdMob custom event에 전면광고가 실패했음을 알려 다음 mediation network을 호출하도록 함.
    // Adam의 경우 3분 이내 전면광고 재호출(requestAndPresent)이 발생한 경우, 실패로 간주하고 광고를 노출하지 않으므로 fail error가 발생함.
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)willOpenInterstitialAd:(AdamInterstitial *)interstitial
{
    NSLog(@"willOpenInterstitialAd");
    
    // AdMob custom event에 전면광고가 보여지기 직전임을 알림.
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)didOpenInterstitialAd:(AdamInterstitial *)interstitial
{
    // AdMob에는 전면광고가 열렸음을 따로 알리는 구현이 없으므로 로그만 출력.
    NSLog(@"didOpenInterstitialAd");
    
}

- (void)willCloseInterstitialAd:(AdamInterstitial *)interstitial
{
    NSLog(@"willCloseInterstitialAd");
    
    // AdMob custom event에 전면광고가 닫히게 될 것임을 알림.
    [self.delegate customEventInterstitialWillDismiss:self];
}


- (void)didCloseInterstitialAd:(AdamInterstitial *)interstitial
{
    NSLog(@"didCloseInterstitialAd");
    
    // AdMob custom event에 전면광고가 닫힘을 알림.
    [self.delegate customEventInterstitialDidDismiss:self];
}

- (void)willResignByInterstitialAd:(AdamInterstitial *)interstitial
{
    NSLog(@"willResignByInterstitialAd");
}

@end
