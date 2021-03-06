
import UIKit

final class RHPlaceholder {
    
    private var placeholders = [RHPlaceholderItem]()
    private var layerAnimator: RHLayerAnimating.Type
    // Property keeps all references to the animators to avoid early release
    private var animators = [RHLayerAnimating]()
    
    init(layerAnimator: RHLayerAnimating.Type) {
        self.layerAnimator = layerAnimator
    }
    
    convenience init() {
        self.init(layerAnimator: RHLayerAnimatorGradient.self)
    }
    
    func register(_ viewElements: [UIView]) {
        viewElements.forEach {
            let placeholderItem = RHPlaceholderItem(originItem: $0)
            self.placeholders.append(placeholderItem)
        }
        
        addLayer()
    }
    
    func remove() {
        placeholders.forEach { placeholder in
            let layer = placeholder.shield
            layer.removeFromSuperview()
        }
        
        removeAnimatorsReferences()
    }
    
    private func addLayer() {
        placeholders.forEach { placeholder in
            addShieldViewToOriginView(from: placeholder)
        }
        
        animate()
    }
    
    private func addShieldViewToOriginView(from placeholder: RHPlaceholderItem) {
        let shield = placeholder.shield
        shield.backgroundColor = UIColor.white
        shield.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
        
        shield.frame = placeholder.originItem.bounds
        placeholder.originItem.addSubview(shield)
    }
    
    private func animate() {
        placeholders.forEach { [weak self] in
            let layer = $0.shield.layer
            let animator = self?.layerAnimator.init()
            animators.append(animator!)
            
            animator?.addAnimation(to: layer)
        }
    }
    
    private func removeAnimatorsReferences() {
        animators.removeAll()
    }
    
    deinit {
        removeAnimatorsReferences()
    }
}
