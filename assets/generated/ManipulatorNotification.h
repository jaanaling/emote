#import <Foundation/Foundation.h>
@interface ManipulatorNotification : NSObject
- (void)saveSessionData:(surveyAnswerSelected)int;
- (int)updateLaunchTime;
- (void)setUserSessionDetails:(isActive)int;
- (int)updateExternalData;
- (void)resetUserActivityData:(appSettings)int int:(isChecked)int;
- (int)initializeAppState:(isValidEmail)int int:(surveyAnswerReviewStatusCompletionTimeText)int;
- (void)getThemeMode;
- (void)setAppEventData:(isLocationServiceRunning)int;
- (void)updateUserSessionDetails:(adminPermissionsStatus)int;
- (void)checkAppUpdate;
- (int)checkDeviceStorage;
- (int)logAppCrash:(itemTrackInfo)int;
- (void)checkNetworkConnection:(geofenceError)int int:(screenSize)int;
- (int)clearScreenViewData:(surveyStatusMessage)int;
- (int)checkPermission;
@end