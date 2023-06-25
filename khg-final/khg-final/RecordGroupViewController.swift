import UIKit
import FSCalendar

class RecordGroupViewController: UIViewController {
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var recordGroupTableView: UITableView!
    
    var recordGroup: RecordGroup! // RecordGroup 객체
    var selectedDate: Date? = Date() // 선택된 날짜

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 데이터 소스 및 델리게이트 설정
        recordGroupTableView.dataSource = self
        recordGroupTableView.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.delegate = self

        // RecordGroup 객체 초기화
        recordGroup = RecordGroup(parentNotification: receivingNotification)
        recordGroup.queryData(date: selectedDate!)
        
        // "수정" 버튼 생성
        let leftBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editingRecords1))
        navigationItem.leftBarButtonItem = leftBarButtonItem

        // "+" 버튼 생성
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addingRecord1))

        // 유산소 버튼 생성
        let cardioButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(goToCardio))
        
        // 히스토그램 버튼 생성
        let histogButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(goToHistogram))

        // 두 버튼을 네비게이션 바 오른쪽에 추가
        navigationItem.rightBarButtonItems = [addButton, cardioButton, histogButton]

        // 기본적으로 검정색으로 설정
        fsCalendar.appearance.weekdayTextColor = UIColor.black
        // 일요일의 색상을 빨간색으로 설정
        fsCalendar.appearance.titleWeekendColor = UIColor.red
    }

    // 알림 수신 시 호출되는 메서드
    func receivingNotification(record: Record?, action: DbAction?){
        self.recordGroupTableView.reloadData() // 테이블 뷰 리로드
        fsCalendar.reloadData() // 캘린더 리로드
    }
    
    // "Edit" 버튼 액션
    @IBAction func editingRecords(_ sender: UIButton) {
        if recordGroupTableView.isEditing == true{
            recordGroupTableView.isEditing = false
            sender.setTitle("수정", for: .normal)
        } else{
            recordGroupTableView.isEditing = true
            sender.setTitle("수정 완료", for: .normal)
        }
    }
    
    // "AddRecord" 세그를 수행하는 메서드
    @IBAction func addingRecord(_ sender: UIButton) {
        performSegue(withIdentifier: "AddRecord", sender: self)
    }
    
    // "GoToCardio" 세그를 수행하는 메서드
    @IBAction func goToCardio(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToCardio", sender: self)
    }
    
    // "GoToHistogram" 세그를 수행하는 메서드
    @IBAction func goToHistogram(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToHistogram", sender: self)
    }
}

// 네비게이션 바 버튼 액션 및 세그 관련 메서드
extension RecordGroupViewController {
    // "Edit" 버튼 액션 (네비게이션 바)
    @IBAction func editingRecords1(_ sender: UIBarButtonItem) {
        if recordGroupTableView.isEditing == true {
            recordGroupTableView.isEditing = false
            sender.title = "수정"
        } else {
            recordGroupTableView.isEditing = true
            sender.title = "수정 완료"
        }
    }
    
    // "AddRecord" 세그를 수행하는 메서드 (네비게이션 바)
    @IBAction func addingRecord1(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddRecord", sender: self)
    }
}

// 테이블 뷰 데이터 소스
extension RecordGroupViewController: UITableViewDataSource {
    // 섹션 내 행의 개수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recordGroup = recordGroup {
            return recordGroup.getRecords(date:selectedDate).count
        }
        
        return 0
    }
    
    // 특정 행에 대한 셀을 반환하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell")!
        let record = recordGroup.getRecords(date:selectedDate)[indexPath.row]
        
        // 유산소 운동의 경우
        if record.content.contains("&&&") {
            if let range = record.content.range(of: "&&&") {
                let exerciseSubstring = record.content[..<range.lowerBound]
                let contentSubstring = record.content[range.upperBound...]
                (cell.contentView.subviews[0] as! UILabel).text = String(exerciseSubstring)
                (cell.contentView.subviews[1] as! UILabel).text = String(contentSubstring)
                (cell.contentView.subviews[2] as! UILabel).isHidden = true
                (cell.contentView.subviews[3] as! UILabel).isHidden = true
                (cell.contentView.subviews[4] as! UILabel).isHidden = true
                (cell.contentView.subviews[5] as! UILabel).isHidden = true
                (cell.contentView.subviews[6] as! UILabel).isHidden = true
                (cell.contentView.subviews[7] as! UILabel).isHidden = true
            }
        }
        // 근력 운동의 경우
        else {
            (cell.contentView.subviews[2] as! UILabel).isHidden = false
            (cell.contentView.subviews[3] as! UILabel).isHidden = false
            (cell.contentView.subviews[4] as! UILabel).isHidden = false
            (cell.contentView.subviews[5] as! UILabel).isHidden = false
            (cell.contentView.subviews[6] as! UILabel).isHidden = false
            (cell.contentView.subviews[7] as! UILabel).isHidden = false
            
            (cell.contentView.subviews[0] as! UILabel).text = record.exercise.toString()
            (cell.contentView.subviews[1] as! UILabel).text = record.content
            (cell.contentView.subviews[2] as! UILabel).text = record.weight
            (cell.contentView.subviews[4] as! UILabel).text = record.repetitions
            (cell.contentView.subviews[6] as! UILabel).text = record.sets
        }
        
        return cell
    }
}

