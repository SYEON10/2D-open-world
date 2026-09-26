# Godot 코딩 컨벤션

기준: Godot 4.7 GDScript 공식 스타일 가이드와 프로젝트·씬 구성 가이드. 이 문서의 폴더 배치는 이 프로젝트의 규칙이다.

## 이름과 파일

| 대상 | 형식 | 예 |
| --- | --- | --- |
| 폴더, 파일, 변수, 함수, 신호 | `snake_case` | `cube_settings.tres`, `movement_speed` |
| `class_name`, 노드 이름, enum 타입 | `PascalCase` | `CubeSettings`, `PlayerCamera` |
| 상수, enum 멤버 | `CONSTANT_CASE` | `DEFAULT_SPEED` |
| 내부 멤버 | `_` 접두사 | `_apply_movement()` |

신호는 이미 발생한 일을 표현한다. 예: `health_changed`, `item_collected`. 공백·한글·대문자 혼합 파일명은 피한다.

## GDScript 작성
- UTF-8, LF, 마지막 줄바꿈, 탭 들여쓰기, 한 줄 100자 내외를 사용한다.
- 함수의 매개변수와 반환 타입을 명시한다. 명확한 초기값은 `:=`로 추론한다.
- 변수와 상수는 가능한 좁은 범위에 선언한다. 프레임마다 변하지 않는 참조는 `@onready`, 내보낸 `Resource`, `preload()` 중 적합한 방식으로 한 번 연결한다.
- `and`, `or`, `not`을 사용하고 문장 하나를 한 줄에 둔다.
- 선언 순서: 주석/애너테이션, `class_name`, `extends`, 신호, enum, 상수, `@export`, 일반 변수, `@onready`, 생명주기 메서드, 공개 메서드, 내부 메서드.
- 물리 이동은 `_physics_process(delta)`에서 수행한다. 입력 매핑은 프로젝트 설정을 사용하고 키를 스크립트 곳곳에 흩뿌리지 않는다.

## 씬과 신호
- 액터 씬은 단독으로 열 수 있게 만들고 내부 노드 경로는 그 씬 안에서만 관리한다.
- 부모가 자식에게 명령할 때 메서드를 호출한다. 자식이 발생한 사건을 알릴 때 신호를 내보낸다.
- 먼 씬의 노드를 절대 경로로 직접 참조하지 않는다. 여러 시스템이 공유할 상태만 별도 데이터·서비스로 분리한다.
- 읽기 쉬운 `.tscn`·`.tres` 텍스트 리소스를 기본으로 삼는다. 수작업 편집 후에는 Godot에서 다시 열어 참조를 확인한다.

## 검증과 커밋
- 변경 후 `scripts/check.ps1`로 리소스 가져오기와 파서 오류를 확인한다.
- 입력·카메라·충돌·렌더링은 실제 실행으로 확인한다.
- 제목은 `feat(actor): add cube movement`처럼 `type(scope): summary`로 작성한다. 가능한 `type`: `feat`, `fix`, `docs`, `refactor`, `perf`, `test`, `build`, `chore`.

## 근거
- [GDScript style guide](https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Static typing](https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/static_typing.html)
- [Project organization](https://docs.godotengine.org/en/4.7/tutorials/best_practices/project_organization.html)
- [Scene organization](https://docs.godotengine.org/en/4.7/tutorials/best_practices/scene_organization.html)
