#!/usr/bin/env python3
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def remove_block_comments(s: str) -> str:
    return re.sub(r"/\*.*?\*/", "", s, flags=re.S)

def strip_line_comment(line: str) -> str:
    # remove // or # comments if they are not inside quotes
    def find_outside(pattern, text):
        idx = text.find(pattern)
        while idx != -1:
            before = text[:idx]
            # count of unescaped quotes
            dq = before.count('"') - before.count('\\"')
            sq = before.count("'") - before.count("\\'")
            if (dq % 2 == 0) and (sq % 2 == 0):
                return idx
            idx = text.find(pattern, idx+1)
        return -1

    for marker in ["//", "#"]:
        i = find_outside(marker, line)
        if i != -1:
            return line[:i].rstrip()
    return line

def process_file(path: Path):
    text = path.read_text()
    # handle heredocs: do not alter between <<IDENT and IDENT on its own line
    out_lines = []
    in_heredoc = False
    heredoc_id = None
    text = remove_block_comments(text)
    for line in text.splitlines():
        if not in_heredoc:
            m = re.search(r"<<-?\s*(\w+)", line)
            if m:
                in_heredoc = True
                heredoc_id = m.group(1)
                out_lines.append(line)
                continue
            stripped = line.lstrip()
            if stripped.startswith('#') or stripped.startswith('//'):
                continue
            new = strip_line_comment(line)
            out_lines.append(new)
        else:
            out_lines.append(line)
            if line.strip() == heredoc_id:
                in_heredoc = False
                heredoc_id = None

    new_text = '\n'.join(out_lines) + ('\n' if text.endswith('\n') else '')
    path.write_text(new_text)

def main():
    base = ROOT
    # target both gcp and aws modules
    for modules_dir in [base / 'gcp' / 'terraform' / 'modules', base / 'aws' / 'terraform' / 'modules']:
        if not modules_dir.exists():
            continue
        for tf in modules_dir.rglob('*.tf'):
            try:
                process_file(tf)
                print('Processed', tf)
            except Exception as e:
                print('Error processing', tf, e)

if __name__ == '__main__':
    main()
