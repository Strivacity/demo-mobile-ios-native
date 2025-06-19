import SdkMobileIOSNative
import SwiftUI

struct SubmitView: View {
    @EnvironmentObject var loginController: LoginController
    @EnvironmentObject var scrollManager: ScrollManager
    @EnvironmentObject var focusManager: FocusManager

    let formId: String

    let widget: SubmitWidget

    public var body: some View {
        let button = Button {
            Task {
                scrollManager.errorFieldIds.removeAll()
                await loginController.submit(formId: formId)
                focusManager.clearFocus()
            }
        } label: { Text(widget.label)
            // this frame modifier is needed so that the whole button can be clickable
            .frame(maxWidth: widget.render.type == "button" ? .infinity : nil)
            .font(widget.render.type == "button" ? .body.bold() : .body)
            .padding(.vertical, widget.render.type == "button" ? Typography.paddingMd : 0)
        }

        switch widget.render.type {
        case "button":
            let textColor = Color(hex: widget.render.textColor ?? "")
            let bgColor = Color(hex: widget.render.bgColor ?? "")

            button
                .foregroundColor(textColor ?? (widget.render.hint?.variant == "primary" ? .white : Colors
                        .styPrimary))
                .background(bgColor ?? (widget.render.hint?.variant == "primary" ? Colors
                        .styPrimary : .white))
                .cornerRadius(Typography.borderRadius)
                .border(Colors.borderGray, width: 1)
                .padding(.horizontal, Typography.paddingMd)
                .padding(.bottom, Typography.errorFrameHeight)

        case "link":
            button
                .foregroundColor(Colors.styPrimary)
                .padding(.bottom, Typography.errorFrameHeight)

        default:
            FallbackTriggerView()
        }
    }
}
