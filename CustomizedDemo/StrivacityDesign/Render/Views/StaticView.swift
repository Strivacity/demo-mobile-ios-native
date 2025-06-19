import SdkMobileIOSNative
import SwiftUI

struct StaticView: View {
    let widgetId: String

    let widget: StaticWidget

    @State var htmlContentValue: String = ""

    public var body: some View {
        if widget.render.type == "html" {
            HtmlTextView(htmlContent: $htmlContentValue)
                .padding(.horizontal, Typography.paddingMd)
                .padding(.bottom, Typography.errorFrameHeight)
                .onAppear {
                    htmlContentValue = widget.value
                }
                .onChange(of: widget.value) { _, newValue in
                    htmlContentValue = newValue
                }
        } else if widget.render.type == "text" {
            Text(widget.value)
                // TODO: refactor this when backend will support another
                // field to check if a static text font size should be bigger
                .font(.system(widgetId == "section-title" ? .title : .body))
                .fontWeight(widgetId == "section-title" ? .bold : .regular)
                .padding(.horizontal, Typography.paddingMd)
                .padding(.bottom, Typography.errorFrameHeight)
        } else {
            FallbackTriggerView()
        }
    }
}
