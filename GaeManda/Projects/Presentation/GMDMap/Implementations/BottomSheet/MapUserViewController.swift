//
//  MapUserViewController.swift
//  GMDMap
//
//  Created by jung on 12/28/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import RxCocoa
import RxSwift
import SnapKit
import DesignKit
import GMDExtensions

protocol MapUserPresentableListener: AnyObject {
	func viewDidLoad()
	func dismiss()
}

final class MapUserViewController: 
	BottomSheetViewController,
	MapUserViewControllable {
	weak var listener: MapUserPresentableListener?
	private let disposeBag = DisposeBag()
	
	private var dogInfo = [MapDog]()
	
	// MARK: - UI Components
	private let upperView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 5
		view.backgroundColor = .gray60
		
		return view
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.registerCell(DogInfoCell.self)
		
		return tableView
	}()
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.dataSource = self
		
		setupUI()
		listener?.viewDidLoad()
	}
}

// MARK: - UI Methods
private extension MapUserViewController {
	func setupUI() {
		setViewHierarhcy()
		setConstraints()
		bind()
	}
	
	func setViewHierarhcy() {
		self.topBarView.addSubview(upperView)
		self.contentView.addSubviews(tableView)
	}
	
	func setConstraints() {
		upperView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.height.equalTo(6)
			make.width.equalTo(40)
			make.top.equalToSuperview().offset(7)
		}
		
		tableView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(20)
			make.leading.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
			make.bottom.equalToSuperview().offset(-30)
			make.height.equalTo(210)
		}
	}
}

// MARK: - Bind Methods
private extension MapUserViewController {
	func bind() {
		self.didDismissBottomSheet
			.bind(with: self) { owner, _ in
				owner.listener?.dismiss()
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - MapUserPresentable
extension MapUserViewController: MapUserPresentable {
	func getDogInfo(_ dogInfo: [MapDog]) {
		self.dogInfo = dogInfo
		self.tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource
extension MapUserViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dogInfo.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueCell(DogInfoCell.self, for: indexPath)
		cell.configure(with: dogInfo[indexPath.row])
		
		return cell
	}
}
