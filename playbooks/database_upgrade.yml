- name: Upgrade database
  hosts: db
  gather_facts: true

  tasks:
    - name: Perform shutdown for database servers
      ansible.builtin.include_role:
        name: postgres
        tasks_from: shutdown.yml

    - name: Perform upgrade/install for database servers
      ansible.builtin.include_role:
        name: postgres
        tasks_from: install.yml

    - name: Perform startup for database servers
      ansible.builtin.include_role:
        name: postgres
        tasks_from: startup.yml
