# Graph Report - .  (2026-11-22)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 733 nodes · 954 edges · 97 communities (57 shown, 40 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 6 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `9abcfbf2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- CheckSkillTests
- Path
- InventoryState
- iOS architecture contract
- interface
- What You Must Do When Invoked
- YamlParser
- Beautiful iOS
- iOS best practices
- 2. Categories, in ranking order
- iOS platform digest
- BestPractices
- A worked review: the inventory screen
- Swift strict for iOS
- SwiftUI patterns
- graphify reference: extra exports and benchmark
- check_repo
- iOS port
- PackageTests
- run
- SwiftLintConfig
- `<app>` iOS Platform Reviewer
- `<app>` Package Boundary Reviewer
- `<app>` SwiftUI UDF Reviewer
- `<app>` Architect
- `<app>` Build Resolver
- `<app>` Code Explorer
- `<app>` Code Reviewer
- `<app>` Planner
- `<app>` TDD Guide
- `<app>` iOS Security Reviewer
- `<app>` Test Author
- `<app>` add-package skill
- `<app>` add-port skill
- `<app>` add-route skill
- `<app>` add-slice skill
- <app> Claim Check skill
- <app> Clean-Room Rebuild skill
- <app> Corpus Retrieval skill
- <app> Diagnosing Bugs skill
- <app> Domain Modeling skill
- <app> Grilling skill
- `<app>` learn skill
- `<app>` plan skill
- <app> Research skill
- `<app>` review skill
- `<app>` ship skill
- `<app>` spec skill
- <app> TDD skill
- <app> Verified Status skill
- <app> Visual Review skill
- graphify reference: query, path, explain
- build
- beautifulios — agent instructions
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- guard-bash.sh
- /add-package
- /add-port
- /add-route
- /add-slice
- /claim-check
- /clean-room-rebuild
- /corpus-retrieval
- /diagnosing-bugs
- /domain-modeling
- /grilling
- /learn
- /plan
- /research
- /review
- /ship
- /spec
- /tdd
- /verified-status
- /visual-review
- Playbooks for `beautifulios` — load on demand
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- CLAUDE.md
- README.md
- CREDITS.md
- CREDITS.md
- CREDITS.md
- CREDITS.md
- CREDITS.md
- extraction-spec.md
- CREDITS.md
- CREDITS.md
- CREDITS.md
- CREDITS.md
- CREDITS.md
- Package.swift
- check-build.sh
- check-lints.sh

## God Nodes (most connected - your core abstractions)
1. `CheckSkillTests` - 37 edges
2. `build_valid_repo()` - 32 edges
3. `Checker` - 26 edges
4. `write()` - 24 edges
5. `YamlParser` - 16 edges
6. `iOS best practices` - 16 edges
7. `Beautiful iOS` - 15 edges
8. `interface` - 14 edges
9. `What You Must Do When Invoked` - 12 edges
10. `add_portable_plugin()` - 11 edges

## Surprising Connections (you probably didn't know these)
- `problems_to_json()` --references--> `Any`  [EXTRACTED]
  scripts/check-skill.py →   _Bridges community 6 → community 1_

## Import Cycles
- None detected.

## Communities (97 total, 40 thin omitted)

### Community 0 - "CheckSkillTests"
Cohesion: 0.16
Nodes (10): add_portable_plugin(), build_valid_repo(), CheckSkillTests, error_messages(), formatted(), load_checker(), png_header(), portable_with() (+2 more)

### Community 1 - "Path"
Cohesion: 0.16
Nodes (17): check_repo(), Checker, _fold_block(), format_problem(), _is_relative(), _json_key_line(), main(), _normalize_url() (+9 more)

### Community 2 - "InventoryState"
Cohesion: 0.07
Nodes (25): Equatable, InventoryModel, InventoryState, empty, error, loading, ready, String (+17 more)

### Community 3 - "iOS architecture contract"
Cohesion: 0.06
Nodes (25): Added, Changelog, [Unreleased], Contributing, Good first contributions, License, Making a change, Style (+17 more)

### Community 4 - "interface"
Cohesion: 0.07
Nodes (29): author, name, url, interface, publication, description, extensions, com.openai (+21 more)

