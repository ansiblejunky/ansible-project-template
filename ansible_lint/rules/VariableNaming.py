import ansiblelint.utils
from ansiblelint import AnsibleLintRule
import re # used for regex string validation
import json

# PEP 469 -- Migration of dict iteration code to Python 3
# https://www.python.org/dev/peps/pep-0469/
try:
    dict.iteritems
except AttributeError:
    # Python 3
    def iterkeys(d):
        return iter(d.keys())
else:
    # Python 2
    def iterkeys(d):
        return d.iterkeys()


# TODO: check task for registered variables; recommend format `_private_var`
# TODO: how to check vars files?
# TODO: ensure variable names do not match one of the magic variable names
# https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#special-variables
# Provide comment on following open issue:
# [Ansible-lint does not catch invalid variable names](https://github.com/ansible/ansible-lint/issues/447)

# TIP: Use the following print statement to format the method params
#      and to understand the structure of tasks, etc
#      print(json.dumps(play, sort_keys=True, indent=4))

# properties/parameters are prefixed and postfixed with `__`
def is_property(k):
  return (k.startswith('__') and k.endswith('__'))

def has_invalid_variables(vars):
  # iterate through all keys
  for k in iterkeys(vars):
    # variables are unicoded keys in the dictionary
    if not is_property(k):
      if (is_invalid_string(k)):
        return True
  return False

def is_invalid_string(text):
  patterns = '^[a-z0-9_]*$'
  if re.search(patterns, text):
    return False # string uses acceptable characters
  else:
    return True # string uses unacceptable characters

class VariableNaming(AnsibleLintRule):
    id = 'CUSTOM0001'
    shortdesc = 'Variables must be named using only lowercase and underscores'
    description = 'Variables must be named using only lowercase and underscores'
    tags = ['formatting', 'readability']
    # severity displayed when ansible-lint configured with parseable_severity=true
    severity = 'MEDIUM'

    def matchplay(self, file, play):
      errors = []

      # If the play uses the `vars` section to set variables
      if 'vars' in iterkeys(play):
       if has_invalid_variables(play['vars']):
          errors.append(("variable naming", 'Play defines variables within `vars` section that do not comply with variable naming standards'))
      return errors

    def matchtask(self, file, task):
      ansible_module = task['action']['__ansible_module__']

      # If the task uses the `vars` section to set variables
      if 'vars' in iterkeys(task):
        if has_invalid_variables(task['vars']):
          return "Task defines variables within `vars` section that do not comply with variable naming standards"

      # If the task uses the `set_fact` module to set variables
      if ansible_module == 'set_fact':
        if has_invalid_variables(task['action']):
          return "Task `set_fact` defines variables that do not comply with variable naming standards"

      return False
