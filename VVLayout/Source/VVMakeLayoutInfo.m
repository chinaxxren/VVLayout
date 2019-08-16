//
// Created by Tank on 2019-08-15.
// Copyright (c) 2019 Tank. All rights reserved.
//

#import "VVMakeLayoutInfo.h"


@implementation VVMakeLayoutInfo

- (instancetype)initWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    self = [super init];
    if (self) {
        self.makeLayoutType = makeLayoutType;
        self.multiplied = 1.0f;
        self.viewLayoutType = VVMakeLayoutTypeNone;
    }

    return self;
}

+ (instancetype)infoWithMakeLayoutType:(VVMakeLayoutType)makeLayoutType {
    return [[self alloc] initWithMakeLayoutType:makeLayoutType];
}

@end