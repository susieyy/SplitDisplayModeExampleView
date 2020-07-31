import SwiftUI

struct ContentView: View {
    @State var displayMode: UISplitViewController.DisplayMode = .automatic

    var body: some View {
        SplitContentView(master: MasterView(displayMode: $displayMode), detail: Text(displayMode.description), displayMode: $displayMode)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MasterView: View {
    @Binding var displayMode: UISplitViewController.DisplayMode

    var body: some View {
        List(UISplitViewController.DisplayMode.allCases, id: \.self) { displayMode in
            HStack {
                Text(self.displayMode == displayMode ? "o" :"")
                Text(displayMode.description)
            }
            .gesture(TapGesture().onEnded { _ in
                self.displayMode = displayMode
            })
        }
    }
}

extension UISplitViewController.DisplayMode: CaseIterable {
    public static var allCases: [Self] {
        [
            automatic,
            secondaryOnly,
            oneBesideSecondary,
            oneOverSecondary,
            twoBesideSecondary,
            twoOverSecondary,
            twoDisplaceSecondary
        ]
    }
}

extension UISplitViewController.DisplayMode: Identifiable {
    public var id: Int { rawValue }
}

extension UISplitViewController.DisplayMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .automatic: return "automatic"
        case .secondaryOnly: return "secondaryOnly"
        case .oneBesideSecondary: return "oneBesideSecondary"
        case .oneOverSecondary: return "oneOverSecondary"
        case .twoBesideSecondary: return "twoBesideSecondary"
        case .twoOverSecondary: return "twoOverSecondary"
        case .twoDisplaceSecondary: return "twoDisplaceSecondary"
        @unknown default: return "N/A"
        }
    }
}

struct SplitContentView<MasterView: View, DetailView: View>: View {
    @Binding var preferredDisplayMode: UISplitViewController.DisplayMode
    private var masterController: UIViewController
    private var detailController: UIViewController
    private var splitViewController = UISplitViewController()

    init(master: MasterView, detail: DetailView, displayMode: Binding<UISplitViewController.DisplayMode>) {
        masterController = UIHostingController(rootView: master)
        detailController = UIHostingController(rootView: detail)
        _preferredDisplayMode = displayMode
    }

    var body: some View {
        SplitViewController(
            splitViewController: splitViewController,
            controllers: [masterController, detailController],
            preferredDisplayMode: $preferredDisplayMode
        )
    }
}

struct SplitViewController: UIViewControllerRepresentable {
    var splitViewController: UISplitViewController
    var controllers: [UIViewController]
    @Binding var preferredDisplayMode: UISplitViewController.DisplayMode

    func makeUIViewController(context _: UIViewControllerRepresentableContext<SplitViewController>) -> UISplitViewController {
        splitViewController.preferredDisplayMode = preferredDisplayMode
        splitViewController.maximumPrimaryColumnWidth = 240
        splitViewController.viewControllers = controllers
        return splitViewController
    }

    func updateUIViewController(_ uiViewController: UISplitViewController, context _: UIViewControllerRepresentableContext<SplitViewController>) {
        uiViewController.preferredDisplayMode = preferredDisplayMode
        uiViewController.viewControllers = controllers
    }
}
