

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VVMakeBlockPriority) {
    VVMakeBlockPriorityLow,
    VVMakeBlockPriorityMiddle,
    VVMakeBlockPriorityHigh,
};

#define VVWeakify(o)   __weak   typeof(self) vvwo = o;
#define VVStrongify(o) __strong typeof(self) o = vvwo;

@interface VVMakeBlock : NSObject

+ (instancetype)makeBlockT:(dispatch_block_t)block_t priority:(VVMakeBlockPriority)priority;

@property(nonatomic) dispatch_block_t make_block_t;
@property(nonatomic) VVMakeBlockPriority priority;

@end
