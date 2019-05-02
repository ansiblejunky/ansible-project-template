import ansiblelint.utils
from ansiblelint import AnsibleLintRule

class VariableNaming(AnsibleLintRule):
    id = 'CUSTOM0001'
    shortdesc = 'Variables must be named using lowercase and underscores'
    description = 'Variables must be named using lowercase and underscores'
    tags = ['productivity']

    def match(self, file, line):
        return False

    def matchtask(self, file, task):
        return False

    return False
