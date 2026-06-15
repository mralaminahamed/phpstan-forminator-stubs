# Forminator Stubs

[![Latest Version](https://img.shields.io/packagist/v/mralaminahamed/forminator-stubs.svg?color=4CC61E&style=flat-square)](https://packagist.org/packages/mralaminahamed/forminator-stubs)
[![Downloads](https://img.shields.io/packagist/dt/mralaminahamed/forminator-stubs.svg?style=flat-square)](https://packagist.org/packages/mralaminahamed/forminator-stubs/stats)
[![License](https://img.shields.io/packagist/l/mralaminahamed/forminator-stubs.svg?style=flat-square)](./LICENSE)
[![PHP Version](https://img.shields.io/packagist/php-v/mralaminahamed/forminator-stubs.svg?style=flat-square)](./composer.json)
[![Tweet](https://img.shields.io/badge/Tweet-share-1da1f2?style=flat-square&logo=twitter)](https://twitter.com/intent/tweet?text=Check%20out%20Forminator%20Stubs%20for%20IDE%20completion%20and%20static%20analysis%20https%3A%2F%2Fgithub.com%2Fmralaminahamed%2Fphpstan-forminator-stubs)

PHP stub declarations for the [Forminator](https://wordpress.org/plugins/forminator/) plugin to enhance IDE completion and static analysis capabilities. Generated using [php-stubs/generator](https://github.com/php-stubs/generator) directly from the source code.

## 🚀 Features

- Complete function, class, and interface declarations
- Constant definitions for proper static analysis
- IDE autocompletion support
- PHPStan integration
- Regular updates with latest Forminator plugin versions

## 📋 Requirements

- PHP >= 7.4
- Composer for dependency management

## 📦 Installation

### Via Composer (Recommended)

```bash
# Install as a development dependency
composer require --dev mralaminahamed/forminator-stubs

# Or specify a version
composer require --dev mralaminahamed/forminator-stubs:^2.0
```

### Manual Installation

Download the stub files directly:
- [forminator-stubs.stub](https://raw.githubusercontent.com/mralaminahamed/phpstan-forminator-stubs/main/forminator-stubs.stub)
- [forminator-constants-stubs.stub](https://raw.githubusercontent.com/mralaminahamed/phpstan-forminator-stubs/main/forminator-constants-stubs.stub)

## 🔧 Basic Configuration

To use these stubs with PHPStan or your IDE, see our [Usage Guide](./docs/usage.md) for detailed instructions.

## 🔍 Quick Usage Example

```php
<?php
// Your code will now have full IDE support
$forms = Forminator_API::get_forms();

// Create a new form entry
$entry = Forminator_API::get_entry($entryId, $formId);

// Constants are properly defined
if (FORMINATOR_VERSION) {
    // Your implementation
}
```

For advanced usage examples, see the [Usage Guide](./docs/usage.md).

## 📁 Package Structure

```
phpstan-forminator-stubs/
├── configs/                               # Configuration files for stub generation
├── forminator-constants-stubs.stub        # Constants stub file
├── forminator-stubs.stub                  # Main stubs file with classes and functions
├── forminator_versions.txt                # Tracks supported Forminator versions
├── phpstan.neon                           # PHPStan configuration
├── source/                                # Source for generating stubs
├── tools/                                 # Helper tools for stub generation
└── tests/                                 # Test files
    ├── bootstrap.php                      # Test bootstrap
    ├── ConstantsTest.php                  # Constants tests
    └── ForminatorTest.php                 # Forminator tests
```

## 🛠 Development

For information on building stubs, running tests, and contributing to the project, please see our [Contributing Guide](./docs/contributing.md).

## 📚 Documentation

For more detailed information, check out our documentation:

- [Usage Guide](./docs/usage.md)
- [Contributing Guide](./docs/contributing.md)
- [Forminator Documentation](https://wpmudev.com/docs/wpmu-dev-plugins/forminator/)
- [PHPStan Documentation](https://phpstan.org/user-guide/getting-started)
- [PHP Stubs Generator Documentation](https://github.com/php-stubs/generator)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 🙏 Acknowledgments

- [WPMU DEV](https://wpmudev.com/) for the Forminator plugin
- [php-stubs/generator](https://github.com/php-stubs/generator) for the stub generation tools
- All [contributors](https://github.com/mralaminahamed/phpstan-forminator-stubs/graphs/contributors) to this project

## 💬 Support

For bug reports and feature requests, please use the [GitHub Issues](https://github.com/mralaminahamed/phpstan-forminator-stubs/issues).

For questions and discussions, please use the [GitHub Discussions](https://github.com/mralaminahamed/phpstan-forminator-stubs/discussions).

---
