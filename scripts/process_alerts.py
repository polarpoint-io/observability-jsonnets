#!/usr/bin/env python3
"""Fetch alerting and aggregation rules from provided urls into this chart."""
import textwrap
from os import makedirs, path
import sys

import glob
import yaml
from yaml.representer import SafeRepresenter
from pathlib import Path

# https://stackoverflow.com/a/20863889/961092
class LiteralStr(str):
    pass


def change_style(style, representer):
    def new_representer(dumper, data):
        scalar = representer(dumper, data)
        scalar.style = style
        return scalar

    return new_representer


chart = {
        'destination': 'chart/files',
        'min_kubernetes': '1.14.0-0',
        'namespace': 'monitoring',
        'max_kubernetes': "9.9.9-9"
    };

def init_yaml_styles():
    represent_literal_str = change_style('|', SafeRepresenter.represent_str)
    yaml.add_representer(LiteralStr, represent_literal_str)


def escape(s):
    return s.replace("{{", "{{`{{").replace("}}", "}}`}}").replace("{{`{{", "{{`{{`}}").replace("}}`}}", "{{`}}`}}")


def fix_expr(rules):
    """Remove trailing whitespaces and line breaks, which happen to creep in
     due to yaml import specifics;
     convert multiline expressions to literal style, |-"""
    for rule in rules:
        rule['expr'] = rule['expr'].rstrip()
        if '\n' in rule['expr']:
            rule['expr'] = LiteralStr(rule['expr'])


def yaml_str_repr(struct, indent=4):
    """represent yaml as a string"""
    text = yaml.dump(
        struct,
        width=1000,  # to disable line wrapping
        default_flow_style=False  # to disable multiple items on single line
    )
    text = escape(text)  # escape {{ and }} for helm
    text = textwrap.indent(text, '')[indent - 4:]  # indent everything, and remove very first line extra indentation
    return text


def write_group_to_file(template, destination_file):
    fix_expr(template['groups'][0]['rules'])

    # prepare rules string representation
    template = yaml_str_repr(template)

    # recreate the file
    with open(destination_file, 'w') as f:
        f.write(template)

    print("Generated %s" % destination_file)

def main():
    if len(sys.argv) < 2:
        exit('Required params[0] - file type not provided')
    file_type = sys.argv[1]
    init_yaml_styles()
    # make sure directories to store the file exist
    makedirs(path.join(chart['destination'], file_type), exist_ok=True)
    # read the rules, create a new template file per group
    file_path="%s/__generated/*.yaml" % file_type
    
    for source_file in glob.iglob(file_path):
        print("Generating rules from %s" % source_file)
        with open(source_file, 'r') as file:
            yaml_text = yaml.load(file, Loader=yaml.FullLoader)


        dest_file = path.join(chart['destination'], file_type, Path(source_file).stem + '.yml')
        write_group_to_file(yaml_text, dest_file)
    print("Finished")


if __name__ == '__main__':
    main()