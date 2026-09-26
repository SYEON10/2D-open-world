# 2DOpenWorld 작업 지침

프로젝트 루트는 이 파일이 있는 `2d-open-world/`이며 Godot 4.7.2 GDScript 프로젝트다. 현재 예제는 3D 큐브 이동 실험이다. 프로젝트 이름과 실제 게임 방향을 혼동하지 않는다.

## 작업 순서
1. 관련 `Tasks*.md`와 `docs/` 문서를 읽고 변경 범위를 정한다.
2. 기능별 경로에 씬·스크립트·리소스·에셋을 저장한다. `addons/`는 외부 플러그인 전용이다.
3. 코드 생성 에셋은 생성기를 먼저 수정하고 다시 실행한다. 생성 파일을 수동 수정하지 않는다.
4. `scripts/`와 `data/`의 변경 후 Godot 헤드리스 가져오기 검사를 실행한다.
5. 시각·입력·충돌 변경은 에디터 또는 실행 화면에서 추가 확인한다.
6. 커밋 제목은 `type(scope): summary` 형식으로 쓰고 `main` 브랜치에서 작업한다.

## 경로와 데이터
- `assets/source/`: 외부·수작업 원본. 출처와 라이선스를 기록한다.
- `assets/generated/`: `scripts/tools/`로 재생성 가능한 텍스트 에셋.
- `data/definitions/`: 작은 정적 설정을 타입 있는 `.tres`로 보관한다.
- `scenes/actors/`, `scenes/levels/`: 독립적으로 열 수 있는 씬.
- `scripts/actors/`, `scripts/data/`, `scripts/tools/`: 동작·리소스 타입·생성기.
- `.godot/`, `build/`, 비밀 정보는 버전 관리에서 제외한다. Godot의 `.import`와 `.uid` 보조 파일은 생성되면 추적한다.

데이터는 씬의 내보낸 `Resource` 참조 또는 `preload()`로 한 번 연결한다. 프레임마다 파일을 읽거나 폴더를 검색하지 않는다. 자세한 추가 절차는 `docs/ASSET_DATA_STRUCTURE.md`에 있다.

## 코드 규칙
파일·폴더·변수·메서드·신호는 `snake_case`, `class_name`과 노드명은 `PascalCase`, 상수는 `CONSTANT_CASE`로 쓴다. 매개변수와 반환값에는 타입을 쓰고, 신호는 일어난 사건을 과거형으로 명명한다. 씬 간 통신은 부모의 호출과 자식의 신호로 구성한다. 자세한 규칙은 `docs/CODING_CONVENTIONS.md`에 있다.

## 검증
Godot 실행 파일 경로는 `GODOT_BIN` 환경 변수로 전달한다. Windows 예시:

```powershell
$env:GODOT_BIN = 'C:\Users\k3880\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
./scripts/check.ps1
```

검증 명령이 통과해도 실제 입력과 화면 상태는 직접 확인한다.
