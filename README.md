# Ansible Playbook Repository

## Playbooks


## Ansible Lint

This repo uses [Ansible Lint](https://docs.ansible.com/ansible-lint/) to perform various lint tests on YAML files.

The repo contains an Ansible Lint configuration file (.ansible-lint) to configure the default options and determine rules to skip as well as rules to enforce. A list of all default rules and their descriptions can be found [here](https://docs.ansible.com/ansible-lint/rules/default_rules.html#default-rules).

Additionally, Ansible Lint allows for custom rules written in Python script. These can be placed inside the `ansible_lint/rules/` folder. See the following link for more information on writting custom Python scripts for new Ansible Lint rules:

https://docs.ansible.com/ansible-lint/rules/rules.html#creating-custom-rules

## Pre-Commit Hooks

This repo uses the multi-language package manager for pre-commit hooks called [pre-commit](https://pre-commit.com/). Before you can run hooks, you need to have the pre-commit package manager installed.
```
pip install pre-commit
```

## Author

John Wadleigh

## License


