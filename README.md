## SwiftUI Thinking Concurrency code 모음

## 👉 [강의 채널 바로가기](https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM)

---

## 01.Do-Catch, Try and Throws

```swift
import SwiftUI

// MARK: -  DATA SERVICE
class DoCatchTryThrowsBootCampDataManager {
let isActive: Bool = false

func getTitle() -> String? {
  if isActive {
    return "New Text"
  } else {
    return nil
  }
}
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var text: String = "Starting text."
let manager = DoCatchTryThrowsBootCampDataManager()

// MARK: -  INIT
// MARK: -  FUNCTION
func fetchTitle() {
  let newTilte = manager.getTitle()
  if let newTilte = newTilte {
    self.text = newTilte
  }
}
}

// MARK: -  VIEW
struct DoCatchTryThrowsBootCamp: View {
// MARK: -  PROPERTY
@StateObject private var vm = DoCatchTryThrowsBootCampViewModel()
// MARK: -  BODY
var body: some View {
  Text(vm.text)
    .frame(width: 300, height: 300)
    .background(Color.blue)
    .onTapGesture {
      vm.fetchTitle()
    }
}
}
```

Above code, an optional right as a developer we know that is returning optional because it failed to get the text but if you're sharing this code if other people are using this code that's not very clear and it might look like a bug in your app if maybe things are just not updating. Take it a step further and maybe return an error instead

This is good this is a bit better in our code now the ability to check for real values and also check for errors but This is kind of a hassle for us as developers because really we want to return a result here either this function should be successful or it should fail it shouldn't really return us a title end an error. It's probably only be getting one or the other there's never really a use case where we're going to get both of these

```swift
// MARK: -  DATA SERVICE
class DoCatchTryThrowsBootCampDataManager {
let isActive: Bool = false

func getTitle() -> (title:String?, error: Error?) {
  if isActive {
    return ("New Text",nil)
  } else {
    return (nil, URLError(.badURL))
  }
}
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var text: String = "Starting text."
let manager = DoCatchTryThrowsBootCampDataManager()

// MARK: -  INIT
// MARK: -  FUNCTION
func fetchTitle() {
  let returnedValue = manager.getTitle()
  if let newTilte = returnedValue.title {
    self.text = newTilte
  } else if let error = returnedValue.error {
    self.text = error.localizedDescription
  }
}
}

```

  <img height="350"  alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/165196979-6c5f118a-19e0-49aa-bec5-7ea1e1ec353a.gif">

So, It's like little but better now because this is if you're sharing this with other developers or even if you're just coming back to this successful, failure state. It's no longer giving us back both and then we have to kind of manage which one is which and look at both cases and look at all the data instead now we just get back a result

```swift
class DoCatchTryThrowsBootCampDataManager {
	let isActive: Bool = false

	func getTitle2() -> Result<String, Error> {
		if isActive {
			return .success("New Text!")
		} else {
			return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
		}
	}
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var text: String = "Starting text."
	let manager = DoCatchTryThrowsBootCampDataManager()

	// MARK: -  INIT
	// MARK: -  FUNCTION
	func fetchTitle() {
		let result = manager.getTitle2()

		switch result {
		case .success(let newTitile):
			self.text = newTitile
		case .failure(let error):
			self.text = error.localizedDescription
		}
	}
}
```

- To use throw keyWord and then handle error using do try catch statement

```swift
// MARK: -  DATA SERVICE
class DoCatchTryThrowsBootCampDataManager {
let isActive: Bool = false

func getTitle() -> (title:String?, error: Error?) {
  if isActive {
    return ("New Text",nil)
  } else {
    return (nil, URLError(.badURL))
  }
}

func getTitle2() -> Result<String, Error> {
  if isActive {
    return .success("New Text!")
  } else {
    return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
  }
}

// throws meaning it can throw
func getTile3() throws -> String {
  if isActive {
    return "New Text!"
  } else {
    throw URLError(.badServerResponse)
  }
}
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var text: String = "Starting text."
let manager = DoCatchTryThrowsBootCampDataManager()

// MARK: -  INIT
// MARK: -  FUNCTION
func fetchTitle() {
  do {
    let newTitle = try manager.getTile3()
    self.text = newTitle
  } catch {
    self.text = error.localizedDescription
  }
}
}
```

- When you use throw statement and then initialized code to use try? include return nil when it comes error (Not necessary Do catch statement)

```swift
// MARK: -  DATA SERVICE
class DoCatchTryThrowsBootCampDataManager {
	let isActive: Bool = true


	func getTile4() throws -> String {
		if isActive {
			return "Final Text!"
		} else {
			throw URLError(.badServerResponse)
		}
	}
}

// MARK: -  VIEWMODEL
class DoCatchTryThrowsBootCampViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var text: String = "Starting text."
let manager = DoCatchTryThrowsBootCampDataManager()

// MARK: -  INIT
// MARK: -  FUNCTION
func fetchTitle() {

  let newTitle = try? manager.getTile3()
  if let newTitle = newTitle {
    self.text = newTitle
  }
}
}
```

```swift
// MARK: -  FUNCTION
func fetchTitle() {
do {
  let newTitle = try? manager.getTile3()
  if let newTitle = newTitle {
    self.text = newTitle
  }
  let finalTile = try manager.getTile4()
  self.text = finalTile

} catch {
  self.text = error.localizedDescription
}
}
```

