//
//  JFTInputAccessoryProtocol.h
//  JFTKeyboard
//
//  Created by syfll on 2018/3/16.
//

#ifndef JFTInputAccessoryProtocol_h
#define JFTInputAccessoryProtocol_h

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, JFTInputAccessoryViewStyle) {
    JFTInputAccessoryViewStyleNone,
    JFTInputAccessoryViewStyleEmoji
};

@protocol JFTInputAccessoryProtocol <NSObject>
@required
@property (nonatomic, assign) JFTInputAccessoryViewStyle jft_inputAccessoryViewStyle;
- (void)jft_changeToCustomInputView:(UIView *)customView;
- (void)jft_changeToDefaultInputView;
@end

#endif /* JFTInputAccessoryProtocol_h */
