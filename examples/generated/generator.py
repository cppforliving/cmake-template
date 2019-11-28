#!/usr/bin/env python2

from jinja2 import Environment, FileSystemLoader
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("templates", help="path to the templates directory")
args = parser.parse_args()

env = Environment(
    loader=FileSystemLoader(args.templates),
    trim_blocks=True,
    keep_trailing_newline=True,
)
template = env.get_template("enum.hpp.jinja2")
output_from_parsed_template = template.render(
    header_guard="NUMBER_HPP",
    enum_name="Number",
    enum_values=["One", "Two", "Tree"],
    enum_ns=["my", "numbers"],
    underlying="unsigned char",
)
with open("enum.hpp", "w") as f:
    f.write(output_from_parsed_template)
