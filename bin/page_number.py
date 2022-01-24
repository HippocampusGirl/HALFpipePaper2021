#!/usr/bin/env python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser

import fitz

parser = ArgumentParser()

parser.add_argument("--pdf-file")

parser.add_argument("--section")

args = parser.parse_args()

document = fitz.open(args.pdf_file)

table_of_contents = document.get_toc(simple=False)

page_number = None

for _, title, page_number, _ in table_of_contents:

    if title.lower() == args.section.lower():
        break

assert page_number is not None

page = document.load_page(page_number - 1)

blocks = page.get_text("blocks")

line_number = 1

for block in blocks:
    x0 = block[0]
    lines = block[4].strip().split("\n")

    if lines[0].lower() == args.section.lower():
        break

    import pdb; pdb.set_trace()

    if 169 < x0 < 190:
        line_number += len(lines)

print(f"page {page_number:d}, line {line_number:d}")
