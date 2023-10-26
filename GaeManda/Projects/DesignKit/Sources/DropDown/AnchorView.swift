//
//  AnchorView.swift
//  DesignKit
//
//  Created by jung on 10/22/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit

public protocol AnchorView: AnyObject {
	var plainView: UIView { get }
}

extension UIView: AnchorView {
	public var plainView: UIView { return self }
}
