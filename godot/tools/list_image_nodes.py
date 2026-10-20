#!/usr/bin/env python3
"""Dump a story as readable text with a stable id for every node.

Node ids match the runtime resolver in core/background_images.gd:
    <story_id>/<page_path>/<node_index>
where page_path is "r" for the root page and "r.<i>.<j>..." for the page
reached by taking choice i, then choice j, and so on.

Usage: list_image_nodes.py <story.json> [--only-images]
"""
import json
import os
import sys


def walk(page, path):
    yield path, page
    for i, nxt in enumerate(page.get("next") or []):
        yield from walk(nxt.get("nextPage") or {}, f"{path}.{i}")


def main():
    story_file = sys.argv[1]
    only_images = "--only-images" in sys.argv
    story_id = os.path.splitext(os.path.basename(story_file))[0]
    with open(story_file, encoding="utf-8") as f:
        story = json.load(f)

    print(f"# {story['title']} ({story['year']})  id={story_id}")
    print(f"# {story['description']}\n")
    for path, page in walk(story["root"], "r"):
        end = page.get("endType")
        print(f"=== PAGE {path}" + (f"  [END: {end}]" if end else ""))
        for idx, node in enumerate(page.get("nodes") or []):
            image = node.get("imageType")
            if only_images and not image:
                continue
            marker = f"  <<IMAGE {story_id}/{path}/{idx} theme={image}>>" if image else ""
            print(f"[{idx}] {node.get('text')}{marker}")
        for i, nxt in enumerate(page.get("next") or []):
            print(f"  -> choice {i}: {nxt.get('text')}  (goes to {path}.{i})")
        print()


if __name__ == "__main__":
    main()
