//
//  PostCell.swift
//  Katana
//
//  Created by Alain Caltieri on 07/11/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Foundation
import Katana
import KatanaElements

extension PostCell {
    enum Keys {
        case titleLabel
        case gifImage
    }
    
    struct Props: NodeDescriptionProps, Buildable {
        var frame: CGRect = .zero
        var index: Int = 0
        var post: Post? = nil
    }
}

struct PostCell: PlasticNodeDescription, PlasticNodeDescriptionWithReferenceSize, TableCell, ConnectedNodeDescription {
    typealias StateType = EmptyHighlightableState
    typealias PropsType = Props
    typealias NativeView = NativeTableCell
    
    var props: Props
    
    static var referenceSize = CGSize(width: 640, height: 500)
    
    static func childrenDescriptions(props: PropsType,
                                     state: StateType,
                                     update: @escaping (StateType)->(),
                                     dispatch: @escaping StoreDispatch) -> [AnyNodeDescription] {
        return [
            Label(props: LabelProps.build({
                $0.setKey(Keys.titleLabel)
                $0.text = NSAttributedString(string: (props.post?.title)!, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 18)
                ])
                $0.textAlignment = NSTextAlignment.center
                $0.numberOfLines = 0
            })),
            Image(props: ImageProps.build({
                $0.setKey(Keys.gifImage)
                $0.image = UIImage.gif(data: (props.post?.imageData)!)
                $0.backgroundColor = UIColor.lightGray
            })),
        ]
    }
    
    static func layout(views: ViewsContainer<Keys>, props: Props, state: EmptyHighlightableState) {
        let rootView = views.nativeView
        let title = views[Keys.titleLabel]!
        let imageView = views[Keys.gifImage]!

        title.asHeader(rootView, insets: .scalable(30, 10, 10, 5))
        title.height = .scalable(70)

        imageView.fillHorizontally(rootView)
        imageView.top = title.bottom
        imageView.bottom = rootView.bottom
    }
    
    static func didTap(dispatch: StoreDispatch, props: PropsType, indexPath: IndexPath) {
        // Do nothing
    }
    
    static func connect(props: inout Props, to storeState: CodingLoveState) {
        props.post = storeState.posts[props.index]
    }
}
