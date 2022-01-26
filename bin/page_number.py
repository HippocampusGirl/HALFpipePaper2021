#!/usr/bin/env python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser
import re

from fitz import Document


def aux_label(aux_file: str, label: str):
    with open(aux_file) as file_handle:
        lines = file_handle.readlines()

    newlabel_pattern = re.compile(r"\\newlabel\{(?P<label>.*?)\}\{\{(?P<label_number>\d+)\}\{(?P<page_number>\d+)\}(?:\{.*\})*\}")

    for line in lines:
        m = newlabel_pattern.fullmatch(line.strip())

        if m is None:
            continue

        if m.group("label").lower() == label.lower():
            page_number = m.group("page_number")
            print(f"Page {page_number}")


def pdf_section(pdf_file: str, section: str):

    document = Document(args.pdf_file)
    table_of_contents = document.get_toc(simple=False)

    page_number = None
    for _, title, page_number, _ in table_of_contents:
        if title.lower() == section.lower():
            break

    assert page_number is not None

    page = document.load_page(page_number - 1)

    line_number = 1

    blocks = page.get_text("blocks")
    for block in blocks:
        x0 = block[0]
        lines = block[4].strip().split("\n")

        if lines[0].lower() == section.lower():
            print(f"Page {page_number:d}, line {line_number:d}")
            break

        if 169 < x0 < 190:
            line_number += len(lines)


def pdf_text(pdf_file: str, text: str):
    document = Document(args.pdf_file)

    page_number = 0
    for page in document:
        page_number += 1
        line_number = 0

        blocks = page.get_text("blocks")
        # print(page_number, blocks)
        for block in blocks:
            x0 = block[0]
            lines = block[4].strip().split("\n")

            if x0 < 169 or x0 > 190:
                continue  # not main text

            for line in lines:
                line_number += 1
                if text.lower() in line.lower():
                    print(f"Page {page_number:d}, line {line_number:d}")


if __name__ == "__main__":
    parser = ArgumentParser()

    input_group = parser.add_mutually_exclusive_group(required=True)
    input_group.add_argument("--pdf-file")
    input_group.add_argument("--aux-file")

    query_group = parser.add_mutually_exclusive_group(required=True)
    query_group.add_argument("--section")
    query_group.add_argument("--text")
    query_group.add_argument("--label")

    args = parser.parse_args()

    if args.pdf_file is not None:
        if args.section is not None:
            pdf_section(args.pdf_file, args.section)
        elif args.text is not None:
            pdf_text(args.pdf_file, args.text)
        else:
            raise ValueError()
    elif args.aux_file is not None:
        if args.label is not None:
            aux_label(args.aux_file, args.label)
        else:
            raise ValueError()
    else:
        raise ValueError()
