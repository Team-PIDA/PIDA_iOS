#import "NMFFoundation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 지도의 출처를 나타내는 클래스. 이 클래스의 인스턴스는 직접 생성할 수 없고 `NMFMapView.attributions`를
 이용해야 가져올 수 있습니다.
 
 @see `NMFMapView.addAttributionChangeDelegate:`
 */
NMF_EXPORT
@interface NMFAttribution : NSObject

- (instancetype)initWithName:(NSString *)name Url:(NSString *)url;

/**
 출처의 명칭
 */
@property (nonatomic, nonnull, readonly) NSString *name;

/**
 출처의 URL
 */
@property (nonatomic, nonnull, readonly) NSString *url;

@end

NS_ASSUME_NONNULL_END