### Community 5 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 6 - "YamlParser"
Cohesion: 0.25
Nodes (8): Any, Exception, _parse_quoted(), parse_yaml(), Small YAML subset: maps, lists, quoted scalars, | and > blocks., _split_flow(), YamlError, YamlParser

### Community 7 - "Beautiful iOS"
Cohesion: 0.11
Nodes (18): A worked example, Agent kit (Claude Code), Any agent, Architecture diagrams, Beautiful iOS, Claude Code, Contributing, Install (+10 more)

### Community 8 - "iOS best practices"
Cohesion: 0.12
Nodes (16): 10. Push notifications (APNs), 11. Security, 12. Performance, 13. Testing, 14. Cross-skill contract, 1. Mindset, 2. Before you hand back code, 3. Platform facts (+8 more)

### Community 9 - "2. Categories, in ranking order"
Cohesion: 0.12
Nodes (16): 1. Report shape, 2. Categories, in ranking order, 3. Waived gates, 4. How to review, 5. Worked example, 6. Cross-skill contract, Architecture contracts (always Must fix, ranked first), Data, offline and outbox (+8 more)

### Community 10 - "iOS platform digest"
Cohesion: 0.17
Nodes (11): 10. Testing, 1. Toolchain and policy, 2. UI, 3. Concurrency, 4. Data, 5. Push, 6. Navigation and deep links, 7. Device tiers (+3 more)

### Community 11 - "BestPractices"
Cohesion: 0.29
Nodes (4): BestPractices, bp_body(), ReviewSkill, rv_body()

### Community 12 - "A worked review: the inventory screen"
Cohesion: 0.20
Nodes (9): A worked review: the inventory screen, Must fix, Should fix, The fixed module, The module under review, The report, Verdict, Waived gates (+1 more)

### Community 13 - "Swift strict for iOS"
Cohesion: 0.20
Nodes (9): 1. The subset, 2. Sealed state, 3. Isolation, 4. Errors, 5. Foundation discipline, 6. SwiftUI type rules, 7. SwiftLint and swift-format, 8. Review questions (+1 more)

### Community 14 - "SwiftUI patterns"
Cohesion: 0.20
Nodes (9): 1. The UDF ViewModel, 2. State ownership, 3. Navigation, 4. Lists and images, 5. Effects and lifecycle, 6. Accessibility, 7. Localization, 8. Testing (+1 more)

### Community 15 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 16 - "check_repo"
Cohesion: 0.39
Nodes (8): check_balance(), check_repo(), cpp_blocks(), doc_files(), main(), Path, Yield (start_line, code) for each swift fenced block., Return (line_offset, message) or None. Comments/literals are skipped.

### Community 17 - "iOS port"
Cohesion: 0.22
Nodes (8): 1. The order of work, 2. React Native → native iOS, 3. UIKit/Storyboard → SwiftUI as code, 4. Web → iOS, 5. Behavior parity checklist, 6. What not to do, 7. Cross-skill contract, iOS port

### Community 19 - "run"
Cohesion: 0.36
Nodes (4): CompletedProcess, BuildGate, Gates, run()

### Community 21 - "`<app>` iOS Platform Reviewer"
Cohesion: 0.29
Nodes (6): `<app>` iOS Platform Reviewer, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 22 - "`<app>` Package Boundary Reviewer"
Cohesion: 0.29
Nodes (6): `<app>` Package Boundary Reviewer, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 23 - "`<app>` SwiftUI UDF Reviewer"
Cohesion: 0.29
Nodes (6): `<app>` SwiftUI UDF Reviewer, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 24 - "`<app>` Architect"
Cohesion: 0.29
Nodes (6): `<app>` Architect, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 25 - "`<app>` Build Resolver"
Cohesion: 0.29
Nodes (6): `<app>` Build Resolver, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 26 - "`<app>` Code Explorer"
Cohesion: 0.29
Nodes (6): `<app>` Code Explorer, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 27 - "`<app>` Code Reviewer"
Cohesion: 0.29
Nodes (6): `<app>` Code Reviewer, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 28 - "`<app>` Planner"
Cohesion: 0.29
Nodes (6): `<app>` Planner, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 29 - "`<app>` TDD Guide"
Cohesion: 0.29
Nodes (6): `<app>` TDD Guide, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 30 - "`<app>` iOS Security Reviewer"
Cohesion: 0.29
Nodes (6): `<app>` iOS Security Reviewer, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 31 - "`<app>` Test Author"
Cohesion: 0.29
Nodes (6): `<app>` Test Author, Core Mission, Expertise Areas, Guiding Principles, Output Format, Quality Standards

