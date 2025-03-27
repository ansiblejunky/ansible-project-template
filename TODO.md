
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

