
#import <Foundation/Foundation.h>
#import "UIView+VVExtend.h"

@interface VVBlockTInfo : NSObject

@property (nonatomic, readonly) VVRelationType relationType;

@property (nonatomic, nullable, readonly) id first;
@property (nonatomic, nullable, readonly) id second;
@property (nonatomic, nullable, readonly) id third;
@property (nonatomic, nullable, readonly) id fourth;

+ (nullable instancetype)infoWithType:(VVRelationType)type parameters:(nullable id)first, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface VVBlockTInfo (ObjectSubscripting)

- (nullable id)objectAtIndexedSubscript:(NSUInteger)idx;

@end
