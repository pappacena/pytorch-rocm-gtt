.ONESHELL:

.PHONY: help
help:             ## Show the help.
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@fgrep "##" Makefile | fgrep -v fgrep


.PHONY: show
show:             ## Show the current environment.
	@echo "Current environment:"
	poetry env info
	
.PHONY: install
install:          ## Install the project in dev mode.
	pip install poetry
	poetry install --with dev

.PHONY: fmt
fmt:              ## Format code using black & isort.
	poetry run isort pytorch_rocm_gtt/
	poetry run black -l 79 pytorch_rocm_gtt/
	poetry run black -l 79 tests/

.PHONY: lint
lint:             ## Run pep8, black, mypy linters.
	poetry run flake8 pytorch_rocm_gtt/
	poetry run black -l 79 --check pytorch_rocm_gtt/
	poetry run black -l 79 --check tests/
	poetry run mypy --ignore-missing-imports pytorch_rocm_gtt/

.PHONY: test
test: lint        ## Run tests and generate coverage report.
	poetry run pytest -v --cov-config .coveragerc --cov=pytorch_rocm_gtt -l --tb=short --maxfail=1 tests/
	poetry run coverage xml
	poetry run coverage html

.PHONY: watch
watch:            ## Run tests on every change.
	ls **/**.py | entr poetry run pytest -s -vvv -l --tb=long --maxfail=1 tests/

.PHONY: clean
clean:            ## Clean unused files.
	@find ./ -name '*.pyc' -exec rm -f {} \;
	@find ./ -name '__pycache__' -exec rm -rf {} \;
	@find ./ -name 'Thumbs.db' -exec rm -f {} \;
	@find ./ -name '*~' -exec rm -f {} \;
	@rm -rf .cache
	@rm -rf .pytest_cache
	@rm -rf .mypy_cache
	@rm -rf build
	@rm -rf dist
	@rm -rf *.egg-info
	@rm -rf htmlcov
	@rm -rf .tox/
	@rm -rf docs/_build
	@rm pytorch_rocm_gtt/*.so

.PHONY: release
release:          ## Create a new tag for release.
	@echo "WARNING: This operation will create s version tag and push to github"
	@read -p "Version? (provide the next x.y.z semver) : " TAG
	@echo "creating git tag : $${TAG}"
	@git tag $${TAG}
	@echo "$${TAG}" > pytorch_rocm_gtt/VERSION
	@poetry run gitchangelog > HISTORY.md
	@git add pytorch_rocm_gtt/VERSION HISTORY.md
	@git commit -m "release: version $${TAG} 🚀"
	@git push -u origin HEAD --tags
	@echo "Github Actions will detect the new tag and release the new version."

.PHONY: docs
docs:             ## Build the documentation.
	@echo "building documentation ..."
	@poetry run mkdocs build
	URL="site/index.html"; xdg-open $$URL || sensible-browser $$URL || x-www-browser $$URL || gnome-open $$URL
