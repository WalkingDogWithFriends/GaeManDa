import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import Entity
import GMDUtils

protocol TermsOfUsePresentableListener: AnyObject {
	func confirmButtonDidTap()
}

final class TermsOfUseViewController:
	UIViewController,
	TermsOfUsePresentable,
	TermsOfUseViewControllable {
	// MARK: - Properties
	weak var listener: TermsOfUsePresentableListener?
	private let disposeBag = DisposeBag()
	
	// MARK: - UI Components
	private let onBoardingView = OnBoardingView(title: "아래 약관에 동의해주세요!")
	
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
	
	private let confirmButton: UIButton = {
		let button = UIButton()
		button.setTitle("확인", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .green100
		button.titleLabel?.font = .b16
		
		return button
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
				owner.agreeAllButton.isChecked.toggle()
				owner.setAllButton(to: owner.agreeAllButton.isChecked)
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
				let cell = owner.tableView.cellForRow(TermsOfUseCell.self, at: indexPath)
				cell.toggleButtonChecked()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Inner Action Methods
private extension TermsOfUseViewController {
	func setAllButton(to isChecked: Bool) {
		tableView.visibleCells.forEach {
			guard let cell = $0 as? TermsOfUseCell else { return }
			cell.setButtonChecked(isChecked)
		}
	}
}
