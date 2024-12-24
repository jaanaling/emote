#import <Foundation/Foundation.h>
@interface AuthenticatorBox : NSObject
- (void)setBatteryStatus;
- (int)checkEmailStatus;
- (void)logAnalyticsEvent;
- (void)sendErrorEventData:(deviceErrorLog)int;
- (int)sendPageVisitData;
- (void)getSyncStatus:(timezoneOffset)int int:(isEntityInactive)int;
- (int)getThemeMode:(menuItems)int;
- (void)clearAppFeedback:(selectedLanguageCode)int;
@end