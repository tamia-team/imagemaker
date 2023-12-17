import yaml
from jinja2 import Environment, FileSystemLoader

def load_yaml(file_path):
    with open(file_path, 'r') as file:
        return yaml.safe_load(file)
def render_template(template_string, context):
    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template(template_path)
    return template.render(context)

def save_rendered_template(rendered_template, output_file):
    with open(output_file, 'w') as file:
        file.write(rendered_template)
