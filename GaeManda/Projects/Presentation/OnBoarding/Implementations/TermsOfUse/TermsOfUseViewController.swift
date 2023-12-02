import CoreLocation
import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDUtils

protocol TermsOfUsePresentableListener: AnyObject {
	func a약관전체동의ButtonDidTap()
	func a이용약관동의ButtonDidTap()
	func a개인정보수집및이용동의ButtonDidTap()
	func a위치정보수집및이용동의DidTap()
	func a마케팅정보수신동의DidTap()
	func confirmButtonDidTap()
}

final class TermsOfUseViewController:
	UIViewController,
	TermsOfUseViewControllable {
	// MARK: - Properties
	weak var listener: TermsOfUsePresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private let onBoardingView = OnBoardingView(viewMode: .default, title: "아래 약관에 동의해주세요!")
	
	private let agreeAllButton: TermsOfUseButton = {
		let button = TermsOfUseButton(title: "약관 전체 동의")
		button.backgroundColor = .gray30
		
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.registerCell(TermsOfUseCell.self)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 46
		tableView.separatorStyle = .none
		tableView.isScrollEnabled = false
		
		return tableView
	}()
	
	private let confirmButton: ConfirmButton = {
		let button = ConfirmButton(title: "확인")
		button.isPositive = false
		return button
	}()
	
	private let locationManager: CLLocationManager = {
		let locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		return locationManager
	}()
	// MARK: - Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
}

// MARK: - UI Methods
private extension TermsOfUseViewController {
	func setupUI() {
		view.backgroundColor = .white
		setViewHierarchy()
		setConstraints()
		bind()
	}
	
	func setViewHierarchy() {
		view.addSubviews(onBoardingView, agreeAllButton, tableView, confirmButton)
	}
	
	func setConstraints() {
		onBoardingView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(72)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
		}
		
		agreeAllButton.snp.makeConstraints { make in
			make.bottom.equalTo(tableView.snp.top).offset(-12)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(44)
		}
		
		tableView.snp.makeConstraints { make in
			make.height.equalTo(192)
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalTo(confirmButton.snp.top).offset(-32)
		}
		
		confirmButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(32)
			make.trailing.equalToSuperview().offset(-32)
			make.bottom.equalToSuperview().offset(-54)
			make.height.equalTo(40)
		}
	}
	
	func bind() {
		confirmButton.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		agreeAllButton.rx.tapGesture()
			.when(.recognized)
			.bind(with: self) { owner, _ in
				owner.listener?.a약관전체동의ButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		Observable.of(TermsOfUse.data)
			.bind(to: tableView.rx.items(cellType: TermsOfUseCell.self)) { _, element, cell in
				cell.configuration(element)
			}
			.disposed(by: disposeBag)
		
		// 약관 선택 시 처리할 뷰 로직은 아래에 구현하면 됩니다.
		tableView.rx.itemSelected
			.bind(with: self) { owner, indexPath in
				switch indexPath.row {
				case 0: owner.listener?.a이용약관동의ButtonDidTap()
				case 1: owner.listener?.a개인정보수집및이용동의ButtonDidTap()
				case 2: owner.listener?.a위치정보수집및이용동의DidTap()
				case 3:	owner.listener?.a마케팅정보수신동의DidTap()
				default:
					return
				}
			}
			.disposed(by: disposeBag)
	}
}

extension TermsOfUseViewController: TermsOfUsePresentable {
	func set약관전체동의Button(isChecked: Bool) {
		agreeAllButton.isChecked = isChecked
	}
	
	func set이용약관동의Button(isChecked: Bool) {
		let cell = tableView.cellForRow(TermsOfUseCell.self, at: IndexPath(row: 0, section: 0))
		cell.setButtonChecked(isChecked)
	}
	
	func set개인정보수집및이용동의Button(isChecked: Bool) {
		let cell = tableView.cellForRow(TermsOfUseCell.self, at: IndexPath(row: 1, section: 0))
		cell.setButtonChecked(isChecked)
	}
	
	func set위치정보수집및이용동의Button(isChecked: Bool) {
		let cell = tableView.cellForRow(TermsOfUseCell.self, at: IndexPath(row: 2, section: 0))
		cell.setButtonChecked(isChecked)
	}
	
	func set마케팅정보수신동의Button(isChecked: Bool) {
		let cell = tableView.cellForRow(TermsOfUseCell.self, at: IndexPath(row: 3, section: 0))
		cell.setButtonChecked(isChecked)
	}
	
	func setConfirmButton(isEnabled: Bool) {
		self.confirmButton.isUserInteractionEnabled = isEnabled
		self.confirmButton.isPositive = isEnabled
	}
}
