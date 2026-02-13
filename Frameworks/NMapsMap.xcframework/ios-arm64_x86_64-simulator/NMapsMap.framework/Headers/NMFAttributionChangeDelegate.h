#import "NMFFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 지도 데이터 출처 변경에 대한 콜백 프로토콜.
 
 @see `NMFMapView.addAttributionChangeDelegate:
 @see `NMFMapView.removeAttributionChangeDelegate:
 */
@protocol NMFAttributionChangeDelegate <NSObject>

/**
 화면에 보이는 지도 데이터의 출처가 변경되면 호출되는 콜백 메서드.
 */
- (void)attributionChanged;

@end

NS_ASSUME_NONNULL_END
