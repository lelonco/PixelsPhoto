import UIKit
import SwiftUI

public class WrapedView<Content>: UIView where Content: View {
    let content: Content
    private let hostingController: UIHostingController<Content>
    public init(view: Content) {
        content = view
        hostingController = .init(rootView: view)
        super.init(frame: .zero)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        backgroundColor = .clear
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
