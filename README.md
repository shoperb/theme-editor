# Shoperb Theme Editor

Shoperb Theme Editor is a ruby gem designed to simplify the creating and updateing of Shoperb themes.

## Installation

Add this line to your Gemfile:
```ruby
gem 'shoperb-theme-editor'
```
And then execute:
```bash
$ bundle
```
Or install it yourself as:
```bash
$ gem install shoperb-theme-editor
```

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

### mount
Serves local as a shoperb theme file
alias: serve
```bash
$ shoperb mount [options]
```

### init
Initiates a shoperb theme template
```bash
$ shoperb init <foundation,bootstrap,blank> [options]
```

### dummy_data
Clones default dummy data to the theme (also done on pull and init). Won't overwrite already excisting data files.
```bash
$ shoperb dummy_data
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