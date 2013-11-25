//
//  CustomEventAdamInterstitial.h
//  CustomEvent
//

#import <Foundation/Foundation.h>
// AdMob 전면광고 Custom Event 구현 헤더
#import "GADCustomEventInterstitial.h"
#import "GADCustomEventInterstitialDelegate.h"
// Adam 전면광고 헤더
// Adam 웹사이트에서 전면광고 구현 가이드를 참고하여 파일 등을 프로젝트에 추가하여야 함
#import "AdamInterstitial.h"

@interface CustomEventAdamInterstitial : NSObject <GADCustomEventInterstitial, AdamInterstitialDelegate>
{
    AdamInterstitial *_interstitialAd;
}
@end
