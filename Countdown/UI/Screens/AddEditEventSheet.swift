import SwiftUI

public struct AddEditEventSheet: View {
    @StateObject private var viewModel: AddEditEventViewModel

    private let availableIcons: [String] = [
        "calendar", "gift.fill", "airplane", "heart", "graduationcap", "gift",
        "house", "bag", "music.note", "camera", "cup.and.saucer", "leaf",
        "trophy", "star", "car", "figure.run", "party.popper", "sun.max",
        "clock", "bolt", "diamond", "crown", "flag", "map"
    ]

    private let colorHexes: [String] = [
        "#FF9500", "#FF2D55", "#AF52DE", "#34C759",
        "#FF3B30", "#FF375F", "#5856D6", "#32ADE6"
    ]

    public init(viewModel: AddEditEventViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizedStringKey(viewModel.headerTitle))
                        .font(.title2.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(viewModel.isEditMode ? "Update this countdown’s title, date, icon, and color." : "Create a new countdown with a title, date, icon, and color.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Group {
                        Text("Title")
                            .font(.headline)
                        TextField("Title", text: $viewModel.title)
                            .textFieldStyle(.roundedBorder)
                            .accessibilityIdentifier("title_field")
                    }

                    Group {
                        Text("Date")
                            .font(.headline)
                        HStack {
                            DatePicker("Pick a date", selection: $viewModel.date, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .onChange(of: viewModel.date, { _, _ in
                                    viewModel.hasCustomDate = true
                                })
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }

                    Group {
                        Text("Icon")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
                            ForEach(availableIcons, id: \.self) { symbol in
                                Button {
                                    viewModel.iconSymbolName = symbol
                                } label: {
                                    Image(systemName: symbol)
                                        .frame(width: 36, height: 36)
                                        .foregroundStyle(viewModel.iconSymbolName == symbol ? .white : .secondary)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(
                                                    viewModel.iconSymbolName == symbol
                                                    ? (Color(hex: viewModel.eventColorHex) ?? .orange)
                                                    : Color(.systemGray6)
                                                )
                                        )
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("icon_\(symbol)")
                            }
                        }
                    }

                    Group {
                        Text("Color")
                            .font(.headline)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            ForEach(colorHexes, id: \.self) { hex in
                                Button {
                                    viewModel.eventColorHex = hex
                                } label: {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(LinearGradient(
                                            colors: gradientColors(for: hex),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(height: 44)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(viewModel.eventColorHex == hex ? Color.black.opacity(0.6) : .clear, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("color_\(hex)")
                            }
                        }
                    }

                    Button {
                        Task { await viewModel.submit() }
                    } label: {
                        Text(LocalizedStringKey(viewModel.ctaTitle))
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(colors: [Color.purple, Color.pink], startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!viewModel.isValid || viewModel.isSubmitting)
                    .accessibilityIdentifier("add_countdown_cta")
                }
                .padding(16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let args = ProcessInfo.processInfo.arguments
                if args.contains("UITEST_AUTO_DATE") {
                    viewModel.hasCustomDate = true
                }
            }
        }
    }

    private func gradientColors(for hex: String) -> [Color] {
        guard let base = Color(hex: hex) else { return [Color.gray.opacity(0.6), Color.gray] }
        // Create a simple 2-stop gradient from lighter to base color
        return [base.opacity(0.8), base]
    }
}

#Preview {
    AddEditEventSheet(
        viewModel: AddEditEventViewModel(
            repository: PreviewRepository(items: []),
            mode: .add,
            onCompleted: {}
        )
    )
}



