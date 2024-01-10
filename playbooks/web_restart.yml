- name: Restart web layer
  hosts: web
  gather_facts: true

  tasks:
    - name: Perform shutdown for apache servers
      ansible.builtin.include_role:
        name: apache
        tasks_from: shutdown.yml

    - name: Perform startup for apache servers
      ansible.builtin.include_role:
        name: apache
        tasks_from: startup.yml
