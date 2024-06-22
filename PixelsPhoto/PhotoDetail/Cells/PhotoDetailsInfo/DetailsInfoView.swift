import SwiftUI

struct DetailsInfoView: View {
    var viewModel: PhotoDetailsInfoViewModel
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.photoAltName)
                    .lineLimit(2)
                    .fontWeight(.medium)
                    .truncationMode(.tail)
                Text(viewModel.photographer)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(viewModel.photoId.description)
                    // .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
            }
            .frame(alignment: .topLeading)
            Spacer()
            PhotoDemantions(viewModel: viewModel)
                .aspectRatio(CGFloat(viewModel.width) / CGFloat(viewModel.height), contentMode: .fit)
                .frame(height: 100, alignment: .topTrailing)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    func PhotoDemantions(viewModel: PhotoDetailsInfoViewModel) -> some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color(UIColor(hex: viewModel.avgColor))
                    )
                Text("\(viewModel.width)")
                    .position(x: geometry.size.width / 2, y: 0)
                    .fontWeight(.light)
                    .font(.system(size: 12))
                    .offset(y: 10)

                Text("\(viewModel.height)")
                    .rotationEffect(.degrees(270))
                    .fontWeight(.light)
                    .font(.system(size: 12))
                    .position(x: 0, y: geometry.size.height / 2)
                    .offset(x: 10)
            }
        }
    }
}
