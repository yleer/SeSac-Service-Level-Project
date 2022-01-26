# SeSac-Service-Level-Project

1/25 일지
네트워크 통신으로 회원 정보를 가져오는데 명세서에서의 응답과 나의 get을 통해 가져온 응답에 차이가 있었다. 알고보니 계정의 값이 업데이트 되어, 계정의 정보를 주는 get을 했을 시 주는 응답에 변화가 생겼던 것이다.
나는 업데이트 되기 이전에 회원가입이 완료 되어, 같은 get 콜을 사용하더라도 다른 응답이 왔던 것이다.


1/26 일지 
ManageMyInfo view에 있는 table view는 각 cell 마다 다른 cell로 dequeueReusableCell를 해야 해 cellForRowAt 부분이 많이 지저분 했다. 이 부분을 고치기 위해 많은 생각을 했지만, indexPath.row마다 다른 부분으로 dequeue하는 부분은 줄일 수 없었다. 대신 dequeue한 이후, 각 cell을 초기화 하는 부분에서 각 custom cell에서 configure 하는 함수를 만들어 cellForRowAt안에서의 코드를 줄이고 이 코드를 각 custom cell에 대입해서 좀더 깔끔하게 만들었다.

원래 custom colors들에 대하여 struct을 만들어 static let 변수를 이용해 각 이름을 접근할 수 있게 했었다. 하지만 이렇게 하면 UIColor(name: )를 계속 호출해서 이름을 명시해줘야 하는 번거로움이 생겼다.이번거로움을 좀 줄이기 위해 UIColor에 extension을 사용하여 static let변수를 만들었다. 
