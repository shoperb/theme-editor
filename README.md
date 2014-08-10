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

### pull
Downloads your shops shoperb theme
```bash
$ shoperb pull [options]
```

### push
Uploads your local shoperb theme to your shop
```bash
$ shoperb push [options]
```

### mount
Serves local as a shoperb theme file
```bash
$ shoperb mount [options]
```

### init
Initiates a shoperb theme template
```bash
$ shoperb init <foundation,bootstrap,blank> [options]
```

### clean
Removes configuration file
```bash
$ shoperb clean
```

### dummy_data
Clones default dummy data to the theme (also done on pull and init). Won't overwrite already excisting data files.
```bash
$ shoperb dummy_data
```