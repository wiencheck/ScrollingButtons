import UIKit

/**
 View that can display multiple buttons.
 */
public class ScrollingButtonsView: UIView {
    
    public var buttons: [UIButton] {
        _buttons.map(\.button)
    }
    
    public var layoutConfiguration = LayoutConfiguration() {
        didSet { collectionView.collectionViewLayout.invalidateLayout() }
    }
    
    private var _buttons: [ButtonStorage] = [] {
        didSet { reloadCollectionView() }
    }
    
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        cv.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        cv.allowsSelection = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    public var scrollView: UIScrollView {
        collectionView
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    public func addButton(_ button: UIButton) {
        _buttons.append(
            .init(button: button)
        )
    }
    
    public func insertButton(_ button: UIButton, at index: Int) {
        _buttons.insert(
            .init(button: button),
            at: index
        )
    }
    
    public func removeButton(_ button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else {
            assertionFailure("Given button was not found in")
            return
        }
        _buttons.remove(at: index)
    }
    
    @discardableResult
    public func removeButton(at index: Int) -> UIButton? {
        guard _buttons.indices.contains(index) else {
            assertionFailure("Given button was not found in")
            return nil
        }
        return _buttons.remove(at: index).button
    }
    
}

public extension ScrollingButtonsView {
    
    struct LayoutConfiguration {
        public var sectionInsets: UIEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        public var interItemSpacing: CGFloat = 8
        public var shouldCenterItems: Bool = true
    }
    
}

private extension ScrollingButtonsView {
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, ButtonStorage>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, ButtonStorage>
    
    func makeDataSource() -> DataSource {
        let ds = DataSource(collectionView: collectionView) { collectionView, indexPath, storage in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            )
            let button = storage.button
            button.frame = cell.contentView.bounds
            button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(button)
            
            return cell
        }
        
        return ds
    }
    
    func reloadCollectionView(animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(["buttons"])
        snapshot.appendItems(_buttons)
        
        dataSource.apply(
            snapshot,
            animatingDifferences: animated
        )
    }
    
    func commonInit() {
        addSubview(collectionView)
        collectionView.frame = bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}

extension ScrollingButtonsView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let size = CGSize(
            width: buttons[indexPath.item].intrinsicContentSize.width,
            height: collectionView.bounds.height - layoutConfiguration.sectionInsets.top - layoutConfiguration.sectionInsets.bottom
        )
        
        return size
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return layoutConfiguration.interItemSpacing
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let contentWidth: CGFloat = buttons.reduce(0) { width, button in
            width + button.intrinsicContentSize.width
        }
                
        var insets = layoutConfiguration.sectionInsets
        if layoutConfiguration.shouldCenterItems {
            insets.left = max(
                (collectionView.bounds.width - contentWidth) / 2,
                layoutConfiguration.sectionInsets.left
            )
        }
        
        return insets
    }
    
}
