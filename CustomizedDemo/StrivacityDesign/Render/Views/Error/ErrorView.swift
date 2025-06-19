import SdkMobileIOSNative
import SwiftUI

struct ErrorView: View {
    let formId: String
    let widgetId: String
    var error: String
    @EnvironmentObject var scrollManager: ScrollManager

    var body: some View {
        let fieldId = formId + "-" + widgetId
        ErrorField(error: error)
            .id(fieldId)
            .onChange(of: error) {
                scrollManager.errorFieldIds.append(fieldId)
            }
    }
}

struct ErrorField: View {
    var error: String
    var body: some View {
        Text(error)
            .foregroundColor(Colors.red)
            .font(.caption2)
            // hack to display more than 1 line error text, it won't truncated
            .fixedSize(horizontal: false, vertical: true)
            .frame(minHeight: Typography.errorFrameHeight)
            .padding(.horizontal, Typography.paddingMd)
    }
}
