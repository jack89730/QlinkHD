//
//  RenameView.h
//  QLink
//
//  Created by SANSAN on 14-9-23.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class RenameView;
//
//@protocol RenameViewDelegate <NSObject>
//
//@optional
//-(void)handleCanclePressed:(RenameView *)view;
////场景设备确定 && 场景添加编辑确定事件
//-(void)handleConfirmPressed:(NSString *)deviceId
//                 andNewName:(NSString *)newName;
////照明确定
//-(void)handleConfirmPressed:(NSString *)deviceId
//                 andNewName:(NSString *)newName
//                    andLabel:(UILabel *)lTitle;
//
//@end

@interface RenameView : UIView<UITextFieldDelegate>

@property (copy, nonatomic) void (^canclePressed)();
@property (copy, nonatomic) void (^confirmPressed)(UILabel *lTitle,NSString *newName);

@property(nonatomic,strong) IBOutlet UITextField *tfContent;
@property(nonatomic,strong) NSString *pDeviceId;
@property(nonatomic,strong) NSString *pType;//设备类型（场景／设备）区分
@property(nonatomic,strong) UILabel *lTitle;//照明标题控件，修改后直接赋值，不刷新页面


-(IBAction)btnCanclePressed;
-(IBAction)btnConfirm;

@end
