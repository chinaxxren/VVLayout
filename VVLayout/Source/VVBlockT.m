

#import "VVBlockT.h"

@implementation VVBlockT

+ (instancetype)makeBlockT:(dispatch_block_t)block_t priority:(VVBlockPriority)priority {
    VVBlockT *blockT = [[VVBlockT alloc] init];
    blockT.block_t = block_t;
    blockT.priority = priority;
    return blockT;
}

@end
