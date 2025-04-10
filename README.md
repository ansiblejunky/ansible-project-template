# Ansible Project Template

This repository is a template for an `Ansible Project` that includes the typical Ansible structure.

- [.config](.config) folder contains lint rules and other configuration
- [.github](.github) folder contains GitHub workflow action configuration
- [collections](./collections/) folder contains definitions of Ansible Collections
- [roles](./roles/) folder contains definitions of Ansible Roles
- [hosts](./hosts/) folder contains Ansible inventory and configuration management with group variables
- [plugins](./plugins/) folder contains custom Ansible plugins for inventory, filter, action, callback, and so on
- [playbooks](./playbooks/) folder contains Ansible Playbooks to perform actions
- Code Quality Tests are performed using various linting tools
  - Ansible Lint
  - Ruff for Python linting

Recommended `Visual Studio Code` extensions that help to manage this repository:

- Ansible
- Ruff
- Even Better TOML

## Examples

Use this repository to run some of the following useful commands:

```shell
# Ansible Dev Tools https://ansible.readthedocs.io/projects/dev-tools/
pip install ansible-dev-tools
adt --version

# Using ansible-playbook command
ansible-playbook -i hosts/dev/inventory playbooks/aap_content.yml
# Using ansible-navigator command - [ansible-navigator demo](https://www.youtube.com/watch?v=J9PBKi8ydi4)
ansible-navigator run -i hosts/dev/inventory playbooks/aap_content.yml

# Linting current project using ansible-lint
ansible-lint
# Linting current project using ansible-navigator
ansible-navigator lint $CWD
# Fix linting errors
ansible-lint --fix
# Generate ignore file
ansible-lint --generate-ignore

# Linting Python files (modules, plugins, etc)
ruff check
# Fixing Python linting errors
ruff check --fix
# Show statistics to show counts for every rule
ruff check --statistics
# List python files detected
ruff check --show-files
# Format Python files correctly
ruff format <python file>

# Check configuration inside image using ansible-navigator
ansible-navigator config dump
# Check collections using interactive mode
ansible-navigator collections --mode=interactive
```

## Using Ansible Automation Platform (AAP)

TODO: Create a playbook to create objects in AAP!

- Create a new **Project** pointing to the Ansible Project version control repo
- Create a new **Inventory**
- Create a new **Inventory Source** in the new Inventory object you created
  - Select "Source from a Project"
  - Select the Project you created
  - Select the **inventory** file as the source
- Synchronize the Inventory Source to make sure it succeeds
- Notice now that your Inventory object contains the vars and hosts and groups from the inventory structure
- Notice it loaded the variables from within the `group_vars` folder as well!
- Create a new **Job Template**
  - Set the name
  - Set the Project
  - Set the Playbook
  - Set the Credentials

## License

GNUv3

## Author

John Wadleigh
