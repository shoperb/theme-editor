# Shoperb Theme Editor

Shoperb Theme Editor is a ruby gem designed to simplify the creating and updateing of Shoperb themes.

## Installation
### Install ruby
Guides could be found  [here](https://www.ruby-lang.org/en/documentation/installation/).


### Setup project
#### First option: in one line
Copy-paste given command in console:
```
echo -e "source \"https://rubygems.org\"\ngem \"shoperb-theme-editor\", git: \"https://github.com/shoperb/theme-editor.git\"\ngem \"shoperb_liquid\", git: \"https://github.com/shoperb/shoperb-liquid.git\"\ngem 'artisans',  git: 'https://github.com/shoperb/artisans.git'\n" > Gemfile && bundle
```

#### Second option: in steps
Create Gemfile:
```ruby
source "https://rubygems.org"

gem "shoperb-theme-editor", git: 'git@github.com:shoperb/theme-editor'
gem 'shoperb_liquid',  git: 'git@github.com:shoperb/shoperb-liquid'
gem "artisans", git: "git@github.com:shoperb/artisans"
```
And then execute:
```bash
$ bundle
```

## Usage
#### Execute `bundle exec shoperb pull'
This downloads the necessary theme files for the theme to run locally.
#### Execute `bundle exec shoperb sync'
This makes your local theme get the same data your regular shop would have.
#### Execute `bundle exec shoperb serve'
This runs the local theme.
#### Open http://localhost:4000 in browser

## Available commands

### clone
Downloads your shops shoperb theme
```bash
$ bundle exec shoperb clone <directory> [<handle>] [options]
```

### pull
Updates your local shoperb theme
```bash
$ bundle exec shoperb pull [options]
```

### push
Updates your remote shoperb theme
```bash
$ bundle exec shoperb push [options]
```

### serve
Serves local as a shoperb theme file
alias: mount
```bash
$ bundle exec shoperb serve [options]
```

### sync
Clones products, categories, images, collections & vendors from your shop.
```bash
$ bundle exec shoperb sync
```
