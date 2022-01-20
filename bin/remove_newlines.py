#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys

file_path = sys.argv[1]

print(file_path)

with open(file_path) as file_handle:
    file_data = file_handle.read()

data = ""

i = 0
for m in re.finditer(r"\n+", file_data):
    start, end = m.span()

    line = file_data[i:start]

    if len(data) > 0:
        if not data[-1].isspace() and not line[0].isspace():
            data += " "

    data += line
    i = end

    match_string = m.group()
    if len(match_string) > 1:  # keep repeated newlines
        data += match_string

with open(file_path, "w") as file_handle:
    file_handle.write(data)
