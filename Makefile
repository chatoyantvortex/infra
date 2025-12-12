.PHONY: cleanup apply deploy destroy status

# Define all apps ONCE here
APPS = nginx-web postgres-db pythonapi pythonapi_inventory

# Clean up existing resources
cleanup:
	@echo "Cleaning up existing Docker containers..."
	@for app in $(APPS); do \
		echo "Removing $$app..." ; \
		docker rm -f $$app 2>/dev/null || true ; \
	done

	@echo "Cleaning Kubernetes namespace..."
	@kubectl delete namespace apps --timeout=60s 2>/dev/null || true

	@echo "Cleaning up unused volumes..."
	@docker volume prune -f

	@echo "Cleanup completed!"

# Apply Terraform
apply:
	@echo "Applying Terraform configuration..."
	@terraform apply -auto-approve

# Full deployment (cleanup + apply)
deploy: cleanup apply
	@echo ""
	@echo "Deployment completed!"
	@echo "Docker containers:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

	@echo ""
	@echo "Checking each expected app:"
	@for app in $(APPS); do \
		docker ps --format '{{.Names}}' | grep -w $$app >/dev/null \
			&& echo "$$app is running" \
			|| echo "$$app is NOT running"; \
	done

	@echo ""
	@echo "Kubernetes namespace:"
	@kubectl get namespace apps 2>/dev/null || true

# Destroy all resources
destroy:
	@echo "Destroying Terraform resources..."
	@terraform destroy -auto-approve

	@for app in $(APPS); do \
		docker rm -f $$app 2>/dev/null || true ; \
	done

	@kubectl delete namespace apps 2>/dev/null || true

# Check runtime status
status:
	@echo "Docker Containers:"
	@docker ps -a | grep -E "$(subst $(space),|,$(APPS))" || echo "No containers found"

	@echo ""
	@echo "Kubernetes Namespace:"
	@kubectl get namespace apps 2>/dev/null || echo "Namespace not found"

	@echo ""
	@echo "Terraform State:"
	@terraform state list 2>/dev/null || echo "No state found"
