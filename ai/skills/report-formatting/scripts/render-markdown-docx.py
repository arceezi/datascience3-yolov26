from __future__ import annotations

import os
import sys
from pathlib import Path

import pypandoc


def main() -> int:
    if len(sys.argv) < 4:
        print(
            "Usage: render-markdown-docx.py <input_md> <output_docx> <reference_docx> [repo_root]",
            file=sys.stderr,
        )
        return 2

    input_md = Path(sys.argv[1]).resolve()
    output_docx = Path(sys.argv[2]).resolve()
    reference_docx = Path(sys.argv[3]).resolve()
    repo_root = Path(sys.argv[4]).resolve() if len(sys.argv) > 4 else Path.cwd().resolve()

    output_docx.parent.mkdir(parents=True, exist_ok=True)

    resource_path = os.pathsep.join(
        [
            str(repo_root),
            str(repo_root / "deliverables"),
            str(input_md.parent),
        ]
    )

    extra_args = [
        f"--reference-doc={reference_docx}",
        f"--resource-path={resource_path}",
        "--standalone",
        "--wrap=preserve",
    ]

    pypandoc.convert_file(
        str(input_md),
        "docx",
        outputfile=str(output_docx),
        extra_args=extra_args,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
