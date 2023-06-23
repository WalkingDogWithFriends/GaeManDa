import RIBs
import UIKit

protocol ProfileSettingPresentableListener: AnyObject { }

final class ProfileSettingViewController:
	UIViewController,
	ProfileSettingPresentable,
	ProfileSettingViewControllable {
	weak var listener: ProfileSettingPresentableListener?
}
