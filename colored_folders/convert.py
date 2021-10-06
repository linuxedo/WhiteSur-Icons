#!/usr/bin/python3

from os import listdir
from os.path import isfile, join

original_dir = "original"

blue = {
    "#005ae1": "#005ae1",
    "#228be6": "#228be6"
}

green = {
    "#005ae1": "#0da760",
    "#228be6": "#97ff95"
}

purple = {
    "#005ae1": "#930077",
    "#228be6": "#7622e6"
}

red = {
    "#005ae1": "#cb3b3b",
    "#228be6": "#e62256"
}

yellow = {
    "#005ae1": "#e1cc00",
    "#228be6": "#ffff3c"
}

orange = {
    "#005ae1": "#ffc074",
    "#228be6": "#ffce36"
}

pink = {
    "#005ae1": "#ff4fbc",
    "#228be6": "#ffabf3"
}

grey = {
    "#005ae1": "#565656",
    "#228be6": "#767fad"
}

aqua = {
    "#005ae1": "#00bce1",
    "#228be6": "#a4d7e1"
}

sand = {
    "#005ae1": "#7e8272",
    "#228be6": "#cac2a2"
}

black = {
    "#005ae1": "#000000",
    "#228be6": "#636363"
}

black_post = {
    'opacity="0.30"': 'opacity="0.30"\n    fill="#ffffff"',
    'fill="currentColor"': '',
    'fill="none"': '',
    'stroke="#000000"': 'stroke="#ffffff"'
}

color_mapping = {
    "blue": blue,
    "green": green,
    "purple": purple,
    "red": red,
    "yellow": yellow,
    "orange": orange,
    "pink": pink,
    "grey": grey,
    "aqua": aqua,
    "sand": sand
    # "black": black
}

post_mapping = {
    # "blue": black_post,
    # "green": black_post,
    # "purple": black_post,
    # "red": black_post,
    # "yellow": black_post,
    # "orange": black_post,
    # "pink": black_post,
    # "grey": black_post,
    # "aqua": black_post,
    # "sand": black_post,
    # "black": black_post
}

def change_color(blue_folder: str, color: str) -> str:
    mapping = color_mapping[color]
    color_folder = blue_folder
    for key, value in mapping.items():
        color_folder = color_folder.replace(key, value)
    return color_folder

def post_map(colored_folder: str, color: str) -> str:
    if color in post_mapping:
        mapping = post_mapping[color]
        for key, value in mapping.items():
            colored_folder = colored_folder.replace(key, value)
    return colored_folder

def convert(color: str):
    with open('template.svg', 'r') as file:
        blue_folder = file.read()
    template = change_color(blue_folder, color)
    original_icons = [f for f in listdir(original_dir) if isfile(join(original_dir, f))]
    for icon in original_icons:
        with open(join(original_dir, icon), 'r') as file:
            txt = file.read()
            colored_svg = txt.replace(blue_folder, template)
            colored_svg = post_map(colored_svg, color)
            with open("icons/" + color + "-" + icon, "w") as text_file:
                text_file.write(colored_svg)

    with open('folder-open.svg', 'r') as file:
        folder_open = file.read()
        colored_folder_open = change_color(folder_open, color)
        with open("icons/" + color + "-folder-open.svg", "w") as text_file:
            text_file.write(colored_folder_open)

for color in color_mapping:
    convert(color)