// 테이블 뷰 델리게이트
extension RecordGroupViewController: UITableViewDelegate {
    // 셀이 선택되었을 때 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 셀이 선택되기 직전에 호출되는 메서드
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let record = recordGroup.getRecords(date:selectedDate)[indexPath.row]
           
        // 유산소 운동이라면 nil 반환
        if record.content.contains("&&&") {
            return nil
        }
           
        // 그렇지 않은 경우 원래의 indexPath 반환
        return indexPath
    }
    
    // 셀의 편집 스타일을 처리하는 메서드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let record = self.recordGroup.getRecords(date:selectedDate)[indexPath.row]
            let title = record.content
            let message = "정말 운동 기록을 삭제하시겠습니까?"

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                let record = self.recordGroup.getRecords(date:self.selectedDate)[indexPath.row]
                self.recordGroup.saveChange(record: record, action: .Delete)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // 셀의 위치를 이동할 때 호출되는 메서드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let from = recordGroup.getRecords(date:selectedDate)[sourceIndexPath.row]
        let to = recordGroup.getRecords(date:selectedDate)[destinationIndexPath.row]
        
        recordGroup.changeRecord(from: from, to: to)
        tableView.reloadData()
    }
}

// 세그 관련 메서드
extension RecordGroupViewController {
    // 세그 전환 직전에 호출되는 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecord" {
            let recordDetailViewController = segue.destination as! RecordDetailViewController
            recordDetailViewController.saveChangeDelegate = saveChange
            
            if let row = recordGroupTableView.indexPathForSelectedRow?.row {
                recordDetailViewController.record = recordGroup.getRecords(date:selectedDate)[row].clone()
            }
        }
        
        if segue.identifier == "AddRecord" {
            let recordDetailViewController = segue.destination as! RecordDetailViewController
            recordDetailViewController.saveChangeDelegate = saveChange
            recordDetailViewController.record = Record(date:selectedDate, withData: false)
            recordGroupTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        }
        
        if segue.identifier == "GoToCardio" {
            let cardioViewController = segue.destination as! CardioViewController
               cardioViewController.selectedDate = selectedDate
        }
        
        if segue.identifier == "GoToHistogram" {
            let histogramViewController = segue.destination as! HistogramViewController
            histogramViewController.current = fsCalendar.currentPage
        }
    }

    // 변경 내용을 저장하는 메서드
    func saveChange(record: Record) {
        if recordGroupTableView.indexPathForSelectedRow != nil {
            recordGroup.saveChange(record: record, action: .Modify)
        } else{
            recordGroup.saveChange(record: record, action: .Add)
        }
    }
}

// FSCalendar 델리게이트 및 데이터 소스
extension RecordGroupViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 캘린더에서 날짜를 선택했을 때 호출되는 메서드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        recordGroup.queryData(date: selectedDate!)
        print("날짜 선택")
    }
    
    // 캘린더의 현재 페이지가 변경되었을 때 호출되는 메서드
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        selectedDate = calendar.currentPage
        recordGroup.queryData(date: selectedDate!)
    }
    
    // 캘린더에 표시될 이미지를 결정하는 메서드
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let records = recordGroup.getRecords(date: date)
        if records.count > 0 {
            let originalImage = UIImage(named: "stamp")!
            let scaledImage = resizeImage(image: originalImage, targetSize: CGSize(width: 20, height: 20)) // 원하는 크기를 지정
            return scaledImage
        }
        return nil
    }
}

// 캘린더에 표시될 이미지의 사이즈를 조정하는 메서드
func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let scalingFactor = widthRatio < heightRatio ? widthRatio : heightRatio
    let newSize = CGSize(width: size.width * scalingFactor, height: size.height * scalingFactor)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
