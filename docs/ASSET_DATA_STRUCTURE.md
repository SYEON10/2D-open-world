# 에셋·데이터·폴더 구조

## 구조와 소유 범위

```text
assets/source/         사람이 제작하거나 외부에서 가져온 원본
assets/generated/      생성기로 재생성 가능한 에셋
data/definitions/      게임에서 참조하는 타입 있는 설정 리소스
scenes/actors/         독립적으로 배치할 수 있는 캐릭터·사물
scenes/levels/         실행 가능한 레벨 씬
scripts/actors/        액터의 동작
scripts/data/          Resource 타입 선언
scripts/tools/         에셋 생성기
docs/                  협업·규칙 문서
addons/                외부 Godot 플러그인
```

일반적인 에셋은 해당 폴더 아래에 기능 이름으로 묶는다. 기능이 커지면 관련 씬과 에셋을 같은 기능 폴더로 옮기되, 파일 참조와 UID가 보존되는지 에디터에서 확인한다.

## 에셋 추가
1. 코드 생성 에셋은 `scripts/tools/`에 생성기를 작성하고 `assets/generated/`에 출력한다. 생성기와 결과를 함께 커밋한다.
2. 예제 `cube_badge.svg`는 기본 Godot 아이콘의 파란 계열을 사용한 큐브 배지다. 다음 명령으로 동일한 파일을 만든다.

   ```powershell
   & $env:GODOT_BIN --headless --path . --script res://scripts/tools/generate_cube_badge.gd
   & $env:GODOT_BIN --headless --path . --script res://scripts/tools/generate_cube_texture.gd
   ```

   두 번째 생성기는 바이너리 `cube_checker.res` 텍스처를 만든다. MCP의 리소스 조회 검증에도 사용한다.

3. 외부 에셋은 `assets/source/`에 원본을 보관하고 원본 URL·작성자·라이선스·변경 사항을 같은 폴더의 `SOURCES.md`에 기록한다.
4. `.godot/` 캐시는 커밋하지 않는다. Godot가 생성한 `.import`·`.uid` 파일은 참조 안정성을 위해 추적한다.

## 데이터 추가
1. 여러 씬에서 사용할 설정은 `scripts/data/`에 `Resource` 하위 타입을 선언한다. 타입·범위·기본값을 명시한다.
2. `data/definitions/`에 텍스트 `.tres` 인스턴스를 만들고 씬의 내보낸 리소스 속성에 연결한다. 예제는 `cube_settings.tres`다.
3. 고정 참조는 씬 로드 시 처리한다. `_process` 또는 `_physics_process`에서 디스크 읽기·JSON 파싱·전체 폴더 검색을 하지 않는다.
4. 새 필드를 추가하면 기존 `.tres`와 이를 읽는 스크립트를 함께 갱신하고 Godot 가져오기 검사를 실행한다.

텍스트 리소스는 Git에서 차이를 확인하기 쉽고, 에디터에서 타입과 값을 편집할 수 있다. 대규모 레벨 데이터나 사용자 저장 파일은 별도 저장 형식을 정할 때까지 `data/definitions/`에 넣지 않는다.
