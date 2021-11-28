//
//  ExamView.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import UIKit

protocol ExamViewDelegate {
    func showExamResultView(finalGradeString: String, finishTimeString: String)
    func showExamDurationEndedDialog()
}

enum NavigationButtonType {
    case previous, next, pageNumber
}

enum RightButtonType {
    case next, submit
}

class ExamView: UIView {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var currentPageNumberLabel: UILabel!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    var examViewModel: ExamViewModel? {
        didSet {
            setCurrentPageNumberLabel()
            setupButtons()
            setupTableFooterView()
        }
    }
    var delegate: ExamViewDelegate?
    var examTimer: Timer?
    var pageNumbersStackView: PageNumbersStackView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        
        guard let footerView = tableView.tableFooterView else { return }
        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
            tableView.tableFooterView = footerView
        }
    }
    
    func commonInit() {
        let view = Bundle(for: ExamView.self).loadNibNamed("\(ExamView.self)", owner: self)?.first as! UIView
        addSubView(view, constrainedTo: self)
        viewInit()
    }
    
    func viewInit() {
        setupExamTimer()
        buttonsInit()
        tableViewInit()
    }
    
    func setupExamTimer() {
        examTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func buttonsInit() {
        previousButton.clipsToBounds = true
        previousButton.layer.cornerRadius = 10
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 10
    }
    
    func tableViewInit() {
        tableView.sectionHeaderTopPadding = 0
        tableView.register(QuestionCell.nib(), forCellReuseIdentifier: QuestionCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func viewRefresh(for navigationButtonType: NavigationButtonType, chosenPage: Int = 0) {
        
        if navigationButtonType == .next {
            examViewModel?.nextPage()
        } else if navigationButtonType == .previous {
            examViewModel?.previousPage()
        } else {
            examViewModel?.setPage(chosenPage)
        }
        updateExamHeaderView(for: navigationButtonType)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func updateExamHeaderView(for navigationButtonType: NavigationButtonType) {
        
        setCurrentPageNumberLabel()
        guard let examViewModel = examViewModel else { return }
        let currentPage = examViewModel.currentPage
        let lastPage = examViewModel.lastPage
        
        if navigationButtonType == .next {
            
            if currentPage == lastPage {
                toggleRightButton(for: .submit)
            }
            if currentPage == 1 {
                // previous button become visible inside the stackview.
                previousButton.alpha = 1
            }
        }
        else if navigationButtonType == .previous {
            
            if currentPage == lastPage - 1 {
                toggleRightButton(for: .next)
            }
            if currentPage == 0 {
                // previous button become invisible inside the stackview.
                previousButton.alpha = 0
            }
        }
        else {
            currentPage != lastPage ? toggleRightButton(for: .next) : toggleRightButton(for: .submit)
            previousButton.alpha = currentPage > 0 ? 1 : 0
        }
    }
    
    func setupTableFooterView() {
        
        let footerView = UIView()
        pageNumbersStackView = PageNumbersStackView()
        pageNumbersStackView?.delegate = self
        pageNumbersStackView?.addPageNumberButtons(numberOfPages: examViewModel?.numberOfPages ?? 0)
        
        let examNavigationLabel = UILabel()
        examNavigationLabel.textAlignment = .left
        examNavigationLabel.numberOfLines = 0
        examNavigationLabel.font = UIFont.systemFont(ofSize: 28)
        examNavigationLabel.minimumScaleFactor = 0.5
        examNavigationLabel.text = "  Exam Navigation: "
        
        footerView.addSubview(examNavigationLabel)
        examNavigationLabel.translatesAutoresizingMaskIntoConstraints = false
        examNavigationLabel.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true
        examNavigationLabel.heightAnchor.constraint(equalTo: footerView.heightAnchor, multiplier: 0.3).isActive = true
        
        footerView.addSubview(pageNumbersStackView ?? PageNumbersStackView())
        pageNumbersStackView?.translatesAutoresizingMaskIntoConstraints = false
        pageNumbersStackView?.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        pageNumbersStackView?.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        pageNumbersStackView?.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true
        pageNumbersStackView?.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
        pageNumbersStackView?.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true
        let heightConstraint = pageNumbersStackView?.heightAnchor.constraint(equalTo: footerView.heightAnchor, multiplier: 0.7)
        heightConstraint?.priority = UILayoutPriority(999)
        heightConstraint?.isActive = true
        footerView.backgroundColor = .systemGray6
        tableView.tableFooterView = footerView
    }
 
    func setCurrentPageNumberLabel() {
        currentPageNumberLabel.text = examViewModel?.currentPageString ?? "No pages."
    }
    
    func setupButtons() {
        previousButton.alpha = 0
        guard let examViewModel = examViewModel else { return }
        examViewModel.currentPage != examViewModel.lastPage ? toggleRightButton(for: .next) : toggleRightButton(for: .submit)
    }
    
    func toggleRightButton(for rightButtonType: RightButtonType) {
        if rightButtonType == .next {
            nextButton.isHidden = false
            submitButton.isHidden = true
        } else {
            nextButton.isHidden = true
            submitButton.isHidden = false
        }
    }
    
    func showExamResultView() {
        delegate?.showExamResultView(finalGradeString: examViewModel?.finalGradeString ?? "No grade.", finishTimeString: examViewModel?.finishTimeString ?? "No finish time.")
    }

    func tryAgain() {
        setupButtons()
        setupExamTimer()
        tableView.reloadData()
    }
    
    @IBAction func didPreviousTapped(_ sender: Any) {
        viewRefresh(for: .previous)
        pageNumbersStackView?.setButtonSelection(buttonIndex: examViewModel?.currentPage ?? 0)
    }
    
    @IBAction func didNextTapped(_ sender: Any) {
        viewRefresh(for: .next)
        pageNumbersStackView?.setButtonSelection(buttonIndex: examViewModel?.currentPage ?? 0)
    }
    
    @IBAction func didSubmitTapped(_ sender: Any) {
        examTimer?.invalidate()
        showExamResultView()
    }
    
    @objc func fireTimer() {
        if (examViewModel?.duration ?? 0) <= 0 {
            examTimer?.invalidate()
            delegate?.showExamDurationEndedDialog()
        } else {
            timeRemainingLabel.text = examViewModel?.timeRemainingString ?? "No remaining time."
        }
    }
}


extension ExamView: UITableViewDataSource,  UITableViewDelegate {
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let examViewModel = examViewModel else { return 0 }
        
        if examViewModel.questionCellViewModels.count % examViewModel.numberOfQuestionsPerPage == 0 {
            return examViewModel.numberOfQuestionsPerPage
        } else {
            return examViewModel.currentPage != examViewModel.lastPage ?  examViewModel.numberOfQuestionsPerPage :  examViewModel.questionCellViewModels.count % examViewModel.numberOfQuestionsPerPage
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as? QuestionCell {
            
            guard let examViewModel = examViewModel else { return QuestionCell() }
            let questionCellViewModelRowDataIndex = indexPath.row + (examViewModel.currentPage * examViewModel.numberOfQuestionsPerPage)
            
            let questionCellViewModel = examViewModel.questionCellViewModels[questionCellViewModelRowDataIndex]
            cell.questionCellViewModel = questionCellViewModel
            cell.configure()
            return cell
        }
        return QuestionCell()
    }
    
    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 110))
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 12))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
}


// MARK: - Page Numbers Stack View Delegate
extension ExamView: PageNumbersStackViewDelegate {
    
    func navigatetTo(chosenPage: Int) {
        viewRefresh(for: .pageNumber, chosenPage: chosenPage)
    }
}
