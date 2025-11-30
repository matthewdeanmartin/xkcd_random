.EXPORT_ALL_VARIABLES:
# Get changed files

# if you wrap everything in uv run, it runs slower.
ifeq ($(origin VIRTUAL_ENV),undefined)
    VENV := uv run
else
    VENV :=
endif

uv.lock: pyproject.toml
	@echo "Installing dependencies"
	@uv sync

# tests can't be expected to pass if dependencies aren't installed.
# tests are often slow and linting is fast, so run tests on linted code.
test: uv.lock install_plugins
	@echo "Running unit tests"
	# $(VENV) pytest --doctest-modules xkcd_random
	# $(VENV) python -m unittest discover
	$(VENV) pytest test -vv -n 2 --cov=xkcd_random --cov-report=html --cov-fail-under 5 --cov-branch --cov-report=xml --junitxml=junit.xml -o junit_family=legacy --timeout=5 --session-timeout=600
	$(VENV) bash ./scripts/basic_checks.sh
#	$(VENV) bash basic_test_with_logging.sh


isort:  
	@echo "Formatting imports"
	$(VENV) isort .

black:  isort 
	@echo "Formatting code"
	$(VENV) metametameta pep621
	$(VENV) black xkcd_random # --exclude .venv
	$(VENV) black test # --exclude .venv
	$(VENV) git2md xkcd_random --ignore __init__.py __pycache__ --output SOURCE.md

pre-commit:  isort black
	@echo "Pre-commit checks"
	$(VENV) pre-commit run --all-files

bandit:  
	@echo "Security checks"
	$(VENV)  bandit xkcd_random -r --quiet

.PHONY: pylint
pylint:  isort black 
	@echo "Linting with pylint"
	$(VENV) ruff --fix
	$(VENV) pylint xkcd_random --fail-under 9.8

check: mypy test pylint bandit pre-commit update_dev_status dog_food


.PHONY: publish
publish: test
	rm -rf dist && hatch build

.PHONY: mypy
mypy:
	$(VENV) echo $$PYTHONPATH
	$(VENV) mypy xkcd_random --ignore-missing-imports --check-untyped-defs


check_docs:
	$(VENV) interrogate xkcd_random --verbose  --fail-under 70
	$(VENV) pydoctest --config .pydoctest.json | grep -v "__init__" | grep -v "__main__" | grep -v "Unable to parse"

make_docs:
	pdoc xkcd_random --html -o docs --force

check_md:
	$(VENV) linkcheckMarkdown README.md
	$(VENV) markdownlint README.md --config .markdownlintrc
	$(VENV) mdformat README.md docs/*.md


check_spelling:
	$(VENV) pylint xkcd_random --enable C0402 --rcfile=.pylintrc_spell
	$(VENV) pylint docs --enable C0402 --rcfile=.pylintrc_spell
	$(VENV) codespell README.md --ignore-words=private_dictionary.txt
	$(VENV) codespell xkcd_random --ignore-words=private_dictionary.txt
	$(VENV) codespell docs --ignore-words=private_dictionary.txt

check_changelog:
	# pipx install keepachangelog-manager
	$(VENV) changelogmanager validate

check_all_docs: check_docs check_md check_spelling check_changelog

check_self:
	# Can it verify itself?
	$(VENV) ./scripts/dog_food.sh


dog_food:
	troml-dev-status validate .
	metametameta sync-check
	# troml-dev-status --totalhelp
	# bitrab
	# pycodetags <command?>
	# cli-tool-audit