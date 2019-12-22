from jinja2 import Environment, FileSystemLoader
import argparse
from yaml import safe_load


def remove_prefix(s, p):
    return s[len(p) :] if s.startswith(p) else s


def generate(args):
    with open(args.input, "r") as file:
        input_file = safe_load(file)

    env = Environment(
        loader=FileSystemLoader(args.templates),
        trim_blocks=True,
        keep_trailing_newline=True,
    )
    template = env.get_template("enum.hpp.jinja2")
    output_from_parsed_template = template.render(
        header_guard="{}_{}_HPP".format(
            "_".join(map(str.upper, input_file["name"])),
            input_file["children"][0]["name"].upper(),
        ),
        enum_name=input_file["children"][0]["name"],
        enum_values=input_file["children"][0]["values"],
        enum_ns=input_file["name"],
        underlying=input_file["children"][0]["underlying"],
        input_file=args.project_name
        + remove_prefix(args.input, args.project_dir),
    )
    with open("enum.hpp", "w") as f:
        f.write(output_from_parsed_template)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("templates", help="path to the templates directory")
    parser.add_argument("input", help="path to the data types yaml")
    parser.add_argument("project_dir", help="project root directory path")
    parser.add_argument("project_name", help="project name")
    generate(parser.parse_args())
