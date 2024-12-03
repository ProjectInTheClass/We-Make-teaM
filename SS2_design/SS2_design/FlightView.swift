import SwiftUI

struct FlightBookingView: View {
    @State private var isRoundTrip: Bool = false
    @State private var fromCity: String = "New York"
    @State private var toCity: String = "Shanghai"
    @State private var departureDate: Date = Date()
    @State private var returnDate: Date = Date()
    @State private var adultCount: Int = 1
    @State private var childCount: Int = 0
    @State private var infantCount: Int = 0
    @State private var seatClass: String = "Business"

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("FLIGHT")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Image(systemName: "airplane")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .padding()
            .frame(maxWidth: .infinity) // 가로로 꽉 차게 설정
            .background(Color.blue.opacity(0.1)) // Header 배경
            .overlay(
                Spacer().frame(height: 0), alignment: .bottom // 추가적인 높이를 방지
            )

            // Trip Type Toggle
            HStack {
                Button(action: {
                    isRoundTrip = false
                }) {
                    Text("ONE WAY")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRoundTrip ? Color.gray.opacity(0.2) : Color.blue)
                        .foregroundColor(isRoundTrip ? .black : .white)
                        .cornerRadius(10)
                }

                Button(action: {
                    isRoundTrip = true
                }) {
                    Text("ROUND TRIP")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isRoundTrip ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(isRoundTrip ? .white : .black)
                        .cornerRadius(10)
                }
            }
            .padding()

            // Flight Details
            VStack(spacing: 20) {
                FlightDetailRow(title: "FROM", value: fromCity, icon: "paperplane")
                FlightDetailRow(title: "TO", value: toCity, icon: "paperplane")

                DatePicker("DEPARTURE DATE", selection: $departureDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                if isRoundTrip {
                    DatePicker("RETURN DATE", selection: $returnDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }

                HStack {
                    PassengerSelection(title: "ADULT", count: $adultCount)
                    PassengerSelection(title: "CHILD", count: $childCount)
                    PassengerSelection(title: "INFANT", count: $infantCount)
                }

                HStack {
                    Text("SEAT CLASS")
                        .font(.headline)
                    Spacer()
                    Text(seatClass)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()

            // Search Button
            Button(action: {
                print("Search flights")
            }) {
                Text("SEARCH")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }
}

struct FlightDetailRow: View {
    var title: String
    var value: String
    var icon: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Image(systemName: icon)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct PassengerSelection: View {
    var title: String
    @Binding var count: Int

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            HStack {
                Button(action: {
                    if count > 0 { count -= 1 }
                }) {
                    Text("-")
                        .frame(width: 30, height: 30)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }

                Text("\(count)")
                    .font(.title3)
                    .frame(width: 30)

                Button(action: {
                    count += 1
                }) {
                    Text("+")
                        .frame(width: 30, height: 30)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
            }
        }
        .padding()
    }
}

struct FlightBookingView_Previews: PreviewProvider {
    static var previews: some View {
        FlightBookingView()
    }
}


