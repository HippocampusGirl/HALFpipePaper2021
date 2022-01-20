#!/usr/bin/env python
# -*- coding: utf-8 -*-

from collections import OrderedDict
from unicodedata import normalize, category
from glob import glob
from string import ascii_lowercase

from frozendict import frozendict

from bibtexparser.bparser import BibTexParser
from bibtexparser.bwriter import BibTexWriter
from bibtexparser.bibdatabase import BibDatabase


bibtex_files = ["bib/two.bib", "bib/ilya.bib", "bib/lea.bib"]
tex_files = list(glob("**/*.tex", recursive=True))

parser = BibTexParser(common_strings=True, ignore_nonstandard_types=False)
bibliography = dict()
rename: dict = dict()

for bibtex_file in bibtex_files:
    with open(bibtex_file) as file_handle:
        database: BibDatabase = parser.parse_file(file_handle)
    for entry in database.entries:
        key = entry.get("doi", frozendict(entry))

        if isinstance(key, str):
            key = key.lower()
            key = key.replace("https://doi.org/", "")
            key = key.replace("https://dx.doi.org/", "")

        if key in bibliography:
            rename[bibliography[key]["ID"]] = entry["ID"]
        bibliography[key] = entry


def format_author(s: str) -> str:
    return "".join(
        c for c in normalize("NFKD", s.lower()) if category(c) == "Ll"
    )


clean: OrderedDict[str, frozendict] = OrderedDict()

for entry in bibliography.values():
    author = entry["author"]
    first_author = format_author(author.split(",")[0])

    year = entry.get("year", entry.get("date"))
    if not isinstance(year, str):
        print(f"Skipping {entry}")
        continue
    year = year[:4]

    identifier = f"{first_author}{year}"

    i = 0
    if identifier in clean:
        clean[f"{identifier}{ascii_lowercase[0]}"] = clean[identifier]
        del clean[identifier]
        i = 1
    else:
        while f"{identifier}{ascii_lowercase[i]}" in clean:
            i += 1

    if i > 0:
        identifier = f"{identifier}{ascii_lowercase[i]}"

    clean[identifier] = entry


def find_matching_ids(a: str) -> set[str]:
    global rename
    matching_ids = set([a])
    while True:
        previous = matching_ids
        for b, c in rename.items():
            if c in matching_ids:
                matching_ids.add(b)
        if previous == matching_ids:
            return matching_ids


database = BibDatabase()

for key, entry in clean.items():
    rename[entry["ID"]] = key

    entry = dict(entry)

    entry["ID"] = key
    database.entries.append(entry)

writer = BibTexWriter()

with open("bib/clean.bib", "w") as file_handle:
    file_handle.write(writer.write(database))

for tex_file in tex_files:
    with open(tex_file) as file_handle:
        tex = file_handle.read()
    for key in clean.keys():
        matching_ids = find_matching_ids(key)

        for m in matching_ids:
            tex = tex.replace(m, key)
    with open(tex_file, "w") as file_handle:
        file_handle.write(tex)
