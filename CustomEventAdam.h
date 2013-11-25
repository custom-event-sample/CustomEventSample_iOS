//
//  CustomEventAdam.h
//  CustomEvent
//

// AdMob 배너광고 Custom Event 구현 헤더
#import "GADCustomEventBanner.h"
#import "GADCustomEventBannerDelegate.h"
// Adam 배너광고 헤더
// Adam 웹사이트에서 배너광고 구현 가이드를 참고하여 파일 등을 프로젝트에 추가하여야 함
#import "AdamAdView.h"

@interface CustomEventAdam : NSObject <GADCustomEventBanner, AdamAdViewDelegate>
{
}
@end