### Community 32 - "`<app>` add-package skill"
Cohesion: 0.29
Nodes (6): `<app>` add-package skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 33 - "`<app>` add-port skill"
Cohesion: 0.29
Nodes (6): `<app>` add-port skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 34 - "`<app>` add-route skill"
Cohesion: 0.29
Nodes (6): `<app>` add-route skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 35 - "`<app>` add-slice skill"
Cohesion: 0.29
Nodes (6): `<app>` add-slice skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 36 - "<app> Claim Check skill"
Cohesion: 0.29
Nodes (6): <app> Claim Check skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 37 - "<app> Clean-Room Rebuild skill"
Cohesion: 0.29
Nodes (6): <app> Clean-Room Rebuild skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 38 - "<app> Corpus Retrieval skill"
Cohesion: 0.29
Nodes (6): <app> Corpus Retrieval skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 39 - "<app> Diagnosing Bugs skill"
Cohesion: 0.29
Nodes (6): <app> Diagnosing Bugs skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 40 - "<app> Domain Modeling skill"
Cohesion: 0.29
Nodes (6): <app> Domain Modeling skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 41 - "<app> Grilling skill"
Cohesion: 0.29
Nodes (6): <app> Grilling skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 42 - "`<app>` learn skill"
Cohesion: 0.29
Nodes (6): `<app>` learn skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 43 - "`<app>` plan skill"
Cohesion: 0.29
Nodes (6): `<app>` plan skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 44 - "<app> Research skill"
Cohesion: 0.29
Nodes (6): <app> Research skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 45 - "`<app>` review skill"
Cohesion: 0.29
Nodes (6): `<app>` review skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 46 - "`<app>` ship skill"
Cohesion: 0.29
Nodes (6): `<app>` ship skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 47 - "`<app>` spec skill"
Cohesion: 0.29
Nodes (6): `<app>` spec skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 48 - "<app> TDD skill"
Cohesion: 0.29
Nodes (6): <app> TDD skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 49 - "<app> Verified Status skill"
Cohesion: 0.29
Nodes (6): <app> Verified Status skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 50 - "<app> Visual Review skill"
Cohesion: 0.29
Nodes (6): <app> Visual Review skill, Core Principles, Output Format, Research References, Rules, When to Activate

### Community 51 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 52 - "build"
Cohesion: 0.53
Nodes (5): build(), main(), package_files(), Path, Files to package, relative to root, in a stable order.

### Community 53 - "beautifulios — agent instructions"
Cohesion: 0.50
Nodes (3): beautifulios — agent instructions, graphify, Model routing (Claude Code + Ollama)

### Community 54 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 55 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 56 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 57 - "guard-bash.sh"
Cohesion: 0.83
Nodes (3): has(), has_i(), guard-bash.sh script

## Knowledge Gaps
- **364 isolated node(s):** `PackageDescription`, `Observation`, `loading`, `empty`, `ready` (+359 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **40 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Beautiful iOS` connect `Beautiful iOS` to `iOS architecture contract`?**
  _High betweenness centrality (0.003) - this node is a cross-community bridge._
- **What connects `PackageDescription`, `Observation`, `loading` to the rest of the system?**
  _370 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `InventoryState` be split into smaller, more focused modules?**
  _Cohesion score 0.0746031746031746 - nodes in this community are weakly interconnected._
- **Should `iOS architecture contract` be split into smaller, more focused modules?**
  _Cohesion score 0.0625 - nodes in this community are weakly interconnected._
- **Should `interface` be split into smaller, more focused modules?**
  _Cohesion score 0.06666666666666667 - nodes in this community are weakly interconnected._
- **Should `What You Must Do When Invoked` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._
- **Should `Beautiful iOS` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._