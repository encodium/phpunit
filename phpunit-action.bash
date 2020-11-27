#!/bin/bash
set -e
#printenv
#echo "current script: $0"
#exit
github_action_path=$(dirname "$0")
phar_filename="phpunit.phar"
command_string="php:$ACTION_PHP_VERSION "

if [ -n "$ACTION_PHPUNIT_VERSION" ]
then
	echo "Using PHPUnit version: $ACTION_PHPUNIT_VERSION"

	if [ "$ACTION_PHPUNIT_VERSION" != "latest" ]
	then
		phar_filename="phpunit-$ACTION_PHPUNIT_VERSION.phar"
	fi
fi

curl -H "User-agent: cURL (https://github.com/php-actions/phpunit)" -L https://phar.phpunit.de/"$phar_filename" > phpunit.phar

if [ -n "$action_configuration" ]
then
	command_string="$command_string --configuration '$action_configuration'"
fi

if [ -n "$action_log_junit" ]
then
	command_string="$command_string --log-junit '$action_log_junit'"
fi

if [ -n "$action_testdox_html" ]
then
	command_string="$command_string --testdox-html '$action_testdox_html'"
fi

if [ -n "$action_testdox_text" ]
then
	command_string="$command_string --testdox-text '$action_testdox_text'"
fi

if [ -n "$action_testdox_xml" ]
then
	command_string="$command_string --testdox-xml '$action_testdox_xml'"
fi

if [ -n "$action_bootstrap" ]
then
	command_string="$command_string --bootstrap '$action_bootstrap'"
fi

if [ -n "$action_filter" ]
then
	command_string="$command_string --filter '$action_filter'"
fi

if [ -n "$action_testsuite" ]
then
	command_string="$command_string --testsuite '$action_testsuite'"
fi

if [ -n "$action_group" ]
then
	command_string="$command_string --group '$action_group'"
fi

if [ -n "$action_exclude_group" ]
then
	command_string="$command_string --exclude-group '$action_exclude_group'"
fi

if [ -n "$action_test_suffix" ]
then
	command_string="$command_string --test-suffix '$action_test_suffix'"
fi

if [ -n "$action_whitelist" ]
then
	command_string="$command_string --whitelist '$action_whitelist'"
fi

if [ -n "$action_memory_limit" ]
then
	command_string="$command_string -d memory_limit=$action_memory_limit"
fi

if [ -n "$action_args" ]
then
	command_string="$command_string $action_args"
fi

echo "Command: $command_string"
eval "$command_string"

docker run --rm \
	--volume "${github_action_path}/phpunit.phar":/usr/local/bin/phpunit.phar \
	--volume "${GITHUB_WORKSPACE}":/app \
	--workdir /app \
	${command_string}