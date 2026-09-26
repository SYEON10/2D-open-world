# Godot MCP 선택·설치·기능

## 선택 근거

2026-09-26 기준 공개 저장소와 도구 설명을 비교했다. 요구 조건은 에디터가 읽은 씬 상태 조회, 기존 씬 수정, Godot 바이너리 리소스 정보 조회다.

| 후보 | 씬 읽기·수정 | 바이너리 리소스 정보 | 이 프로젝트에서의 판단 |
| --- | --- | --- | --- |
| [satelliteoflove/godot-mcp](https://github.com/satelliteoflove/godot-mcp) | 열린 씬 트리·속성 조회, 노드 속성 수정·재배치, 저장 | [`.res`, `.scn`, 압축 텍스처의 타입별 정보 조회](https://github.com/satelliteoflove/godot-mcp/blob/main/docs/tools/resource.md) | **선택**. Godot 4.7.2와 Node 24 환경에서 세 조건을 직접 검증함 |
| [hybridindie/godot-mcp](https://github.com/hybridindie/godot-mcp) | 애드온을 통한 폭넓은 편집 | 리소스 로드 기능 | Python 환경이 별도로 필요하고 도구 수가 많음 |
| [Vollkorn-Games/godot-mcp](https://github.com/Vollkorn-Games/godot-mcp) | 씬·스크립트 편집 | 바이너리 메타데이터 기능이 문서상 명확하지 않음 | 필수 조건 입증이 약함 |
| [Sarmkadan/godot-mcp](https://github.com/Sarmkadan/godot-mcp) | 텍스트 씬 작업 | 바이너리 내용 분석은 제한적 | 추가 .NET 환경이 필요함 |

선택한 패키지는 MIT 라이선스다. 프로젝트에 설치된 애드온의 라이선스는 `addons/godot_mcp/LICENSE`에 보관한다. 버전은 `4.1.11`로 고정했다.

## 현재 연결

- Godot 애드온: `addons/godot_mcp/`, 프로젝트 설정에서 활성화됨.
- MCP 서버: `tools/mcp/package.json`에 고정 설치. `node_modules/`는 Git에서 제외한다.
- `tools/mcp/.gdignore`로 Godot가 Node.js 패키지의 애드온 복사본을 중복 스캔하지 않게 한다.
- Codex 등록: `godot-mcp` 이름의 stdio 서버가 로컬 `dist/cli.js`를 실행한다.
- 애드온 통신: 실행 중인 Godot 에디터의 `127.0.0.1:6550` WebSocket.
- Godot 버전: `4.7.2`; MCP 애드온과 서버 버전: `4.1.11`.

다른 컴퓨터에서는 프로젝트 루트에서 다음을 실행한다.

```powershell
pnpm install --dir tools/mcp
$entry = (Resolve-Path 'tools/mcp/node_modules/@satelliteoflove/godot-mcp/dist/cli.js').Path
codex mcp add godot-mcp -- node $entry
```

Godot에서 이 프로젝트를 열고 **프로젝트 설정 → 플러그인 → Godot MCP**가 켜져 있는지 확인한다. Codex의 도구 목록은 서버 등록 후 새 작업에서 갱신된다. 연결이 안 되면 Godot 에디터가 열려 있는지, 애드온과 서버 버전이 같은지 확인한다. [원본 설치 안내](https://github.com/satelliteoflove/godot-mcp/blob/main/INSTALL.md)

## 할 수 있는 일

| 영역 | 주요 도구 | 작업 |
| --- | --- | --- |
| 씬 | `godot_scene` | 열기, 저장, 디스크 변경 다시 읽기 |
| 노드 | `godot_node_read`, `godot_node_edit` | 씬 트리·실효 속성 조회, 기존 노드 속성 변경·재배치 |
| 리소스 | `godot_resource` | 텍스트·바이너리 리소스의 타입과 세부 정보 조회 |
| 에디터 | `godot_editor_read`, `godot_editor_edit` | 선택 상태·로그·화면 조회, 게임 실행·정지, 파일 재검색 |
| 프로젝트 | `godot_project` | 버전·설정·입력 매핑·애드온 상태 조회 |
| 게임 검사 | `godot_input`, `godot_game_time`, `godot_runtime_state` | 입력 주입, 프레임 진행, 실행 중 상태 확인 |
| 제작 | 애니메이션·TileMapLayer·GridMap 도구 | 데이터 읽기와 편집 |
| 진단 | 메시·프로파일러·디버그 도구 | 메쉬 유효성, 성능 수치, 오류 확인 |

[전체 도구 목록](https://github.com/satelliteoflove/godot-mcp/blob/main/docs/tools/README.md)을 참조한다. 새 씬·노드 추가와 스크립트 연결은 `.tscn`을 작성하고 MCP로 열어 확인한다. 기존 노드 속성 편집과 재배치는 MCP로 직접 수행할 수 있다.

## 실제 검증 결과

`node scripts/tools/mcp_probe.mjs`가 MCP 프로토콜로 서버에 연결해 다음을 실행했다.

1. `godot_scene open`으로 `cube_playground.tscn`을 열었다.
2. `godot_node_read get_scene_tree`에서 `CubeActor`, `Floor`, `PlayerCamera`, `Sun`을 읽었다.
3. `godot_node_edit update`로 `Sun.light_energy`를 `1.25`로 바꾸고 저장했다. 다시 읽은 값도 `1.25`였다.
4. `godot_resource get_info`로 바이너리 `cube_checker.res`를 읽었다. `ImageTexture`, 폭과 높이 `16×16`을 반환했다.

MCP 검증에는 Godot 에디터가 실행 중이어야 한다. 별도로 `scripts/check.ps1`은 에디터 없이도 가져오기·데이터 로드·W 입력 이동을 검사한다.
