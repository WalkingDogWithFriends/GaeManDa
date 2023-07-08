import UIKit
import RIBs
import RxCocoa
import RxSwift
import Entity
import Utils

protocol TermsOfUsePresentableListener: AnyObject {
	func confirmButtonDidTap()
}

final class TermsOfUseViewController:
	UIViewController,
	TermsOfUsePresentable,
	TermsOfUseViewControllable {
	weak var listener: TermsOfUsePresentableListener?
	private let disposeBag = DisposeBag()
	
	private let onBoardingView: OnBoardingView = {
		let onBoardingView = OnBoardingView(
			willDisplayImageView: false,
			title: "아래 약관에 동의해주세요!"
		)
		onBoardingView.translatesAutoresizingMaskIntoConstraints = false
		onBoardingView.backgroundColor = .red
		
		return onBoardingView
	}()
	
	private let agreeAllButton: TermsOfUseButton = {
		let button = TermsOfUseButton(title: "약관 전체 동의")
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .init(hexCode: "#F4F4F4")
		
		return button
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(
			TermsOfUseCell.self,
			forCellReuseIdentifier: TermsOfUseCell.identifier
		)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 46
		tableView.separatorStyle = .none
		
		return tableView
	}()
	
	private let confirmButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("확인", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 4
		button.backgroundColor = .init(hexCode: "65BF4D")
		button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
		
		return button
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		setupSubviews()
		setConstraints()
		bind()
	}
	
	private func setupSubviews() {
		view.addSubview(onBoardingView)
		view.addSubview(agreeAllButton)
		view.addSubview(tableView)
		view.addSubview(confirmButton)
	}
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
			onBoardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			onBoardingView.topAnchor.constraint(equalTo: view.topAnchor),
			
			agreeAllButton.topAnchor.constraint(equalTo: onBoardingView.bottomAnchor, constant: 300),
			agreeAllButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			agreeAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			
			tableView.topAnchor.constraint(equalTo: agreeAllButton.bottomAnchor, constant: 10),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			tableView.bottomAnchor.constraint(greaterThanOrEqualTo: confirmButton.topAnchor),
			
			confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
			confirmButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}
	
	private func bind() {
		confirmButton.rx.tap
			.bind { [weak self] _ in
				self?.listener?.confirmButtonDidTap()
			}
			.disposed(by: disposeBag)
		
		agreeAllButton.checkButton.rx.tap
			.bind { [weak self] _ in
				self?.agreeAllButton.isChecked.toggle()
			}
			.disposed(by: disposeBag)
		
		Observable.of(termsOfUses)
			.bind(to: tableView.rx.items(
				cellIdentifier: TermsOfUseCell.identifier,
				cellType: TermsOfUseCell.self
			)) { (_, element: TermsOfUse, cell: TermsOfUseCell) in
				cell.configuration(element)
				cell.checkBoxButtonTap
					.subscribe(
						onNext: { _ in
							cell.termsOfUseButton.isChecked.toggle()
							let selectedType = cell.termsOfUseButton.isChecked
						}
					)
					.disposed(by: cell.disposeBag)
			}
			.disposed(by: disposeBag)
	}
	
	// UI때문에 잠시 구현해놓은거 입니다.
	private let termsOfUses = [
		TermsOfUse(
			title: "이용약관 동의",
			isRequired: true
		),
		TermsOfUse(
			title: "개인정보 수집 및 이용 동의",
			isRequired: true
		),
		TermsOfUse(
			title: "위치정보 수집 및 이용 동의",
			isRequired: true
		),
		TermsOfUse(
			title: "마케팅 정보 수신 동의",
			isRequired: false,
			subTitle: "다양한 소식 및 프로모션 정보를 보내 드립니다."
		)
	]
}
