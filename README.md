# Shoperb Theme Editor

Shoperb Theme Editor is a ruby gem designed to simplify the creating and updateing of Shoperb themes.

## Installation
Create Gemfile:
```ruby
source "https://rubygems.org"
gem "shoperb-theme-editor", github: "shoperb/theme-editor"
```
And then execute:
```bash
$ bundle
```

## Usage
#### Execute `shoperb pull'
This downloads the necessary theme files for the theme to run locally.
#### Execute `shoperb sync'
This makes your local theme get the same data your regular shop would have.
#### Execute `shoperb serve'
This runs the local theme.
#### Open http://localhost:4000 in browser

## Available commands

### clone
Downloads your shops shoperb theme
```bash
$ shoperb clone <directory> [<handle>] [options]
```

### pull
Updates your local shoperb theme
```bash
$ shoperb pull [options]
```

### push
Updates your remote shoperb theme
```bash
$ shoperb push [options]
```

### serve
Serves local as a shoperb theme file
alias: mount
```bash
$ shoperb serve [options]
```

### sync
Clones products, categories, images, collections & vendors from your shop.
```bash
$ shoperb sync
```

## TODOS
* [TODOREF1: Link handle not unique](http://code.perfectline.co/search?search=TODOREF1&project_id=64&search_code=true)
* [TODOREF2: Fields/primary_key/relations not set](http://code.perfectline.co/search?search=TODOREF2&project_id=64&search_code=true)
* [TODOREF3: Search](http://code.perfectline.co/search?search=TODOREF3&project_id=64&search_code=true)
* [TODOREF4: Remove delegate drops](http://code.perfectline.co/search?search=TODOREF4&project_id=64&search_code=true)
* [TODOREF5: Get controller instance variables from drops](http://code.perfectline.co/search?search=TODOREF5&project_id=64&search_code=true)
