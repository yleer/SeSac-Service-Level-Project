# 새싹 취미 공유
> 취미를 공유할 수 있는 친구를 찾아보세요!<br /> 원하는 위치와 취미를 지정해 근처에 새싹들에게 취미 요청을 하거나 요청을 받아 같이 취미를 즐겨보세요.


# Contents
+ [Installation](#Installation)
+ [Usage example](#Usage-example)
+ [Features](#Features)
+ [Tech Stack](#Tech-Stack)
+ [개발 일지](#개발-일지)
+ [회고](#회고)

![](header.png)

## Installation
>+ 프로젝트 클론 - https://github.com/yleer/SeSac-Service-Level-Project.git
>+ zip 파일 다운하기 




## Usage example

<p align="center">
  <img src = "https://user-images.githubusercontent.com/48948578/155700533-0f34f804-bc1e-416b-b922-c0b31600fbaa.png" width=1000>
</p>

<br />
<br />

<p align="center">
  <img src = "https://user-images.githubusercontent.com/48948578/155701849-1d224b47-5c93-4b80-a90c-85c3252e9d0d.png" width=700>
</p>


## Features

새싹 취미 공유에 기능들:

* 선택한 위치 주변 새싹 검색
* 동일한 취미를 가진 새싹과 매칭
* 새싹들에 대한 정보 확인
* 매칭된 새싹과 채팅
* 매칭 종료 후 새싹에 대한 리뷰, 신고 
* In App Purchase 기능을 통한 새싹, 그리고 배경화면 이미지 변경
* Push Notification을 통한 푸시에 대한 처리
* 개인정보 수정 및 


## Tech Stack
>+ MapKit을 사용한 지도 표현
>+ Alamofire를 아용한 rest api 통신
>+ SnapKit을 이용한 UI 작성
>+ SocketIO를 통한 채팅 구현
>+ Realm을 이용한 채팅 내용 저장 및 불러오기 
>+ FireBase Auth를 통한 전화번호 인증
>+ FCM을 이용한 push notification 구현
>+ In App Purchase 기능
>+ MVVM, MVC 패턴 사용

## 개발 일지 
* 1/25
  * API 통신 중 GET 메소드를 통해 정보를 가져와야 하는 부분이 있었는데, 서버측에서의 응답값을 바꾸어 에러가 났다. 이러한 문제를 최소화하기 위해 백앤드 측과 지속적인 소통이 필요할 것 같다.
* 1/26 
  * cellForRowAt을 통해 tableviewCell을 지정해주는 함수에서 각 cell마다 지정해주어야 하는 값이 많아 함수가 거대해졌다. 이 부분을 최소화하기 위하여 각 custom cell에서 configure 함수를 따로 만들어 그 곳에서 cell을 초기화 할 수 있도록 하였다.
  * Custom colors들과 custom images들이 다수 존재하였는데 이들을 사용하기 위해 직접 값을 사용하는데 번거러움을 느꼈다. 이를 좀 더 편하게 사용하기 위하여 UIColor에 extension을 사용하여 사용에 좀더 용이하게 만들었다. 그리고 Images들을 좀더 편하게 사용하기 위해 enum을 만들어 접근을 쉽게 했다.
 * 1/28
   * 기존에 키보드 올림 내림 구현을 IQKeyboard 라이브러리를 사용하여 구현했다. 하지만 디자인에 있어 키보드 상태에 따라 UI가 변화하여 그져 올리고 내리는 것만으로는 부족함을 느꼈다. 이를 해결하기 위해 키보드 내림과 올림을 직접 구현하기로 했다.
   
   ```
   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)               
   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
   ```
   위 노티피케이션을 통해 키보드 제어가 가능하였고, 이를 통해 키보드의 상태에 따라 UI에 변화를 줄 수 있었다.
   이때 texteField들은 view.endEditing(true)를 사용하여 키보드 내리는 것이 가능했지만, searchBar에는 이 코드가 작동하지 않았다. 검색을 통해 resignFirstResponder()사용 하면 된다는 것을 알게 되었다.
   

 >+ https://stackoverflow.com/questions/29925373/how-to-make-keyboard-dismiss-when-i-press-out-of-searchbar-on-swift 나와 같은 문제를 갖고 있음.
 >+ https://stackoverflow.com/questions/29882775/resignfirstresponder-vs-endediting-for-keyboard-dismissal/29882945 에서 차이 공부해보자.
  >  이 두 포스트에서 답을 알게 되어 해결할 수 있었다. 
 
 * 1/29
    * Api 명세서에 명시되어 있는데로 post 콜을 진행하였다. 하지만 client error를 명시하는 501에러가 발생하였다. 다른 통신들은 아무 문제 작동하여 무엇이 문제인지 모르고 있어 서버측에 어떤 문제가 있나 문의하는 일이 있었다. 아래의 사진이 api가 필요로 하는 파라메터값이고, 그 다음이 내가 보낸 배열의 값이 서버측에서 받아들인 값이다. 
   <img src = "https://user-images.githubusercontent.com/48948578/155841220-99e896a4-2c4a-478a-aaf0-1a7fd90f61d5.png" height=50>
   <img src = "https://user-images.githubusercontent.com/48948578/155841213-3dc3242e-3b8a-487e-b668-a158275a05f1.png" height=50>
   
   > 위에서 확인 한 것과 같이 배열 인자 값이 올바르지 않게 인자로 넘어간 것을 알게 되었고, Alamofire에서 배열 값을 보낼때 parameter encoding을 해줘아햐는 사실을 알게 되었다. encoding 옵션을 추가하여 통신을 진행하자 통신이 잘 되는 것을 확인 할 수 있었다.

* 2/5
  * 한 특정 화면에서 입력된 사용자의 데이터가 다른 화면에서도 사용이 된다. 하지만 이 데이터가 사용되는 모든 화면에 모두 값을 전달하는 것은 중복되는 코드가 많고 보기에도 좋지 않다는 점을 느꼈다. 이를 해결하기 우해 Singleton 패턴을 사용하게 되었고, 사용자의 관한 임시 정보를 Singleton을 통해 보관하여 해결하였다. 

* 2/13
  * API 통신으로 json을 파싱할때, 현재 사용자 상태에 따라 응답으로는 json 값의 변화가 있다. (예를 들어 review 가 없을수도 있고, 있을 수도 있다) 이때 codable안에 값이 있을 수도 있고, 없을 수도 있는 값을 optional로 처리하면 값이 있고 없음을 대응할 수 있다.

* 2/15
  * 한 화면씩 개발한 후, 전체적 flow를 실행할때 에러가 나는 부분들이 생겼다. flow를 따라 갈때 나는 에러를 해결하는데 많은 시간이 쓰였다. 앞으론 한 화면 만들고 flow를 따라가면서 문제가 없나 확인하는 습관을 드리며 개발하자.
 
* 2/17
  * 채팅을 보낼때 새로운 채팅을 채팅 데이터에 추가한 후 가장 최신의 채팅을 볼 수 있게 테이블 뷰를 맨 아래로 scroll 해줘야 한다. 하지만 맨 아래로 스크롤이 안되는 문제가 있었다. 알고 보니 원인은 아래의 코드에 있었다.


```
 mainView.tableView.scrollToRow(at: IndexPath(row: data.count - 1, section: 0), at: .bottom, animated: true)
 mainView.tableView.reloadData()
   ```
 
추가된 채팅 데이터를 tableview에 반영하기 위해 reloadData를 한 후 스크롤을 해줘야 하는데 순서를 바꿔 작성한 것이다. 이러한 간단한 문제이지만 실수를 할 수 있다는 것을 알게 되었다.

* 2/23 
  * Api 콜을 보낼때 지도의 center 좌표값을 파라메터로 보내는 함수가 있었다. 하지만 기획 명세서를 잘못 이해하여 지도에서의 center값이 아닌 특정 annotation를 drag하여 그 annotation의 좌표값을 넘겨주고 있었다. 이 부분 을 고치기 위해 지도에서의 center값을 파라메터로 보내주었는데 생각했던데로 작동하지 않았다. 왜 그런지 이해하기 위해 간단한 print문을 통해 인자가 제대로 전달 되는지 확인하였고, 이 결과 내가 생각했던 데로 값이 전달이 되지 않는 문제를 발견하였다. 그 후 제대로 전달될 수 있게 값을 제대로 설정하여 문제를 해결할 수 있었다. 
  * 이 문제에서 느낀 점은 프로젝트가 커지면 커질수록 코드가 복잡해져 바로 상황파악이 잘 안된다는 점이다. 이런 문제를 해결하기 위해 디자인 패턴이 중요하고 좋은 설계가 필요하다는 것을 느꼈다. 앞으로 설계를 할 때에는 바로 코딩을 통한 구현보단, 설계에 힘을 쓰는 습관을 들여야 할 것 같다. 
 
 


## 회고
 * 새싹 취미 공유 프로젝트는 한 프로젝트를 팀원들과 같이 각자 5주간 진행하였다. 매일 3번씩 각자의 진행 상황을 공유하며 서로 어려운 것을 질문하며 문제를 해결하는 방식이였다. 매일 각자의 상황을 공유하면서 팀원들이 같은 프로젝트를 진행하지만 모두 다른 방향으로 개발하는 것을 알 수 있었다. 예를 들어 같은 UI에 대하여 어떤 팀원은 tableView, 다른 팀원은 collectionView로 접근한다는 점에서 코딩이란 한 가지에 접근 방식이 아닌 여러가지 접근 방식이 있다는 점을 알 수 있었다. 
 * 프로젝트가 커지면 커질 수록 코드가 많아지기 때문에 자신이 작성한 코드였더라도 기억이 잘 안나는 경험을 하였다. 이때 문제는 특정 코드에 버그가 났을때 이 부분을 고쳐야 하는데 내가 어떤 의도로 해당 코드를 작성했는지 잘 이해가 되지 않는다는 점이다. 그래서 이 코드를 수정하기 전 다시 이해해야 하는데 이 부분에서 상당 시간이 소모되었다. 이래서 개발자들이 설계에 힘쓰며 깨끗한 코드를 지향하는 점을 알게 되었다. 설계에 힘쓰지 않고 막 코드를 작성하면 구현은 빠르겠지만 유지 보수가 어렵다는 말을 실제로 경험하게 되었다. 앞으로는 구현에 급급해하기 보다는 프로젝트 설계에 힘을 쓰며 나만의 규칙 혹은 팀에서의 규칙을 잘 지키는 것이 중요하다는 점을 느꼈다.
 * 프로젝트가 완성된 뒤 팀원끼리 서로의 코드를 리뷰하는 시간이 있었다. 모두가 같은 프로젝트를 진행했지만, 모두가 다른 코드를 작성하였다. 이 점에서 한 컴포넌트를 개발하는데도 개발 방향은 같더라도 서로의 코드는 모두 다르다는 것을 팀원 모두가 느꼈고 신기해했다. 이러한점에서 한 코드를 작성할때도 여러가지 방법이 존재하므로 팀원들의 리뷰를 통해 최선의 방법으로 개발하는 것이 중요할 것 같다. 이에 따라 팀원들간 소통이 굉장이 중요하다는 것을 알게 되었다. 




