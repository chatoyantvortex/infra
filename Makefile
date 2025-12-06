.PHONY: cleanup apply deploy destroy status

# Clean up existing resources
cleanup:
	@echo "Cleaning up existing Docker containers..."
	@docker rm -f nginx-web postgres-db pythonapi 2>/dev/null || true
	@echo "Cleaning up Kubernetes namespace..."
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
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "nginx-web|postgres-db|pythonapi" || true
	@echo ""
	@echo "Kubernetes namespace:"
	@kubectl get namespace apps 2>/dev/null || true

# Destroy all resources
destroy:
	@echo "Destroying Terraform resources..."
	@terraform destroy -auto-approve
	@docker rm -f nginx-web postgres-db pythonapi 2>/dev/null || true
	@kubectl delete namespace apps 2>/dev/null || true

# Check status
status:
	@echo "Docker Containers:"
	@docker ps -a | grep -E "nginx-web|postgres-db|pythonapi" || echo "No containers found"
	@echo ""
	@echo "Kubernetes Namespace:"
	@kubectl get namespace apps 2>/dev/null || echo "Namespace not found"
	@echo ""
	@echo "Terraform State:"
	@terraform state list 2>/dev/null || echo "No state found"