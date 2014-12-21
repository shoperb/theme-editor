# Shoperb Theme Editor

Shoperb Theme Editor is a ruby gem designed to simplify the creating and updateing of Shoperb themes.

## Quick start
```
echo 'ruby-2.1' > .ruby-version
echo 'shoperb-themes' > .ruby-gemset
echo "source 'https://rubygems.org'" > Gemfile
echo "gem 'shoperb-theme-editor', :git => 'git@code.perfectline.co:shoperb/theme-editor.git'" >> Gemfile
echo "gem 'liquid', github: 'Shopify/liquid', :ref => 'f15d24509d0f429f56284da527e6186708a27725'" >> Gemfile

bundle
```

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