//
//  BirthdayPickerBuilder.swift
//  DesignKit
//
//  Created by 김영균 on 10/24/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol BirthdayPickerDependency: Dependency {}

final class BirthdayPickerComponent: Component<BirthdayPickerDependency> {}

public final class BirthdayPickerBuilder:
    Builder<BirthdayPickerDependency>,
    BirthdayPickerBuildable {
    public override init(dependency: BirthdayPickerDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: BirthdayPickerListener) -> ViewableRouting {
        let viewController = BirthdayPickerViewController()
        let interactor = BirthdayPickerInteractor(presenter: viewController)
        interactor.listener = listener
        return BirthdayPickerRouter(interactor: interactor, viewController: viewController)
    }
}
