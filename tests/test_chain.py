#!/usr/bin/env python3
"""Verify chain graph assembled from all skill.json is consistent."""
import json
import sys
from pathlib import Path

def main():
    repo = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    errors = 0

    categories = {
        line.strip()
        for line in (repo / "skill-categories.txt").read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    }

    skills = {}  # name -> skill.json data
    for skill_json in sorted(repo.rglob("skill.json")):
        # Only look in skill directories
        rel = skill_json.relative_to(repo)
        parts = rel.parts
        if parts[0] not in categories:
            continue
        with open(skill_json, encoding="utf-8") as f:
            data = json.load(f)
        skills[data["name"]] = data

    print(f"Found {len(skills)} skills with skill.json")

    # Check: every chain.to target names a real skill
    all_edges = []
    for name, data in skills.items():
        for edge in data.get("chain", {}).get("to", []):
            target = edge["target"]
            all_edges.append((name, target, edge.get("type", "?")))
            if target not in skills:
                print(f"FAIL: {name} chains to '{target}' which is not a known skill")
                errors += 1

    # Check: core path connected (triage -> spec -> breakdown -> tdd -> review)
    core = [("triage", "spec"), ("spec", "breakdown"), ("breakdown", "tdd"), ("tdd", "review")]
    edge_set = {(src, tgt) for src, tgt, _ in all_edges}
    for src, tgt in core:
        if (src, tgt) not in edge_set:
            print(f"FAIL: core chain broken: {src} does not chain to {tgt}")
            errors += 1

    # Check: no cycles in clean edges (excluding self-loops)
    clean_edges = [(s, t) for s, t, typ in all_edges if typ == "clean" and s != t]
    # Simple cycle detection via DFS
    adj = {}
    for s, t in clean_edges:
        adj.setdefault(s, []).append(t)

    visited = set()
    in_stack = set()
    def has_cycle(node):
        if node in in_stack:
            return True
        if node in visited:
            return False
        visited.add(node)
        in_stack.add(node)
        for nxt in adj.get(node, []):
            if has_cycle(nxt):
                return True
        in_stack.discard(node)
        return False

    for node in adj:
        if has_cycle(node):
            print(f"FAIL: cycle detected in clean edges involving {node}")
            errors += 1
            break

    print(f"\nClean edges: {len(clean_edges)}, Gate edges: {len(all_edges) - len(clean_edges) - sum(1 for s,t,_ in all_edges if s==t and _ == 'clean')}")

    if errors > 0:
        print(f"\nFAILED: {errors} error(s)")
        sys.exit(1)
    else:
        print(f"\nPASSED: chain graph consistent ({len(skills)} skills, {len(all_edges)} edges)")

if __name__ == "__main__":
    main()
