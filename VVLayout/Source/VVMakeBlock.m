

#import "VVMakeBlock.h"

@implementation VVMakeBlock

+ (instancetype)makeBlockT:(dispatch_block_t)block_t priority:(VVMakeBlockPriority)priority {
    VVMakeBlock *blockT = [[VVMakeBlock alloc] init];
    blockT.make_block_t = block_t;
    blockT.priority = priority;
    return blockT;
}

@end
