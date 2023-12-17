import os
import sys

from deepnox.builders.dockerfile.maker import load_yaml, render_template, save_rendered_template

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'src')))

import unittest
from unittest.mock import mock_open, patch

class TestYourScript(unittest.TestCase):
    def test_load_yaml(self):
        yaml_content = """
        person:
          name: Alice
          age: 25
          hobbies:
            - Hiking
            - Painting
        """
        expected_yaml_data = {
            'person': {
                'name': 'Alice',
                'age': 25,
                'hobbies': ['Hiking', 'Painting']
            }
        }

        with patch('builtins.open', mock_open(read_data=yaml_content)):
            yaml_data = load_yaml('test_data.yaml')

        self.assertEqual(yaml_data, expected_yaml_data)

    def test_render_template(self):
        template_content = "Hello, my name is {{ person.name }}."
        expected_rendered_template = "Hello, my name is Alice."

        # Mock the file read operation
        m = mock_open(read_data=template_content)
        with patch('builtins.open', m):
            context = {'person': {'name': 'Alice'}}
            rendered_template = render_template(template_content, context)

        self.assertEqual(rendered_template.strip(), expected_rendered_template)

def test_store_rendered_template(self):
    rendered_template = "This is a test rendered template."
    output_file = 'output_test.txt'

    with patch('builtins.open', mock_open()) as mock_file:
        save_rendered_template(rendered_template, output_file)

        mock_file.assert_called_once_with(output_file, 'w')
        mock_file().write.assert_called_once_with(rendered_template)

        os.remove(output_file)  # Clean up the test file


if __name__ == "__main__":
    unittest.main()
