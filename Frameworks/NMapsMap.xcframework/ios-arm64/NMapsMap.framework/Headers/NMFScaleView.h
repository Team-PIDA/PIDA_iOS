#import <UIKit/UIKit.h>

#import "NMFFoundation.h"

NS_ASSUME_NONNULL_BEGIN

@class NMFMapView;

/**
 축척 바 컨트롤.
 */
NMF_EXPORT
@interface NMFScaleView : UIView

/**
 이 컨트롤과 연결할 지도 객체. `nil`일 경우 컨트롤이 동작하지 않습니다.
 
 기본값은 `nil`입니다.
 */
@property (nonatomic, weak, nullable) NMFMapView *mapView;

/**
 축척 바의 너비에 대한 `NSLayoutConstraint` 객체.
 */
@property (nonatomic, weak, nullable) IBOutlet NSLayoutConstraint *scaleBarWidthConstraint;

/**
 오른쪽 정렬이 활성화되어 있는지 여부. 활성화되면 오른쪽에 0이, 왼쪽에 축척이 표시됩니다.
 
 기본값은 `NO`입니다.
 */
@property (nonatomic, assign) BOOL rightToLeftEnabled;

@end

NS_ASSUME_NONNULL_END
