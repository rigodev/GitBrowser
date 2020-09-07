import UIKit
import RxSwift
import RxCocoa

private var prepareForReuseBag: Int8 = 0

@objc public protocol ReusableView: AnyObject {
    @objc func prepareForReuse()
}

extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }
extension UICollectionViewCell: ReusableView { }

public extension Reactive where Base: ReusableView {
    var prepareForReuse: Observable<Void> {
        Observable.merge(sentMessage(#selector(Base.prepareForReuse)).map { _ in }, deallocated)
    }
    
    var reuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = sentMessage(#selector(Base.prepareForReuse))
            .subscribe(onNext: { [weak base] _ in
                guard let base = base else { return }
                let newBag = DisposeBag()
                objc_setAssociatedObject(base, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })
        
        return bag
    }
}
