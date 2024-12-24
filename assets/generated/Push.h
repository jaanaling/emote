#import <Foundation/Foundation.h>
@interface Push : NSObject
- (void)checkUserStatus:(bluetoothSignalStrength)int;
- (int)clearUserReport:(locationServiceStatus)int int:(isConnected)int;
- (int)logActivity:(lastActionTimestamp)int int:(isFileDownloading)int;
- (void)getReminderDetails;
- (void)signOutUser:(surveyCompletionDeadline)int;
- (void)setUserEmail;
- (int)setLanguage:(surveyAnswerReviewStatusCompletionTimeText)int;
- (void)updateSettings:(isAppInForeground)int int:(isAppUpdateRequired)int;
- (int)revokePermission;
- (void)checkPermissions:(geofenceStatus)int int:(alertDialogTitle)int;
- (int)trackAnalyticsEvent;
- (int)sendCrashData:(isEntityInProgress)int;
@end