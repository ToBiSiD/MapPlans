//
//  AnnotationCalloutView.swift
//  MapPlans
//
//  Created by Tobias on 03.08.2023.
//

import Foundation
import UIKit
import MapKit

protocol AnnotationCalloutDelegate {
    func openPlacePlans()
    func addPlan()
    func moveToPlace()
}

class AnnotationCalloutView : UIView {
    private let listButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private let walkButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private let annotation: MKAnnotation
    
    var delegate : AnnotationCalloutDelegate?
    
    init(annotation: MKAnnotation) {
        self.annotation = annotation
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let views = ["calloutView": self]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[calloutView(40)]", options: [], metrics: nil, views: views))
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setupButton(button: listButton, imageTitle: "checklist")
        setupButton(button: addButton, imageTitle: "plus")
        setupButton(button: walkButton, imageTitle: "figure.walk")
        
        setupButtonsActions()
        setupConstraints()
    }
    
    private func setupButton(button : UIButton, imageTitle : String) {
        let image = UIImage(systemName: imageTitle,withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        button.backgroundColor = .systemBlue
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10.0
        
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButtonsActions() {
        listButton.addTarget(self, action: #selector(self.openPlacePlansTapped(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(self.openAddPlanTapped(_:)), for: .touchUpInside)
        walkButton.addTarget(self, action: #selector(self.goToPlaceTapped(_:)), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        
        setupConstraintsForButton(listButton, leadeingAnchor: self.leadingAnchor)
        setupConstraintsForButton(addButton, leadeingAnchor: listButton.trailingAnchor)
        setupConstraintsForButton(walkButton, leadeingAnchor: addButton.trailingAnchor)
    }
    
    private func setupConstraintsForButton(_ button : UIButton, leadeingAnchor : NSLayoutXAxisAnchor){
        let paddingConstant: CGFloat = 12
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.leadingAnchor.constraint(equalTo: leadeingAnchor ,constant: paddingConstant),
            button.heightAnchor.constraint(equalToConstant: 35),
            button.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    
    @objc func openPlacePlansTapped(_ sender : UIButton) {
        delegate?.openPlacePlans()
    }
    
    @objc func openAddPlanTapped(_ sender : UIButton) {
        delegate?.addPlan()
    }
    
    @objc func goToPlaceTapped(_ sender : UIButton) {
        delegate?.moveToPlace()
    }
}
