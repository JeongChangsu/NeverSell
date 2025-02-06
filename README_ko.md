
---

[영문 버전 보러가기](./README.md)

---

# NeverSell

**NeverSell**은 암호화폐 거래소나 지갑과 연동하여 정기적으로 비트코인을 적립 매수(DCA)하도록 자동화하는 오픈소스 프로젝트입니다. “절대 팔지 않는다(Never Sell)”라는 장기 투자 관점으로, 시세 변동에 흔들리지 않고 꾸준히 매수해 포트폴리오를 축적하도록 돕습니다.

---

## 프로젝트 소개

**NeverSell**은 바이낸스(Binance) 등 거래소 API 키를 연결해 일정 주기로 자동 매수를 실행합니다. 초기에는 간단한 CLI(커맨드라인 툴) 형태로 핵심 로직을 검증했으며, 이제 본격적인 모바일 앱으로 확장할 예정입니다. 장기적으로는 여러 거래소/지갑 지원, DIP 매수 같은 고급 전략, 구독 모델 등을 고려하고 있습니다. 자동 DCA를 통해 시장 타이밍보다 꾸준한 매집에 집중함으로써 투자 효율을 높이는 것을 목표로 합니다.

**주요 목표:**

- **자동 DCA 매수**: 바이낸스 등 거래소 API를 통해 일정 주기에 BTC를 반복 매수  
- **모바일 앱 제공**: 앱에서 손쉽게 DCA 현황을 모니터링하고 설정 변경  
- **고급 전략**: 시세 급락 시 추가 매수(“buy the dip”) 등 확장 기능  
- **멀티 거래소 지원**: Coinbase, Kraken, Bitfinex 등 주요 거래소/지갑 연동  
- **구독 모델**: 향후 프리미엄 기능(고급 전략, 우선 지원 등)을 유료 구독으로 제공  
- **오픈소스/커뮤니티**: 오픈소스 개발로 투명성 확보, 누구나 이슈/PR로 기여 가능

---

## 기술 스택 및 개발

여러 후보를 검토한 결과, **Phase 2** 이후의 핵심 스택을 다음과 같이 확정했습니다:

- **모바일 앱**: **Flutter (Dart)**  
  - iOS/Android를 단일 코드베이스로 개발 가능하며, 일관된 UI/UX와 뛰어난 성능을 제공

- **백엔드**: **Python FastAPI**  
  - 빠른 처리 속도, Pydantic 모델 기반의 입력/출력 검증, 자동 Swagger 문서 생성 등 장점  
  - DB는 PostgreSQL을 사용 예정

- **컨테이너/배포**: **Docker**  
  - FastAPI와 PostgreSQL을 Docker로 컨테이너화해, 개발/테스트/운영 환경을 표준화  
  - Docker Compose로 멀티 컨테이너(백엔드 + DB) 구성

- **CLI 프로토타입(Phase 1)**  
  - Python 기반으로 `python-binance` 등의 라이브러리를 활용해 DCA 로직 MVP 완성 (이미 완료)

---

## 설치 및 사용 방법 (CLI 프로토타입)

> **참고**: 현재 CLI 버전은 **Phase 1**에 해당합니다. **Flutter** 모바일 앱과 **FastAPI** 백엔드는 Phase 2 로드맵을 따라 개발 중이며, 완성 시 별도의 사용 가이드를 추가할 예정입니다.

1. **사전 준비**  
   - Python 3.x  
   - 바이낸스 계정(거래 권한 API 키 발급, 출금 권한은 비활성)

2. **설치**  
   ```bash
   git clone https://github.com/JeongChangsu/never-sell.git
   cd never-sell
   pip install -r requirements.txt
   ```

3. **환경 설정**  
   - 환경 변수 `BINANCE_API_KEY`, `BINANCE_API_SECRET` 설정  
   **또는** `.env` / `config.yml` 파일 등에 키를 안전하게 저장(.gitignore로 보호)

4. **CLI 실행**  
   ```bash
   python neversell_cli.py --interval 7d --amount 50
   ```
   - 7일마다 50달러 상당의 BTC 매수 예시  
   - `--help`로 추가 옵션 확인 가능

