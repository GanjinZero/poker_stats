.PHONY: test ut_test ac_test lint env upload clean

MAKEFLAGS += --silent

test: ut_test ac_test lint

ut_test:
	coverage run --branch --source=poker_stats -m unittest discover -v test/ut '*_test.py'
	coverage report --show-missing --omit='*/__init__.py,*/__main__.py,*/api.py,*/config.py,*/report_printer.py,*/ver.py'

ac_test:
	test/ac/ac_test.sh

lint:
	pylint --rcfile=.pylintrc poker_stats

env: python_env
	echo
	echo "Don't forget to 'source python_env/bin/activate' before starting the work"
	echo

python_env:
	virtualenv python_env
	echo '. ./python_env/bin/activate && pip install -r requirements.txt' | $(SHELL)

upload: clean test
	./setup.py sdist bdist_wheel upload $(V)
	git push --force heroku develop:master

clean:
	find -name '*.pyc' -delete
	-rm -rf dist build poker_stats.egg-info poker_stats/ver.py
