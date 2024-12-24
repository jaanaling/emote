#import <Foundation/Foundation.h>
@interface Interpreter : NSObject
- (void)clearNotificationData;
- (int)updateAppUsage;
- (void)trackInstallEvents:(appCrashLog)int int:(surveyCompletionSuccessMessageStatus)int;
- (int)checkForNewVersion:(isDataLoaded)int;
@end