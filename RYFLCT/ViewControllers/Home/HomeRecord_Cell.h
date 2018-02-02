//
//  HomeRecord_Cell.h
//  RYFLCT
//
//  Created by admin on 02/02/18.
//  Copyright © 2018 Tops. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRecord_Cell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewRecord;
@property (weak, nonatomic) IBOutlet UITextView *tvRecordDetails;
@property (weak, nonatomic) IBOutlet UIView *viewRecordProgress;
@property (weak, nonatomic) IBOutlet UISlider *progressRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnObjRecordPlay;
@property (weak, nonatomic) IBOutlet UILabel *lblRecordTime;
@property (weak, nonatomic) IBOutlet UIButton *btnObjRecordShare;


@end
