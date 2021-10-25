SHELL := bash
CURRENT_DIR = $(shell pwd)
VAULT_FILE := .password_file

lint:	
	@ansible-lint --force-color

.local.vars.yml:	
	cp templates/vars.yml.example .local.vars.yml

encrypt-vars:	.local.vars.yml	
	ansible-vault encrypt --vault-password-file=$(VAULT_FILE) .local.vars.yml

edit-vars:
	ansible-vault edit --vault-password-file=$(VAULT_FILE) .local.vars.yml

view-vars:
	ansible-vault view --vault-password-file=$(VAULT_FILE) .local.vars.yml

clean-up:
	ansible-playbook --vault-password-file=$(VAULT_FILE) cleanup.yml  $(EXTRA_ARGS)

# Creates the Kubernetes Clusters GCP and CIVO
create-kube-clusters:
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,cloud" playbook.yml $(EXTRA_ARGS)

deploy-gloo:
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,gloo" playbook.yml $(EXTRA_ARGS)

deploy-keycloak:
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "keycloak" playbook.yml $(EXTRA_ARGS)

deploy-portal:  deploy-keycloak
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "portal" playbook.yml $(EXTRA_ARGS)

secure-portal:
	ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "portal" playbook.yml --extra-vars="portal_auth_enabled=yes" $(EXTRA_ARGS)

test:
	ansible-playbook --vault-password-file=$(VAULT_FILE) test.yml  $(EXTRA_ARGS)
