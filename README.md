# SeSac-Service-Level-Project

1/25 일지
네트워크 통신으로 회원 정보를 가져오는데 명세서에서의 응답과 나의 get을 통해 가져온 응답에 차이가 있었다. 알고보니 계정의 값이 업데이트 되어, 계정의 정보를 주는 get을 했을 시 주는 응답에 변화가 생겼던 것이다.
나는 업데이트 되기 이전에 회원가입이 완료 되어, 같은 get 콜을 사용하더라도 다른 응답이 왔던 것이다.


1/26 일지 
ManageMyInfo view에 있는 table view는 각 cell 마다 다른 cell로 dequeueReusableCell를 해야 해 cellForRowAt 부분이 많이 지저분 했다. 이 부분을 고치기 위해 많은 생각을 했지만, indexPath.row마다 다른 부분으로 dequeue하는 부분은 줄일 수 없었다. 대신 dequeue한 이후, 각 cell을 초기화 하는 부분에서 각 custom cell에서 configure 하는 함수를 만들어 cellForRowAt안에서의 코드를 줄이고 이 코드를 각 custom cell에 대입해서 좀더 깔끔하게 만들었다.

원래 custom colors들에 대하여 struct을 만들어 static let 변수를 이용해 각 이름을 접근할 수 있게 했었다. 하지만 이렇게 하면 UIColor(name: )를 계속 호출해서 이름을 명시해줘야 하는 번거로움이 생겼다.이번거로움을 좀 줄이기 위해 UIColor에 extension을 사용하여 static let변수를 만들었다. 


1/28 일지
원래는 IQKeyboard를 이용하여 키보드 내림 올림 구현을 했다. 하지만 디자인에 있어 그냥 키보드를 올리고 내리는 기능 이외에 키보드가 올라와 있을때 버튼의 위치, 크기가 변해야 해 키보드 올림 내림을 직접 구현하기로 함. 
 NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
노티피케이션 코드를 이용하여 키도드가 올라가고 내려갈때에 대응 할 수 있음.
textfield들에서는 view.endEditing(true)를 사용하면 키보드가 내려갔지만 searchbar에서는 이코드를 사용해도 키보드가 내려가지 않음. 그 대신 resignFirstResponder()를 사용하면 내려가는 것을 파악.
심지어 searchbar에서는 노티피케이션도 안되는 거 같음
https://stackoverflow.com/questions/29925373/how-to-make-keyboard-dismiss-when-i-press-out-of-searchbar-on-swift 나와 같은 문제를 갖고 있음.

https://stackoverflow.com/questions/29882775/resignfirstresponder-vs-endediting-for-keyboard-dismissal/29882945 에서 차이 공부해보자.
