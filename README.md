# SuperbTextConstructor

Mountable WYSIWYG editor for your Rails applications

## Installation

Add this line to your application's Gemfile:

    gem 'superb_text_constructor'

And then execute:

    $ bundle

Run the install generator:

    $ rails g superb_text_constructor:install

## Configuration

Install generator creates `config/initializers/superb_text_constructor.rb` file. It has the following options:

### configs_path

SuperbTextConstructor blocks are configured by YAML files. Specify path to those files here:

    # If all your configs are in the single file
    config.configs_path = "#{Rails.root}/config/superb_text_constructor.yml"

    # If yor prefer to split config to separate files
    config.configs_path = [
      "#{Rails.root}/config/superb_text_constructor_blocks.yml",
      "#{Rails.root}/config/superb_text_constructor_namespaces.yml"
    ]

### default_namespace

It is `default` by default, but you can override it:

    config.default_namespace = 'blog'

### additional_permitted_attributes

By default `BlocksController` permits all the attributes described in YAML config. Sometimes it is not enough, e.g. when you add relations to Block model. You can override BlocksController, but there is easier way if no other overrides are required. List those additional attributes in config like that:

    config.additional_permitted_attributes = {
      item_ids: [],
      images_attributes: [:id, :image, :_destroy]
    }

## YAML config

YAML config consists of 2 parts: blocks and namespaces.

### Blocks

Blocks part contains description of all blocks available in your application. For example:

    blocks:
      text:
        fields:
          text:
            type: string
            required: true

### Namespaces

Namespaces part contains options for different WYSIWYG editors. For example, you need editors for blog and emails:

    namespaces:
      blog:
        headers:
            - h2
            - h3
        no_group:
            - text

      emails:
        no_group:
          - text
          - image

There will be different sets of buttons in WYSIWYG editors depending on the configs above.

## Usage

### Setup model

Add WYSIWYG blocks support to any of your models by including `SuperbTextConstructor::Concerns::Blockable` mixin:

      class Post < ActiveRecord::Base
        include SuperbTextConstructor::Concerns::Blockable
      end

### Setup routes

Then add the following line to the `config/routes.rb`:

    superb_text_constructor_for :posts

It adds URL helpers for WYSIWYG editor. To open it use the following one:

    = link_to 'Edit', post_superb_text_constructor_path(@post, namespace: :blog)

Used namespace should be specified in YAML config.

### Setup views

SuperbTextConstructor has few built-in blocks. Of course, you will add more in your YAML config. So, you have to provide partials for them. All partials should be placed in `app/views/superb_text_constructor/blocks` directory.

The easiest case is when all your blocks have the same markup in all namespaces. Assume, that default namespace is called `default`. Then your directories tree will look like:

    app
      views
        superb_text_constructor
          blocks
            default
              _text.html.erb
              _quote.html.erb
              _button.html.erb
              _big_red_button.html.erb

It is not necessary to add built-in blocks here. The only reason to add these blocks is to override them.

So, we have added partials for all the blocks in default namespace. But what if they should look different in blog (assuming, that `blog` is one of the namespaces)? In this case add new partials like that:

    app
      views
        superb_text_constructor
          blocks
            default
              _text.html.erb
              ...
            blog
              _h2.html.erb
              _h3.html.erb
              _text.html.erb
              ...

To render the resulting page use this helper:

    = render_blocks @post.blocks

It will render post's blocks using partials from default namespace. Or you can specify the namespace:

    = render_blocks @post.blocks, namespace: :blog

### Customization

#### Layout

There are 2 ways to customize layout:

1. Override the whole `app/views/layouts/superb_text_constructor/application.html.erb` file. It is quite obvious.
2. Override its customizable parts.

Customizable parts are:

* `app/assets/stylesheets/superb_text_constructor/custom.css` Additional CSS
* `app/assets/javascripts/superb_text_constructor/custom.js` Additional Javascript
* `app/views/superb_text_constructor/partials/menu.html.erb` Menu on layout

All these parts are empty by default, so feel free to change them.