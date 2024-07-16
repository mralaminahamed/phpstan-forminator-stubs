# Fluent Forms Stubs

[![Packagist stats](https://img.shields.io/packagist/dt/mralaminahamed/fluent-forms-stubs.svg)](https://packagist.org/packages/mralaminahamed/fluent-forms-stubs/stats)
[![Packagist](https://img.shields.io/packagist/v/mralaminahamed/fluent-forms-stubs.svg?color=4CC61E&style=popout)](https://packagist.org/packages/mralaminahamed/fluent-forms-stubs)
[![Tweet](https://img.shields.io/badge/Tweet-share-d5d5d5?style=social&logo=twitter)](https://twitter.com/intent/tweet?text=https%3A%2F%2Fgithub.com%2Fmralaminahamed%2Fphpstan-fluent-forms-stubs&url=I%20use%20mralaminahamed%2Fphpstan-fluent-forms-stubs%20for%20IDE%20completion%20and%20static%20analysis)
[![Build Status](https://app.travis-ci.com/mralaminahamed/phpstan-fluent-forms-stubs.svg?branch=master)](https://app.travis-ci.com/mralaminahamed/phpstan-fluent-forms-stubs)

This package provides stub declarations for the [Fluent Forms plugin](https://wordpress.org/plugins/fluentform/)
functions, classes and interfaces.
These stubs can help plugin and theme developers leverage IDE completion
and static analysis tools like [PHPStan](https://github.com/phpstan/phpstan).

The stubs are generated directly from the [source](https://wordpress.org/plugins/fluentform/)
using [php-stubs/generator](https://github.com/php-stubs/generator).

## Requirements

- PHP >=7.1

## Installation

Require this package as a development dependency with [Composer](https://getcomposer.org).

```bash
composer require --dev mralaminahamed/fluent-forms-stubs
```

Alternatively you may download `fluent-forms-stubs.php` directly.

## Usage in PHPStan

Include stubs in PHPStan configuration file.

```yaml
parameters:
    bootstrapFiles:
        - vendor/mralaminahamed/fluent-forms-stubs/fluent-forms-constants-stubs.php
        - vendor/mralaminahamed/fluent-forms-stubs/fluent-forms-stubs.php
```
