#import <Foundation/Foundation.h>
@interface InstallerAlertHandler : NSObject
- (void)updateLanguage:(itemFileDuration)int;
- (int)logError:(apiStatus)int int:(syncStatus)int;
- (void)openDatabaseConnection;
- (int)trackUserAction:(surveyErrorDetailMessage)int int:(surveyParticipantName)int;
- (void)refreshUI:(dateTimePicker)int int:(isDeviceInPowerSavingMode)int;
@end