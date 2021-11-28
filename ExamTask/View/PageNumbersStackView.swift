//
//  PagesNumbersStackView.swift
//  ExamTask
//
//  Created by ahmed on 23/11/2021.
//

import UIKit

protocol PageNumbersStackViewDelegate {
    func navigatetTo(chosenPage: Int)
}

class PageNumbersStackView: UIStackView {

    var delegate: PageNumbersStackViewDelegate?
    var pageNumberButtons: [UIButton] {
        let pageNumberButtonsStackViews = subviews.compactMap{$0 as? UIStackView}
        var pageNumberButtons: [UIButton] = []
        for pageNumberButtonsStackView in pageNumberButtonsStackViews {
            let buttons = pageNumberButtonsStackView.subviews.compactMap { $0 as? UIButton }
            pageNumberButtons.append(contentsOf: buttons)
        }
        return pageNumberButtons
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        axis = .vertical
        alignment = .center
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 50, left: 10, bottom: 10, right: 10)
        spacing = 5
    }
    
    func addPageNumberButtons(numberOfPages: Int) {
        
        var i = 0
        let numberOfPageNumberButtonsStackViews =
            Int(ceil(Double(numberOfPages) / Double(NUMBER_OF_PAGE_NUMBER_BUTTONS_IN_STACK_VIEW)))
        while i < numberOfPageNumberButtonsStackViews {
            
            let startFrom = i * NUMBER_OF_PAGE_NUMBER_BUTTONS_IN_STACK_VIEW + 1
            let endAt =  numberOfPages - startFrom < NUMBER_OF_PAGE_NUMBER_BUTTONS_IN_STACK_VIEW ? numberOfPages + 1 :
                         startFrom + NUMBER_OF_PAGE_NUMBER_BUTTONS_IN_STACK_VIEW
            let pageNumberButtonsStackView = getPageNumberButtonsStackView(startFrom: startFrom, endAt: endAt)
    
            addArrangedSubview(pageNumberButtonsStackView)
            pageNumberButtonsStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            pageNumberButtonsStackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
            pageNumberButtonsStackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
            i += 1
        }
    }
    
    func getPageNumberButtonsStackView(startFrom: Int, endAt: Int) -> UIStackView {
        
        let pageNumberButtonsStackView = UIStackView()
        pageNumberButtonsStackView.axis = .horizontal
        pageNumberButtonsStackView.alignment = .fill
        pageNumberButtonsStackView.distribution = .fillEqually
        pageNumberButtonsStackView.spacing = 10
        
        for i in startFrom..<endAt {
            let pageNumberButton = UIButton()
            pageNumberButton.setTitle("\(i)", for: .normal)
            pageNumberButton.setTitleColor(.tintColor, for: .normal)
            pageNumberButton.layer.cornerRadius = 5
            pageNumberButton.backgroundColor = UIColor(red: 0.50588, green: 0.73725, blue: 1.0, alpha: 1.0)
            
            // button number one
            if i == 1 {
                pageNumberButton.isEnabled = false
                pageNumberButton.backgroundColor = .white
            }
            
            pageNumberButton.addTarget(self, action: #selector(didPageNumberTapped), for: .touchUpInside)
            pageNumberButtonsStackView.addArrangedSubview(pageNumberButton)
        }
        return pageNumberButtonsStackView
    }
    
    func clearButtonSelection() {
        
        let pageNumberString = pageNumberButtons.filter { $0.isEnabled == false }.first?.titleLabel?.text
        let pageNumber = Int(pageNumberString ?? "")
        
        if let pageNumber = pageNumber {
            let index = pageNumber - 1
            pageNumberButtons[index].isEnabled = true
            pageNumberButtons[index].backgroundColor = UIColor(red: 0.50588, green: 0.73725, blue: 1.0, alpha: 1.0)
        }
    }
    
    func setButtonSelection(buttonIndex: Int) {
        clearButtonSelection()
        pageNumberButtons[buttonIndex].isEnabled = false
        pageNumberButtons[buttonIndex].backgroundColor = .white
    }
    
    @objc func didPageNumberTapped(button: UIButton) {
        clearButtonSelection()
        button.isEnabled = false
        button.backgroundColor = .white
        delegate?.navigatetTo(chosenPage: (Int(button.titleLabel?.text ?? "") ?? 1) - 1)
    }
}
