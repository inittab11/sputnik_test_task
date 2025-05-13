.PHONY: deploy check lint

ANSIBLE_PLAYBOOK=ansible-playbook
INVENTORY=inventory.ini
PLAYBOOK=base_setup.yml

deploy:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(PLAYBOOK) -k -K
check:
	ansible-lint $(PLAYBOOK)

lint:
	yamllint .
