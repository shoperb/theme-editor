# Shoperb Theme Editor

Shoperb Theme Editor is a Ruby CLI that simplifies creating and updating Shoperb storefront themes.

## Installation
### Install Ruby
See installation guides at https://www.ruby-lang.org/en/documentation/installation/.


### Requirements
- Ruby >= 3.2.0
- Bundler >= 2.x

### Project setup
#### Option A: one-liner (GitHub source)
Copy and paste this into your terminal:
```
echo -e "source \"https://rubygems.org\"\ngem \"shoperb-theme-editor\", git: \"https://github.com/shoperb/theme-editor.git\"\ngem \"shoperb_liquid\", git: \"https://github.com/shoperb/shoperb-liquid.git\"\ngem 'artisans',  git: 'https://github.com/shoperb/artisans.git'\n" > Gemfile && bundle
```

#### Option B: step by step (GitHub source)
Create a Gemfile:
```ruby
source "https://rubygems.org"

gem "shoperb-theme-editor", git: 'git@github.com:shoperb/theme-editor'
gem 'shoperb_liquid',  git: 'git@github.com:shoperb/shoperb-liquid'
gem "artisans", git: "git@github.com:shoperb/artisans"
```
Then run:
```bash
$ bundle
```

Alternatively, if you prefer a released version from RubyGems:
```ruby
source "https://rubygems.org"
gem "shoperb-theme-editor", "~> 0.8"
```

## Quickstart

```bash
# Create a new theme from the blank template
shoperb init theme-blank my-theme
cd my-theme

# Run a local preview server (default: http://localhost:4000)
shoperb serve
```

## Usage
#### Execute `bundle exec shoperb pull`
Fetches updates from the remote theme into your local copy.
#### Execute `bundle exec shoperb sync`
Clones products, categories, images, collections, and vendors for local development.
#### Execute `bundle exec shoperb serve`
Runs a local preview server for the theme (default: http://localhost:4000).

## Available commands

### clone
Downloads your shop's Shoperb theme into a local directory.
```bash
$ bundle exec shoperb clone <directory> [<handle>] [options]
```

### init
Creates a new theme from a template (e.g., `theme-blank`).
```bash
$ bundle exec shoperb init <template> <handle>
```

### pull
Fetches updates from the remote theme into your local copy.
```bash
$ bundle exec shoperb pull [options]
```

### push
Uploads local changes to the remote Shoperb theme.
```bash
$ bundle exec shoperb push [options]
```

### serve
Runs a local server to preview the theme.
alias: mount
```bash
$ bundle exec shoperb serve [options]
```

### sync
Clones products, categories, images, collections, and vendors from your shop.
```bash
$ bundle exec shoperb sync
```

## Authentication and Configuration

- Commands that talk to your shop (e.g., `clone`, `pull`, `push`) will guide you through any required credentials and shop details.
- Prefer environment variables or a local secrets file for tokens; never commit secrets. See the docs for current options and examples: https://shoperb.dev

## Troubleshooting

- Port already in use
  - Port 4000 busy? Try: `shoperb serve --port 4001`.

- Ruby/OpenSSL or bundler errors
  - Ensure Ruby ≥ 3.2.0 and Bundler ≥ 2.x. Try `gem install bundler` and `bundle update`.

- Failed to download or initialize template
  - Check your connection and retry `shoperb init`. Verify the template name (e.g., `theme-blank`). See the docs for details.

- Authentication issues
  - Re-run the command and follow the prompts. Double‑check your shop handle/domain and tokens. See https://shoperb.dev for supported auth methods.

## Links

- Homepage: https://www.shoperb.com
- Documentation: https://shoperb.dev
- Issues: https://github.com/shoperb/theme-editor/issues
- Contributing: CONTRIBUTING.md
- License: MIT (LICENSE)
