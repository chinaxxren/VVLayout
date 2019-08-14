

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VVBlockPriority) {
    VVBlockPriorityLow,
    VVBlockPriorityMiddle,
    VVBlockPriorityHigh,
};

@interface VVBlockT : NSObject

+ (instancetype)makeBlockT:(dispatch_block_t)block_t priority:(VVBlockPriority)priority;

@property (nonatomic) dispatch_block_t block_t;
@property (nonatomic) VVBlockPriority priority;

@end
