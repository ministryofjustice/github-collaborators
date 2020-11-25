init:
	$${TERRAFORM} init

plan:
	make init
	$${TERRAFORM} plan

apply:
	$${TERRAFORM} apply

list:
	@$${TERRAFORM} state list

clean-state:
	collabs=$$(make list); \
	for c in $$collabs; do bash -c "terraform0.13.5 state rm '$$c'"; done

import-collab:
	$${TERRAFORM} import module.testing-external-collaborators.github_repository_collaborator.collaborator[\"DangerDawson\"] testing-external-collaborators:DangerDawson
	$${TERRAFORM} import module.testing-external-collaborators.github_repository_collaborator.collaborator[\"toonsend\"] testing-external-collaborators:toonsend
