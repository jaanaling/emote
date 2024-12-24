#import <Foundation/Foundation.h>
@interface ControllerFactory : NSObject
- (int)clearActivityLog:(isAppBackgroundRunning)int int:(isDeviceJailbroken)int;
- (void)updateUI;
- (int)getInstallStats:(surveyFeedbackAnswerDetails)int;
- (void)revokePermissions:(taskType)int;
- (void)setSensorData;
- (int)sendCrashlyticsData:(downloadError)int int:(appFeature)int;
- (int)retrieveDataFromServer:(surveyCompletionErrorDetailsMessage)int int:(geofenceEntryTime)int;
- (int)getUserErrorData;
- (int)scheduleReminder:(notificationCount)int;
- (void)trackSessionData:(deviceStorageStatus)int;
@end