Most of our asynchronous code in our asynchronous functions are going to actually be functions that throw errors so this syntax is going to be really common in async await and when you're using throws you're almost always using do catch statement

## 02.Download image with Async and Await

Compare with different asynchronous way such as @escaping, combine and Async & Await when it comes from downloading image

- Case 1. Download image with @escaping

```swift
import SwiftUI

// MARK: -  SERVICE
class DownloadImageAsyncImageLoader {
let url = URL(string: "https://picsum.photos/200")!

func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
guard
  let data = data,
  let image = UIImage(data: data),
  let response = response as? HTTPURLResponse,
  response.statusCode >= 200 && response.statusCode < 300 else {
    return nil
  }
return image
}

func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
  let image = self?.handleResponse(data: data, response: response)
  completionHandler(image, error)
}
.resume()
}
}

// MARK: -  VIEWMODEL
class DownloadImageAsyncViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var image: UIImage? = nil
let loader = DownloadImageAsyncImageLoader()
// MARK: -  INIT
// MARK: -  FUNCTION
func fetchImage() {
loader.downloadWithEscaping { [weak self] image, error in
  DispatchQueue.main.async {
    self?.image = image
  }
}
}
}

// MARK: -  VIEW
struct DownloadImageAsync: View {
// MARK: -  PROPERTY
@StateObject private var vm = DownloadImageAsyncViewModel()
// MARK: -  BODY
var body: some View {
ZStack {
  if let image = vm.image {
    Image(uiImage: image)
      .resizable()
      .scaledToFit()
      .frame(width: 250, height: 250)
  }
} //: ZSTACK
.onAppear {
  vm.fetchImage()
}
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/165654782-21df8047-6f96-46cb-973a-fecd7baaf234.png">

- Case 2. Download image with Combine

```swift
import SwiftUI
import Combine

// MARK: -  SERVICE
class DownloadImageAsyncImageLoader {
let url = URL(string: "https://picsum.photos/200")!

func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
guard
  let data = data,
  let image = UIImage(data: data),
  let response = response as? HTTPURLResponse,
  response.statusCode >= 200 && response.statusCode < 300 else {
    return nil
  }
return image
}


func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
URLSession.shared.dataTaskPublisher(for: url)
  .map(handleResponse)
  .mapError({ $0 })
  .eraseToAnyPublisher()
}
}

// MARK: -  VIEWMODEL
class DownloadImageAsyncViewModel: ObservableObject {
// MARK: -  PROPERTY
@Published var image: UIImage? = nil
let loader = DownloadImageAsyncImageLoader()
var cancellables = Set<AnyCancellable>()
// MARK: -  INIT
// MARK: -  FUNCTION
func fetchImage() {
  loader.downloadWithCombine()
    .receive(on: DispatchQueue.main)
    .sink { _ in

    } receiveValue: { [weak self] image in
        self?.image = image
    }
    .store(in: &cancellables)
}
}
```

- Case 3. Download image with Async and Await

```swift
// MARK: -  SERVICE
class DownloadImageAsyncImageLoader {
let url = URL(string: "https://picsum.photos/200")!

func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
guard
  let data = data,
  let image = UIImage(data: data),
  let response = response as? HTTPURLResponse,
  response.statusCode >= 200 && response.statusCode < 300 else {
    return nil
  }
return image
}
func downloadWithAsync() async throws -> UIImage? {
  do {
    let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
    return handleResponse(data: data, response: response)
  } catch  {
    throw error
  }
}
}

// MARK: -  VIEWMODEL
class DownloadImageAsyncViewModel: ObservableObject {
	// MARK: -  PROPERTY
	@Published var image: UIImage? = nil
	let loader = DownloadImageAsyncImageLoader()
	var cancellables = Set<AnyCancellable>()
	// MARK: -  INIT
	// MARK: -  FUNCTION
	func fetchImage() async {
		let image = try? await loader.downloadWithAsync()
		await MainActor.run {
			self.image = image
		}
	}
}

// MARK: -  VIEW
struct DownloadImageAsync: View {
// MARK: -  PROPERTY
@StateObject private var vm = DownloadImageAsyncViewModel()
// MARK: -  BODY
var body: some View {
ZStack {
if let image = vm.image {
  Image(uiImage: image)
    .resizable()
    .scaledToFit()
    .frame(width: 250, height: 250)
}
} //: ZSTACK
.onAppear {
Task {
  await vm.fetchImage()
}
}
}
}
```

<img height="350" alt="스크린샷" src="https://user-images.githubusercontent.com/28912774/165670469-98b0dcb7-05c8-41a1-a21e-de96a07b2499.png">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

```swift

```

<img height="350" alt="스크린샷" src="">

---

<!-- <p align="center">
  <img height="350"  alt="스크린샷" src="">
</p> -->

<!-- README 한 줄에 여러 screenshot 놓기 예제 -->
<!-- <p>
   <img height="350" alt="스크린샷" src="">
   <img height="350" alt="스크린샷" src="">
   <img height="350" alt="스크린샷" src="">
</p> -->

---

<!-- 🔶 🔷 📌 🔑 👉 -->

## 🗃 Reference

Swift Concurrency (Intermediate Level) - [https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM](https://www.youtube.com/playlist?list=PLwvDm4Vfkdphr2Dl4sY4rS9PLzPdyi8PM)
