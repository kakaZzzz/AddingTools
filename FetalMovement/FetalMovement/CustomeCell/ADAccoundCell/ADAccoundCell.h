//
//  ADAccoundCell.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-15.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADSwitch.h"

typedef enum {
    
    CELL_TYPE_UNKNOW = 0,
    CELL_TYPE_SINA = 2,
    CELL_TYPE_QQ = 3,
    CELL_TYPE_BAIDU
    
}CELL_TYPE;

typedef void (^SwichOnBlock)(NSInteger ADSwichIndex);
typedef void (^SwichOffBlock)(NSInteger ADSwichIndex);
@interface ADAccoundCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconImage;//行icon图
@property(nonatomic,strong)UILabel *titleLabel;//cell标题
@property(nonatomic,strong)UILabel *contentLabel;//cell标题
@property(nonatomic,strong)ADSwitch *accoundSwitch;//开关
@property(nonatomic,assign)CELL_TYPE cellType;//账户类型

@property(nonatomic,strong)SwichOnBlock swichOnBlock;
@property(nonatomic,strong)SwichOffBlock swichOffBlock;
@end
