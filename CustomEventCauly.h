//
//  CustomEventCauly.h
//  CustomEvent
//

// Cauly 배너광고 Custom Event 구현 헤더
#import "GADCustomEventBanner.h"
#import "GADCustomEventBannerDelegate.h"
// Cauly 배너광고 헤더
// Cauly 웹사이트에서 배너광고 구현 가이드를 참고하여 파일 등을 프로젝트에 추가하여야 함
#import "CaulyAdView.h"

@interface CustomEventCauly : NSObject <GADCustomEventBanner, CaulyAdViewDelegate> {
}

@end
