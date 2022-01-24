#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys

file_path = sys.argv[1]

with open(file_path) as file_handle:
    data = file_handle.read()

m = re.fullmatch(r"(?P<preamble>.+)(?P<document>\\begin\{document\}.+\\end\{document\}.*)", data, flags=re.DOTALL)

assert m is not None

preamble = m.group("preamble")
document = m.group("document")

# fix environments

fix = ""

dif_pattern = re.compile(r"\\DIFaddbegin(?:FL)?(?P<code>.+?)\\DIFaddend(?:FL)?", flags=re.DOTALL)
environment_pattern = re.compile(r"(?P<command>\\(?:begin|end)(?:\{.*?\}|\[.*?\])+)")

i = 0
for m in dif_pattern.finditer(document):
    m_start, m_end = m.span()

    fix += document[i:m_start]

    fix += "\\DIFaddbegin"

    code = m.group("code")

    j = 0
    is_open = True
    for n in environment_pattern.finditer(code):
        n_start, n_end = n.span()
        command = n.group("command")

        fix += code[j:n_start]

        if is_open:
            is_open = False
            fix += "\\DIFaddend"

        fix += command

        j = n_end

    fix += code[j:]

    if is_open:
        fix += "\\DIFaddend"

    i = m_end

fix += document[i:]

document = fix

# fix tables

environment_pattern = re.compile(r"(\\fboxsep)\\DIFaddFL\{(.*?)\}")
document = environment_pattern.sub(r"\g<1>\g<2>", document)

hhline_pattern = re.compile(r"\\DIFaddbegin(FL)?\s+(?P<code>\\hhline\{[-~\|]+\}\s*&?)\s*\\DIFaddend(FL)?")
document = hhline_pattern.sub(r"\g<code>", document)

fix = ""

tabular_pattern = re.compile(r"(?P<begin>\\begin\{tabularx\})(?P<code>.*?)(?P<end>\\end\{tabularx\})", flags=re.DOTALL)
dif_pattern = re.compile(r"\\DIFadd(?:begin|end)(?:FL)?")

i = 0
for m in tabular_pattern.finditer(document):
    m_start, m_end = m.span()

    fix += document[i:m_start]

    fix += m.group("begin")

    code = m.group("code")

    code = dif_pattern.sub("", code)

    fix += code

    fix += m.group("end")

    i = m_end

fix += document[i:]

document = fix

data = preamble + document

with open(file_path, "w") as file_handle:
    file_handle.write(data)
