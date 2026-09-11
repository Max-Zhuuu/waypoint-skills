#!/usr/bin/env python3
"""Minimal jq replacement for test scripts. Uses stdlib json only."""
import json
import sys
import os

# Force Unix-style line endings on stdout (Windows Python adds \r\n)
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(newline="\n")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(newline="\n")

def main():
    if len(sys.argv) < 3:
        print("Usage: json_query.py <command> <file> [args...]", file=sys.stderr)
        sys.exit(1)

    cmd = sys.argv[1]
    path = sys.argv[2]

    try:
        with open(path, encoding="utf-8-sig") as f:
            content = f.read().replace("\r\n", "\n")
            data = json.loads(content)
    except json.JSONDecodeError as e:
        if cmd == "validate":
            print(f"INVALID: {e}")
            sys.exit(1)
        raise
    except FileNotFoundError:
        print(f"NOT_FOUND: {path}", file=sys.stderr)
        sys.exit(2)

    if cmd == "validate":
        print("VALID")
    elif cmd == "get":
        # get field.subfield
        keys = sys.argv[3].split(".")
        val = data
        for k in keys:
            if isinstance(val, dict):
                val = val.get(k)
            else:
                val = None
                break
        if val is None:
            sys.exit(1)
        if isinstance(val, (dict, list)):
            print(json.dumps(val))
        else:
            print(val)
    elif cmd == "has":
        # has field.subfield - exit 0 if exists, 1 if not
        keys = sys.argv[3].split(".")
        val = data
        for k in keys:
            if isinstance(val, dict) and k in val:
                val = val[k]
            else:
                sys.exit(1)
        sys.exit(0)
    elif cmd == "count":
        # count field - print length of array
        keys = sys.argv[3].split(".")
        val = data
        for k in keys:
            val = val.get(k, []) if isinstance(val, dict) else []
        print(len(val) if isinstance(val, list) else 0)
    elif cmd == "list":
        # list field.*.subfield - extract from array of objects
        parts = sys.argv[3].split(".*.")
        if len(parts) == 2:
            arr_keys = parts[0].split(".")
            val_key = parts[1]
            arr = data
            for k in arr_keys:
                arr = arr.get(k, []) if isinstance(arr, dict) else []
            for item in arr:
                if isinstance(item, dict) and val_key in item:
                    v = item[val_key]
                    print(json.dumps(v) if isinstance(v, (dict, list)) else v)
        else:
            # list field - just list array items
            keys = sys.argv[3].split(".")
            val = data
            for k in keys:
                val = val.get(k, []) if isinstance(val, dict) else []
            for item in val:
                if isinstance(item, (dict, list)):
                    print(json.dumps(item))
                else:
                    print(item)
    elif cmd == "flat-list":
        # flat-list steps.reads - collect all arrays from array items
        parts = sys.argv[3].split(".", 1)
        arr_key = parts[0]
        sub_key = parts[1] if len(parts) > 1 else None
        arr = data.get(arr_key, [])
        for item in arr:
            if isinstance(item, dict) and sub_key:
                vals = item.get(sub_key, [])
                if isinstance(vals, list):
                    for v in vals:
                        print(v)
                elif vals:
                    print(vals)
    elif cmd == "steps-with":
        # steps-with enterprise=true - list steps matching a condition
        field, expected = sys.argv[3].split("=")
        expected_val = True if expected == "true" else False if expected == "false" else expected
        for step in data.get("steps", []):
            if step.get(field) == expected_val:
                print(json.dumps(step))
    else:
        print(f"Unknown command: {cmd}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
