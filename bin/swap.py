#!/usr/bin/env python

# Copyright 2016 Datawire. All rights reserved.

"""swap.py

Performs the green/blue infrastructure swap.

Usage:
    swap.py
    swap.py (-h | --help)
    swap.py --version

Options:
    --version                       Show the version.
"""

import colorama
import boto3
import json
import logging
import shlex
import shutil
import subprocess

from docopt import docopt

ch = logging.StreamHandler()
ch.setLevel(logging.INFO)
ch.setFormatter(logging.Formatter('-->  %(levelname)s: %(name)s - %(asctime)s - %(message)s'))

logger = logging.getLogger('swap.py')
logger.addHandler(ch)


def run_command(command, show_output=False):
    process = subprocess.Popen(shlex.split(command), stdout=subprocess.PIPE)
    result = ""
    while process.poll() is None:
        line = str(process.stdout.readline(), 'utf-8').strip()
        result += line + "\n"
        if show_output:
            print(" | " + line)

    return process.poll(), result.strip()


def terraform_output(output_name):
    exit_code, out = run_command("terraform output {}".format(output_name))
    return out.strip()


def set_color(tfvars, new_color):
    print("setting future color (color: {})".format(new_color))
    tfvars['color'] = new_color


def set_image(tfvars, color, image_id):
    print("setting future color image (color: {}, image: {})".format(color, image_id))
    tfvars['{}_instance_image'.format(color)] = image_id


def set_group_min_and_max(tfvars, color, minimum, maximum):
    print("setting future color group capacity (color: {}, capacity: {}..{})".format(color, minimum, maximum))
    tfvars['{}_group_min_size'.format(color)] = minimum
    tfvars['{}_group_max_size'.format(color)] = maximum


def swap(args):

    tfvars = {}
    with open('terraform.tfvars') as file:
        tfvars = json.load(file)

    current_color = terraform_output('color')
    if current_color is None:
        print("Deployment is not live")
        return 1

    future_color = 'blue' if current_color == 'green' else 'green'

    current_image = tfvars['{}_instance_image'.format(current_color)]
    future_image = args['<image-id>']

    # NOTE: commented out for the presentation because we're not swapping AMI's due to time constraints.
    #
    # if current_image == future_image:
    #    print("swap not needed because images are same (current: {}, future: {})".format(current_image, future_image))
    #    return 1

    set_color(tfvars, future_color)
    set_image(tfvars, future_color, future_image)

    current_min = terraform_output("{}_group_min_size".format(current_color))
    current_min = int(current_min)

    current_max = terraform_output("{}_group_max_size".format(current_color))
    current_max = int(current_max)

    set_group_min_and_max(tfvars, future_color, current_min, current_max)

    print("writing backup configuration")
    shutil.copyfile('terraform.tfvars', 'terraform.tfvars.bak')
    with open('terraform.tfvars', 'w') as file:
        json.dump(tfvars, file, indent=2, sort_keys=True)

    code, result = run_command("terraform apply", show_output=True)

    # ------------------------------------------------------------------------------------------------------------------
    # todo: SANITY TEST STAGE
    #
    # Ordinarily before downscaling the current group you would run a sanity test at this point and ensure that a sample
    # of requests to various features were being serviced as expected. Failure causes the swap to end and future is
    # downscaled before it can cause any serious harm.
    #

    set_group_min_and_max(tfvars, current_color, 0, 0)

    print("writing backup configuration")
    shutil.copyfile('terraform.tfvars', 'terraform.tfvars.bak')
    with open('terraform.tfvars', 'w') as file:
        json.dump(tfvars, file, indent=2, sort_keys=True)

    code, result = run_command("terraform apply", show_output=True)


def main():
    exit(swap(docopt(__doc__, version="swap {0}".format("1.0"))))


if __name__ == "__main__":
    try:
        colorama.init()
        main()
    finally:
        colorama.deinit()
