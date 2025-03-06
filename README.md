# Ansible Project Template

This repository is a template for an `Ansible Project` that includes the typical Ansible structure.

- [.config](.config) folder contains lint rules and other configuration
- [.github](.github) folder contains GitHub workflow action configuration
- [collections](./collections/) folder contains definitions of Ansible Collections
- [roles](./roles/) folder contains definitions of Ansible Roles
- [hosts](./hosts/) folder contains Ansible inventory and configuration management with group variables
- [plugins](./plugins/) folder contains custom Ansible plugins for inventory, filter, action, callback, and so on
- [playbooks](./playbooks/) folder contains Ansible Playbooks to perform actions
- Continuous Testing is performed using various linting tools
  - Ansible Lint
  - Flake8 for Python linting
  - PyLint for Python linting

## Running Playbooks

Using `Ansible Playbook`:

```shell
ansible-playbook -i hosts/dev/inventory playbooks/example.yml
```

Using `Ansible Navigator`:

- [ansible-navigator demo](https://www.youtube.com/watch?v=J9PBKi8ydi4)

TODO: Add command using latest EE image

Using `Ansible Automation Platform (AAP)`:

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

## References

- [The Inside Playbook - USING ANSIBLE AND ANSIBLE TOWER WITH SHARED ROLES](https://www.ansible.com/blog/using-ansible-and-ansible-tower-with-shared-roles)
- [Rolling Updates, Performance, Strategies](https://docs.ansible.com/ansible/latest/user_guide/playbooks_strategies.html)

## License

GNUv3

## Author

John Wadleigh


## TODO:

Ansible Framework:

Playbook:

---
- hosts: localhost
  #connection: local

TODO: get the framework from HCSC that checks for Windows or Linux machine using port check!

  (payload provided from external system)

  tasks:
  - include_role:
      name: provision
    vars:
      os_string: "{{ item.os_string }}"
      ...
    with_items: "{{ buildlist }}"
    when: ansible_os_family == windows

  - include_role:
      name: provision
    vars:
      os_string: "{{ item.os_string }}"
      ...
    with_items: "{{ buildlist }}"
    when: ansible_os_family == linux

- hosts: windows
  gather_facts: true

  tasks:
  - do things

- hosts: linux
  gather_facts: true

  tasks:
  - do things

Ansible Role:

defaults/
   main.yml
tasks/
   main.yml
   linux_do_something.yml
   windows_do_something.yml
vars/
   main.yml (platform agnostic vars)
     port: 80
   linux.yml
     install_path: /opt/app
   windows.yml 
      install_path: c:\sdjfk

main.yml:

- include_tasks: "{{ ansible_os_family }}_do_something.yml"

