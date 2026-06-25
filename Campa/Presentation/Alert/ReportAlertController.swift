//
//  ReportAlertController.swift
//  Campa
//
//  Created by myfy on 2026/6/24.
//

import UIKit
import SnapKit


class ReportAlertController: UIViewController {
    
    private let alertContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let alertBgImgV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "alert_bg")
        return view
    }()
    
    private let lineView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "line_pupor")
        return view
    }()
    
    private let hotImgV: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "error_img")
        return view
    }()

    private let sureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 52/255.0, green: 4/255.0, blue: 4/255.0, alpha: 1)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor(red: 52/255.0, green: 4/255.0, blue: 4/255.0, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 215/255.0, green: 220/255.0, blue: 56/255.0, alpha: 1)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    // 按钮点击回调
    var actionHandler: (() -> Void)?
    var type: PayType = .normal
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(alertContainer)
        alertContainer.addSubview(alertBgImgV)
        alertContainer.addSubview(hotImgV)
        alertContainer.addSubview(sureButton)
        alertContainer.addSubview(cancelButton)
        alertContainer.addSubview(lineView)
        alertContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 284, height: 351))
        }
        alertBgImgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(-8)
            make.right.equalTo(-6)
        }
        
        hotImgV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(25)
            make.size.equalTo(CGSize(width: 105, height: 105))
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(-32)
            make.left.equalTo(46)
            make.right.equalTo(-46)
            make.height.equalTo(50)
        }
        
        sureButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButton.snp.top).offset(-14)
            make.left.equalTo(46)
            make.right.equalTo(-46)
            make.height.equalTo(50)
        }
        
        sureButton.addTarget(self, action: #selector(clickSureAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(clickCancelAction), for: .touchUpInside)
        if self.type == .normal {
            self.sureButton.setTitle("Sure", for: .normal)
            self.cancelButton.setTitle("Cancel", for: .normal)
        } else {
            self.sureButton.setTitle("Recharge", for: .normal)
            self.cancelButton.setTitle("Cancel", for: .normal)
        }
    }
    
    @objc func clickSureAction() {
        self.actionHandler?()
        self.dismiss(animated: false)
    }
    
    @objc func clickCancelAction() {
        self.dismiss(animated: false)
    }
}
