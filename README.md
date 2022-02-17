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


1/30 일지
오늘은 /queue콜을 보내기 위해 alamofire를 통해 post콜을 보내려 했다. 하지만 평소에 사용하던 post콜과는 달리 계속 client 에러가 발생하였다. 
<img width="225" alt="스크린샷 2022-01-30 오후 11 58 08" src="https://user-images.githubusercontent.com/48948578/151704965-a6b390f4-a70b-43db-b747-a4f8a048b084.png">
이 사진은 파라메터로 받는 명시된 값이다.
<img width="485" alt="스크린샷 2022-01-30 오후 11 59 35" src="https://user-images.githubusercontent.com/48948578/151705007-5af79589-b2ea-4349-b85f-fc7ec7a989e5.png">
평소와 같이 파라메터에 대응하는 구조체를 만들어 post 콜을 보냈는데 계속 에러가 발생하였다. 

그래서 결국 서버측에 물어보니 내가 보낸 request의 값이 다른 값들은 다 잘 들어 갔지만 String 배열의 값이 다음과 같이 이상하게 들어가는것을 알 수 있었다.<img width="122" alt="스크린샷 2022-01-30 오후 8 45 08" src="https://user-images.githubusercontent.com/48948578/151705120-84ad5c71-3093-4952-a50a-d95d22b0dd6c.png">
이를 통해 내가 보낸 파라메터의 값이 잘못 보내진것을 확인하였다. 그래서 검색을 통해 alamofire는 배열을 파라메터로 보낼때 인코딩 형식의 따라 다르게 보내진다는 것을 알게 되었고, 

<img width="445" alt="스크린샷 2022-01-31 오전 12 03 59" src="https://user-images.githubusercontent.com/48948578/151705172-728b6bbf-0295-413b-8323-9a529c736407.png">
이 인코딩 방법으로 문제를 해결할 수 있었다.


1/31일지
HobbySearchVc 완성하였다. 이제 코드들을 네트워크 통신 콜들을 리팩토링하려고 하는데 컴플리션 핸들링이 너무 많아 해깔린다. 이스케이핑 핸들링 어떻게 더 편하게 할 수 있는지 생각해봐야겠다 앞으로.

2/1 ~ 2/4일 
연휴 기간으로 제대로 하지 못함.

2/5일 일지
새싹찾기 화면 구현중. 이때 onque 콜을 지속적으로 보내야 하는데, 이떄 파라메터로 필요한 값들을 접근할 수 없는 문제가 발생. 이는 지도 화면에서 검색화면으로 넘어갈때 한번만 onque 콜을 사용하는 줄 알고 화면간 값전달로 처리해서 이후 화면들에서는 이 값들에 접근이 어려워서 발생한 문제이다. 이 문제를 해결하기 위해 이때의 사용자 정보를 UserInfo라는 클래스를 만들어 싱글톤 패턴을 이용해서 해결함. (이전에 만들었던 UserInfo 클래스를 )

2/7일 일지
왜인지 모르겠지만 친구 요청하기 화면에서 autolayout error가 나고 있다 이유를 알아보자
Attempted to call -cellForRowAtIndexPath: 


2/9일 일지
지도에서 어노테이션이 계속 중복되서 만들어지는 이슈 있음

2/12일 일지
api 통신 함수 후에 특정 부분이 실행이 계속 안되는 문제가 있었음. 1시간 정도 왜 안되나 고민한거 같음. 결국 찾아본 결과 completion을 깜박하고 호출을 하지 않아 실행이 안되었던것.

2/13일 일지
api 통신으로 json을 파싱할때, 현재 사용자 상태에 따라 json 값의 변화가 있다. (예를 들어 review 가 없을수도 있고, 있을 수도 있다) -> 이때 codable안에 값이 있을 수도 있고, 없을 수도 있는 값을 optional로 처리하면 decoding error를 처리할수있다

2/15일 일지
한 화면 화면씩 만들다 보니 전체적으로 실행했을때 오류 나는 부분들이 생겼다. 문제 다 해결 하자 . 한 화면 - 다른 화면 전환 간 전환시 문제 알아보자

보이는 런타임 에러들은 모두 해결. -> 땜빵식으로 해결 해서 코드가 좀 더럽긴 함. 


2/17일 일지
새로운 채팅을 치면 새로운 채팅이 맨 아래 보이게끔 tableview를 맨아래로 scroll해줘야 했다. 하지만 자꾸 scrollTo Index 맨마지막으로 해도 안되는 경우가 생겼다. 데이터가 업데이트가 안되어 index error가 나는 줄 알았으나, 원인은 ![스크린샷 2022-02-17 오후 8 31 28](https://user-images.githubusercontent.com/48948578/154472850-ecd82e95-0452-4e52-a01f-f723ad4312e0.png)
이 코드에 있었다. 데이터는 업데이트 되더라도, 테이블 뷰가 업데이트 되지 않아 새로운 데이터의 인덱스 접근이 불가능 했던 것이다. 어떻게 보면 당연한것이지만 가끔 해깔릴 수도 있는 문제 인거 같다.
(실제 코드에선 옵셔널 확인을 해야 하기 때문에 따로 함수로 작성했다)
