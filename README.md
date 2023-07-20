# MC3 Team10 妄夢空想
## 협업 방법 & 깃 컨벤션

<details>
<summary>팀 협업용 깃허브 Forking Workflow 방식 협업 문서 </summary>
<div markdown="1">

### 1. 원본 레포를 fork하여 내 레포에 생성합니다.

### 2. 원하는 디렉토리에 git을 초기화 시켜줍니다.

```bash
git init
```

### 3. 원본(메인) 레포를 upstream으로 remote해줍니다.

```bash
git remote add upstream <원본(메인)레포 주소>
```

### 4. 로컬(나의) 레포를 origin으로 remote해줍니다.

```bash
git remote add origin <로컬(포크한 나의)레포 주소>
```
### <반복 시작>
**작업을 진행할 시 upstream에서 pull을 받아오고, origin으로 push를 날려주어 pr을 진행합니다.**

→ 공동 작업물을 받아와서 내 개인 컴퓨터로 작업을 한 뒤, 공동 작업물에 합칠 수 있도록 진행하는 것

### 1. 이슈 템플릿에 맞춰 원본(메인) 레포에 이슈를 생성합니다.
- New issue를 클릭하여 이슈를 생성합니다.
- 이슈 한 개는 보통 뷰 하나 기준으로 만듭니다. (한 뷰에 주요 기능이 너무 많다면 쪼개기)
- Issue 제목 : **[라벨이름] (동사원형) (작업주제)**  
    - ex) [Feat] 생성 MainView / [Asset] 추가 color set
- 템플릿을 작성해줍니다. (이때 특히, Todo를 자세하게 적어주세요! 최대한 쪼개서!)

### 2. 이슈를 만들면 이슈 제목에 이슈 번호가 생성되는데, (ex) ~/#7)
로컬에 **타입/#이슈번호** 브랜치를 생성합니다.  
    - 브랜치 이름 : **타입/이슈번호**
        - ex. Feat/1

```bash
git branch Feat/1    // 이슈번호1의 브랜치 생성
```

### 3. 해당 브랜치로 이동하여 작업을 합니다.

```bash
git switch Feat/1    // 해당 브랜치로 변경
```

### 4. 작업이 끝난 뒤, add와 commit을 진행합니다.
 - 커밋 메세지 : **타입/#이슈번호: 커밋메세지**  
    - ex. Feat/#1: 추가 Question1

```bash
git add .    //작업 요소를 더해줌
git commit -m "Feat/#1: 추가 Question1"    //무엇을 했는지 메세지로 작성
```

### 5. 내가 작업을 하는 도중에 다른 사람이 작업을 진행하여 원본(메인)레포가 변경되어 있을 수도 있으니,
(확인을 위해) pull을 한 번  진행해준다.

```bash
git pull upstream develop    //원본(메인)레포의 파일을 불러온다.
```

### 6. 에러가 나지 않았다면, origin에서 작업한 내용을 push해준다.

```bash
git push -u origin <브랜치명>    //해당 브랜치를 올리고자 한다.
```

### 7. PR을 통해 코드 리뷰를 진행한 뒤, approve를 해준다면 merge를 한다.

### PR 요청 시

- Reviewers 자신 제외 모두 체크
- Assignees 자기 자신 추가
- Labels 이슈와 동일하게 추가
- 수정 필요 시 수정하기

### 8. 기본 브랜치로 돌아옵니다.

```bash
git switch develop
```

### 9. <반복 시작> 다시 진행을 하며 작업을 반복하면 됩니다.

</div>
</details>

##  깃 라벨 & 커밋 타입

| **제목** | **설명** |
| --- | --- |
| **Feat** | 기능 구현 이슈 |
| **Bug** | 버그 수정 |
| **Docs** | 문서 작성 이슈 |
| **Asset** | asset 파일(이미지, 아이콘 등) 추가 |
| **Renamed** | 리소스 이동, 이름 변경 |
| **UI** | UI 관련 |
| **Delete** | 코드/파일 삭제 |
| **Text** | 텍스트 또는 리터럴 추가 및 수정 |
| **Comment** | 주석 추가/수정 |
| **Setting** | 프로젝트 세팅 |

### 브랜치 이름 구조

**타입/#이슈번호**

ex. Feat/1

### ☁️ 커밋 구조

**타입/#이슈번호: 커밋메세지**

ex. Feat/#1: 추가 Question1

### ☁️ Issue

- 이슈 한 개는 보통 뷰 하나 기준으로 만듭니다. (한 뷰에 주요 기능이 너무 많다면 쪼개기)
- Issue 제목 : **[라벨이름] (동사원형) (작업주제)**
ex) [Feat] 생성 MainView / [Asset] 추가 color set
- 템플릿을 작성해줍니다. (이때 특히, Todo를 자세하게 적어주세요! 최대한 쪼개서!)
    - ex)
        - 팝업창
        - 8개의 카드와 글씨 (카드 안에는 일러스트)
        - 마지막 2개로 결승전 진행
        - 최종 결과 저장하기
- 완료 시 Issue를 닫습니다.
- Git Issue Template, PR → 양식 가져오기.

### ☁️ **Pull Reqeust**

- Issue 제목과 **동일하게** 제목을 작성한다.
- 템플릿 안에 내용을 채워준다. (아는 지식, 모르겠는 부분, 팀원들과 공유하고싶은 부분 모두 자세하게~)
- 이슈에서 쓴 라벨을 붙여준다.
- 본인 제외 한 명의 팀원의 Approve가 있어야 merge가 가능하다.
    - + 혼자서 할 수 있게끔 열어둠 (특정 상황에서만 사용)
- 리뷰어들은 단순히 approve를 한다기보다 코드 변화를 체크하고 네임컨벤션을 지키고 있는지를 확인한다.

<hr>

## 주의할 것
- Firebase 연동에 필요한 GoogleService-Info.plist는 페페에게 에어드랍으로 받을 것 (보안) [파이어베이스 공식문서](https://firebase.google.com/docs/ios/setup?hl=ko)