5. **로그**  
   - 매수 시각, 체결 가격, 매수 수량 등이 콘솔/로그 파일에 기록

6. **중지**  
   - 반복 실행 중이라면 `Ctrl + C`로 종료  
   - 장기 자동화를 원하면 OS 스케줄러(크론 등) 사용 가능.  
   - 차후에는 백엔드 스케줄링 기능으로 대체할 계획

---

## 로드맵

NeverSell 로드맵은 단계별로 기능과 목표를 정의합니다. **Phase 1**(CLI)까지 완료되었고, **Phase 2**부터 모바일 앱 및 백엔드를 본격 개발합니다. Phase 3~5는 향후 고급 기능, 구독 모델로 확장하는 내용을 다룹니다.

### **Phase 1 (완료)**  
- [x] **기술 스택 선정 & 환경 설정** (Python CLI 프로토타입)  
- [x] **바이낸스 API 연동 & 기본 DCA 구현**  
- [x] **API 키 입력 & 안전 보관**  
- [x] **CLI DCA 실행 & 로깅**

### **Phase 2: 모바일 앱 & 백엔드 개발**

아래는 **컨설팅 결과**를 바탕으로 확정된 Phase 2 로드맵입니다:

1. **기술 스택 확정 및 개발 환경 설정**  
   - Flutter SDK 설치(iOS/Android 에뮬레이터 설정)  
   - FastAPI용 Python 가상환경 구성, pytest/flake8 등 설치  
   - Flutter 프로젝트 및 FastAPI 프로젝트 초기화, 디렉터리 구조 정비  
   - Docker, PostgreSQL 설정 확정

2. **요구사항 재정의 및 설계**  
   - Phase 1 아이디어를 구체화해 모바일 화면과 백엔드 API 엔드포인트 목록 작성  
   - 예: 로그인/회원가입, 아이템 목록 조회, 아이템 상세/거래 등  
   - ERD(데이터베이스 구조) 설계, 주요 기능별 유저 스토리 도출

3. **UI/UX 디자인 및 프로토타이핑**  
   - 핵심 화면 와이어프레임/목업 작성  
   - Flutter Material/Cupertino 위젯을 활용해 일관된 디자인 시스템 구성  
   - Phase 1에서 이미 디자인이 일부 끝났다면 보완/확인 후 반영

4. **백엔드 핵심 기능 개발 (FastAPI)**  
   - PostgreSQL 스키마 설계, SQLAlchemy 모델 정의  
   - JWT 인증(OAuth2)으로 /auth/login, /auth/signup 구현  
   - 아이템(Item) 관련 API(/items, /items/{id}, 생성/수정/삭제 등) 개발  
   - Pydantic 모델로 요청/응답 검증, Swagger UI 확인, pytest로 단위 테스트

5. **모바일 앱 개발 (Flutter)**  
   - 프로젝트 셋업(폴더 구조, 라우팅 등)  
   - 로그인/회원가입 화면 구현, FastAPI 연동(dio/http 패키지)  
   - JWT 토큰 안전 저장(secure storage) 및 API 호출 시 헤더에 포함  
   - 메인/아이템 목록/상세/생성/수정 UI 구현 & 백엔드 연동  
   - iOS/Android 플랫폼별 UX 차이 점검

6. **통합 테스트 및 품질 개선**  
   - Flutter 앱 ↔ FastAPI 백엔드 연동 테스트 (로그인, 데이터 조회/생성 등)  
   - 에뮬레이터(iOS/Android)에서 시나리오 점검 (네트워크 단절, 잘못된 입력 등)  
   - 오류/버그 수정, 성능 점검(동시 요청 시 응답 속도, DB 인덱스 검토)  
   - Flutter 릴리스 빌드 최적화(불필요 패키지 제거, ProGuard 등 고려)

