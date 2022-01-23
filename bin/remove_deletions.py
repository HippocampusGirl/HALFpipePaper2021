#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys

file_path = sys.argv[1]

with open(file_path) as file_handle:
    file_data = file_handle.read()

data = ""

i = 0
for m in re.finditer(r"\\DIFdelbegin(FL)?.*?\\DIFdelend(FL)?\s*", file_data, flags=re.DOTALL):
    start, end = m.span()

    before_match = file_data[i:start]

    data += before_match
    i = end

data += file_data[i:]

# also fix environments

environment_pattern = re.compile(r"\\DIFaddbegin(FL)?\s+(?P<code>\\(?:begin|end)(?:\{.*?\})+\s+)\\DIFaddend(FL)?")
data = environment_pattern.sub(r"\g<code>", data)

# also fix tables

environment_pattern = re.compile(r"(\\fboxsep)\\DIFaddFL\{(.*?)\}")
data = environment_pattern.sub(r"\g<1>\g<2>", data)


with open(file_path, "w") as file_handle:
    file_handle.write(data)
