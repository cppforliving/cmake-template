#!/usr/bin/env python2

from jinja2 import Environment, FileSystemLoader
import os
import argparse
from yaml import safe_load

parser = argparse.ArgumentParser()
parser.add_argument("templates", help="path to the templates directory")
parser.add_argument("input", help="path to the data types yaml")
args = parser.parse_args()

input = safe_load(file(args.input, 'r'))

env = Environment(
    loader=FileSystemLoader(args.templates),
    trim_blocks=True,
    keep_trailing_newline=True,
)
template = env.get_template("enum.hpp.jinja2")
output_from_parsed_template = template.render(
    header_guard="{}_{}_HPP".format(
        '_'.join(map(str.upper, input['name'])),
        input['children'][0]['name'].upper()
    ),
    enum_name=input['children'][0]['name'],
    enum_values=input['children'][0]['values'],
    enum_ns=input['name'],
    underlying=input['children'][0]['underlying'],
)
with open("enum.hpp", "w") as f:
    f.write(output_from_parsed_template)