7. **Docker 컨테이너 구성**  
   - FastAPI 백엔드용 Dockerfile 작성, 이미지 빌드 테스트  
   - PostgreSQL도 Docker로 로컬 테스트, docker-compose.yml 구성  
   - .env 등 민감정보가 이미지에 포함되지 않도록 주의  
   - README에 Docker 빌드/실행 방법 문서화

8. **1차 배포 (클라우드 인스턴스)**  
   - DigitalOcean 등에서 Ubuntu 서버 생성, 보안 설정  
   - Docker + Compose 설치 후, 빌드한 이미지 배포  
   - docker-compose로 백엔드 + DB 구동  
   - Nginx 리버스 프록시 및 SSL 인증서(Let’s Encrypt) 설정  
   - https://api.neversell.com (가칭) 등 도메인 연결, 외부 접근 테스트

9. **모바일 앱 배포 준비**  
   - iOS TestFlight, 구글 플레이 내부 테스트 등 설정  
   - 앱 아이콘, 스플래시, 개인정보처리방침 등 스토어 요구사항 충족  
   - v0.1.0 베타 업로드 후 피드백 수렴  
   - 기기별 이슈 수정, 스크린샷/설명 등 마켓 메타데이터 정리

10. **문서 정리 및 코드 리팩토링**  
   - README.md에 Phase 2 진행 내용과 사용 방법 정리  
   - API 명세(Swagger UI 또는 요약) 문서화  
   - TODO/미뤄둔 기능 리팩토링, 코드 스타일 통일  
   - Phase 3를 위한 새 요구사항/아이디어 정리

> **Phase 2 목표**: Flutter 모바일 앱과 FastAPI 백엔드를 완성하고, Docker 기반으로 클라우드에 배포해 베타 버전(내부 테스트용)을 제공하는 것입니다.

### **Phase 3: DCA 전략 고도화 및 기능 확장**  
- [ ] **전략 리서치 & 최적화** (변동성 기반 매수, 자동 조정 등)  
- [ ] **DIP 매수 기능**  
- [ ] **멀티 거래소 & 지갑 연동**  
- [ ] **실시간 시세 모니터링**  

### **Phase 4: 구독 모델 & 상용화**  
- [ ] **결제 시스템 연동** (Stripe 등)  
- [ ] **구독 티어 및 관리**  
- [ ] **자동 결제 & 갱신**  
- [ ] **추가 프리미엄 기능**  

### **Phase 5: 커뮤니티 & 오픈소스 확장**  
- [ ] **오픈소스 기여 가이드** (CONTRIBUTING.md, PR 템플릿 등)  
- [ ] **문서화 확대** (문서 사이트, Wiki)  
- [ ] **커뮤니티 활성화** (Discord, Slack, GitHub Discussions)  
- [ ] **피드백 통합**  
- [ ] **프로젝트 홍보 & 론칭**  

---

## 기여 방법

프로젝트에 기여하고 싶다면 언제든지 이슈/PR을 남겨주세요. 다음 가이드를 참고 부탁드립니다:

- **Fork & Branch**: 새로운 기능 또는 버그 수정 시 브랜치를 따로 만들어 작업  
- **코드 스타일**: Python(PEP8) / Flutter(Dart style guide) 준수 권장  
- **PR**: 변경 내용을 상세히 설명하고, 관련 이슈가 있다면 연결  
- **테스트**: FastAPI는 pytest, Flutter는 flutter test를 통해 기본 동작 확인  
- **커뮤니케이션**: 이슈/PR 외에도 커뮤니티(추후 개설)에서 논의 가능

---

## 결론

이제 **Phase 2**에서 NeverSell은 CLI를 넘어 **Flutter 모바일 앱**과 **FastAPI 백엔드**를 갖춘 서비스로 발전합니다. Docker를 이용해 일관된 환경에서 개발·배포함으로써, 누구나 쉽게 직접 설치·운영할 수 있는 형태를 목표로 합니다.

“절대 팔지 않는다(Never Sell)”라는 장기 투자 철학을 더 많은 유저가 편리하게 경험할 수 있도록, 앞으로도 꾸준히 개선하고 확장해나가겠습니다.

**Happy DCA & Never Sell!**

---