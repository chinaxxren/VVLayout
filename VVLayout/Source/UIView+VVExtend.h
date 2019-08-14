

#import <UIKit/UIKit.h>

/*!
 * @typedef VVRelationType
 * @brief A list of relations.
 */
typedef NS_ENUM(NSInteger, VVRelationType) {
    VVRelationTypeWidth,
    VVRelationTypeWidthTo,
    VVRelationTypeHeight,
    VVRelationTypeHeightTo,
    VVRelationTypeLeft,
    VVRelationTypeRight,
    VVRelationTypeTop,
    VVRelationTypeBottom,
    VVRelationTypeCenterX,
    VVRelationTypeCenterY
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (VVExtend)

/**
 *  Current relation type for configuration.
 */
@property(nonatomic, readonly) VVRelationType relationType;

@property(nonatomic, readonly) UIView *vv_width;
@property(nonatomic, readonly) UIView *vv_height;
@property(nonatomic, readonly) UIView *vv_left;
@property(nonatomic, readonly) UIView *vv_right;
@property(nonatomic, readonly) UIView *vv_top;
@property(nonatomic, readonly) UIView *vv_bottom;
@property(nonatomic, readonly) UIView *vv_centerX;
@property(nonatomic, readonly) UIView *vv_centerY;

@end

NS_ASSUME_NONNULL_END
