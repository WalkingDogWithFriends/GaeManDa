import UIKit
import FirebaseCore
import FirebaseMessaging
import RIBs
import KakaoSDKAuth
import KakaoSDKCommon
import UseCase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	private var launchRouter: LaunchRouting?
	private var appUseCase: AppUseCase?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		configureApplication(application)
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		
		let appComponent = AppComponent()
		self.appUseCase = appComponent.appUseCase
		
		let launchRouter = AppRootBuilder(dependency: appComponent).build()
		self.launchRouter = launchRouter
		self.launchRouter?.launch(from: window)
		
		return true
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		appUseCase?.stopUpdatingLocation()
	}
	
	func application(
		_ app: UIApplication,
		open url: URL,
		options: [UIApplication.OpenURLOptionsKey : Any] = [:]
	) -> Bool {
		if (AuthApi.isKakaoTalkLoginUrl(url)) {
			_ = AuthController.handleOpenUrl(url: url)			
		}
		return true
	}
}

private extension AppDelegate {
	func configureApplication(_ application: UIApplication) {
		// 카카오 로그인 설정
		configureKaKaoLogin()
		
		// 파이어베이스 기본 설정
		configureFireBase()
		
		// 메시지 대리자 설정
		configureMessageDelegate()
	}
	
	func configureFireBase() {
		if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
			 let options = FirebaseOptions(contentsOfFile: path) {
			FirebaseApp.configure(options: options)
		} else {
			FirebaseApp.configure()
		}
	}
	
	func configureMessageDelegate() {
		Messaging.messaging().delegate = self
	}
}

private extension AppDelegate {
	func configureKaKaoLogin() {
		guard
			let infoDictionary = Bundle.main.infoDictionary,
			let kakaoAppKey = infoDictionary["KAKAO_NATIVE_APP_KEY"],
			let appKey = kakaoAppKey as? String
		else {
			return
		}
		KakaoSDK.initSDK(appKey: appKey)
	}
}


extension AppDelegate: MessagingDelegate {
	func messaging(
		_ messaging: Messaging,
		didReceiveRegistrationToken fcmToken: String?
	) {
		guard let fcmToken else { return }
		Task { @MainActor [weak self] in
			guard let self, let appUseCase = self.appUseCase else { return }
			dump("fcmToken:\(fcmToken)")
			await appUseCase.registerDeviceToken(fcmToken)
		}
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	// 앱이 포그라운드 상태일 때 푸시 알림을 받았을 때 호출되는 메소드
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification
	) async -> UNNotificationPresentationOptions {
		return [.sound, .banner, .list]
	}
	
	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {
		Messaging.messaging().apnsToken = deviceToken
	}
}
