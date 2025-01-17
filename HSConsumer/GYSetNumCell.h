//
//  GYSetNumCell.h
//  HSConsumer
//
//  Created by 00 on 14-12-23.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYSetNumCellDelegate <NSObject>

-(void)retNum:(NSInteger)Num;



@end


@interface GYSetNumCell : UITableViewCell<UITextFieldDelegate>

@property (assign, nonatomic) NSInteger num;

@property (weak, nonatomic) IBOutlet UILabel *lbNum;//购买数量

@property (weak, nonatomic) IBOutlet UIButton *btnCut;//减少按钮

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;//增加按钮

@property (weak, nonatomic) IBOutlet UITextField *tfNum;//数字输入框


@property (assign , nonatomic) id<GYSetNumCellDelegate> delegate;
//@property (nonatomic,assign) NSInteger goodsNum;//商品的库存总数
@property (nonatomic,assign) NSInteger maxGoodsNum;//商品的库存总数
@end
