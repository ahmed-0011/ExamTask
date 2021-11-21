//
//  ExamView.swift
//  ExamTask
//
//  Created by ahmed on 14/11/2021.
//

import UIKit

protocol ExamViewDelegate {
    func showExamResultView(finalGradeString: String)
}

enum PageType {
    case previous, next
}

class ExamView: UIView {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var currentPageNumberLabel: UILabel!
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    var examViewModel: ExamViewModel! {
        didSet {
            setCurrentPageNumberLabel()
            // hide the next button and show the submit button if there is only one page
            if examViewModel.currentPage == examViewModel.lastPage {
                nextButton.isHidden = true
                submitButton.isHidden = false
            }
        }
    }
    var delegate: ExamViewDelegate?
    var examTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        viewInit()
    }
    
    func commonInit() {
        let view = Bundle(for: ExamView.self).loadNibNamed("\(ExamView.self)", owner: self)?.first as! UIView
        addSubView(view, constrainedTo: self)
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
        previousButton.alpha = 0
        previousButton.clipsToBounds = true
        previousButton.layer.cornerRadius = 10
        
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = false
        
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 10
    }

    func tableViewInit() {
        tableView.sectionHeaderTopPadding = 0
        tableView.register(QuestionCell.nib(), forCellReuseIdentifier: QuestionCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func viewRefresh(for pageType: PageType) {
        
        if pageType == .next {
            examViewModel.nextPage()
        } else {
            examViewModel.previousPage()
        }
        updateExamHeaderView(for: pageType)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    func updateExamHeaderView(for pageType: PageType) {
        setCurrentPageNumberLabel()
        let currentPage = examViewModel.currentPage
        
        if pageType == .previous {
            if currentPage == examViewModel.lastPage - 1{
                nextButton.isHidden = false
                submitButton.isHidden = true
            }
            else if currentPage == 0 {
                // previous button become invisible inside the stackview.
                previousButton.alpha = 0
            }
        }
        else {
            if currentPage == examViewModel.lastPage {
                nextButton.isHidden = true
                submitButton.isHidden = false
            }
            else if examViewModel.currentPage == 1 {
                // previous button become visible inside the stackview.
                previousButton.alpha = 1
            }
        }
    }
    
    func setCurrentPageNumberLabel() {
        currentPageNumberLabel.text = examViewModel.currentPageString
    }
    
    func showExamResultView() {
        delegate?.showExamResultView(finalGradeString: examViewModel.finalGradeString)
    }

    func tryAgain() {
        previousButton.alpha = 0
        // hide the submit button and show the next buton if there is more than one page
        if examViewModel.currentPage != examViewModel.lastPage {
            nextButton.isHidden = false
            submitButton.isHidden = true
        }
        setupExamTimer()
        tableView.reloadData()
    }
    
    @IBAction func didPreviousTapped(_ sender: Any) {
        viewRefresh(for: .previous)
    }
    
    @IBAction func didNextTapped(_ sender: Any) {
        viewRefresh(for: .next)
    }
    
    @IBAction func didSubmitTapped(_ sender: Any) {
        examTimer?.invalidate()
        showExamResultView()
    }
    
    @objc func fireTimer() {
        if examViewModel.duration <= 0 {
            examTimer?.invalidate()
            showExamResultView()
        } else {
            timeRemainingLabel.text = examViewModel.timeRemainingString
        }
    }
}


extension ExamView: UITableViewDataSource,  UITableViewDelegate {
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examViewModel.numberOfQuestionsPerPage
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: QuestionCell.identifier) as? QuestionCell {
            
            let questionCellViewModelRowDataIndex = indexPath.row + (examViewModel.currentPage * examViewModel.numberOfQuestionsPerPage);
            
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
}
