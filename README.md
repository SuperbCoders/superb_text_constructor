# SuperbTextConstructor

Mountable WYSIWYG editor for your Rails applications

## Installation

Add this line to your application's Gemfile:

    gem 'superb_text_constructor'

And then execute:

    $ bundle

Run the installation generator:

    $ rails g superb_text_constructor:install

Run the migrations:

    $ rake db:migrate

## Configuration

`SuperbTextConstructor` has several configuration options. You can read and change them in the `config/initializers/superb_text_constructor.rb` initializer created by installation generator.

## Blocks definition

There are 2 ways to define a new type of block. The first one is to create `app/models/superb_text_constructor/my_block.rb` model. It should be inherited from `SuperbTextConstructor::Block` class, e.g.:

    class SuperbTextConstructor::MyBlock < SuperbTextConstructor::Block
      # ...
    end

Another way to define a block is to write its definition using DSL in the initializer:

    block :my_block do
      # any Ruby code here
    end

Both methods create the same block definition.

Then you must create 2 views for this block:

  * `app/views/superb_text_constructor/blocks/editor/_my_block.html.erb` This view will be used in the WYSIWYG editor.
  * `app/views/superb_text_constructor/blocks/namespace/_my_block.html.erb` This view will be used to render your blocks on frontend. Pay attention that it should be placed inside the namespace directory (usually it is `default` if you need just one namespace). Namespaces concept will be described below.

## Fields definition

Although you can write any Ruby code in your blocks, it is meaningful to use our DSL to describe its fields.

*Note*! You are able to use it both in model and initializer. We will use DSL-definition of blocks in examples below for short.

There are already few blocks in the default initializer, so let's examine one:

    block :h2 do
      field :text do
        type String
        partial :string
        required
      end
    end

It defines `SuperbTextConstructor::H2` model which has 1 field called `text`. It is obvious that this field contains a `String` and it is required.

Actually only `type` is required parameter. Optional parameters are listed only for information purposes.

### `type` method

`type` method describes a type of the attribute.

It takes a `class` as an argument. E.g. `type String`, `type Integer`, etc.

`SuperbTextConstructor` has built-in `Carrierwave` support. So uploader class could be passed as the argument to say that this field should store a file. There is default `SuperbTextConstructor::DefaultUploader`, but feel free to use your own uploaders here.

### `partial` method

Optional. Defines name of the partial that should be used to represent this field in the block form. By default it is the same as the type in underscore case, e.g. `:string` for `String`, `:integer` for `Integer`.

By default `SuperbTextConstructor` has the following partials:

  * `string` Represents field as simple <input>
  * `text` Represents field as <textarea>
  * `image` Represents field as fileupload with preview

Feel free to use your own partials or to customize the existing ones. All you need is to create `app/views/superb_text_constructor/blocks/fields/_partial_name.html.erb` file.

There are the following local variables available in these partials:

  * `f` Block's form
  * `field` Current field

*Example* How to create custom partial?

Assume that we are writing online store and using `SuperbTextConstructor` to create items' description. It would be really cool to add fake comments to our items. :) So, lets create a `comment` block that has text and rating which is an integer from 1 to 5. We want to set rating with select box.

Write block definition:

    # config/initializers/superb_text_constructor.rb
    block :comment do
      field :text
      field :rating do
        type Integer
        partial :rating
      end
    end

As you see custom partial is used. Create a `app/views/superb_text_constructor/blocks/fields/_rating.html.erb` file:

    <div class="form-group">
      <%= f.label field.name.to_sym, class: 'col-sm-2 control-label' %>
      <div class="col-sm-10">
        <%= f.select field.name.to_sym, (1..5), {include_blank: true}, class: 'form-control' %>
      </div>
    </div>

Create views for the frontend (`app/views/superb/text_constructor/default/_comment.html.erb`) and the editor (`app/views/superb/text_constructor/editor/_comment.html.erb`) and all done!

### `required` method

Optional. Defines a field as required. `false` by default.

It accepts a `Boolean` or could be used without arguments:

    # This field is required
    field :text do
      required
    end

    # This field is required, too
    field :text do
      required true
    end

    # This field is optional
    field :text do
      required false
    end

    # And this field is optional, too
    field :text do
    end

To sum it up: fields are optional by default. Use `required` command to make the field required.

## Namespaces

Namespace is a set of blocks and their views. There should be at least one namespace defined (usually it is `default`).

When to use namespaces?

  * You want to use `SuperbTextConstructor` for your `StaticPage` and `Item` models. Static pages could be constructed by `h1` and `text` blocks, but items could be constructed by `text`, `image` and `similar_items` blocks. So, you can create 2 namespaces (`static_page` and `item`) with different sets of blocks.
  * `StaticPage` and `MailingList` models use the same set of blocks. But their HTML markup is different. So, use `static_page` and `mailing_list` namespaces.
  * You can imagine your own example where you need both different blocks and views :)

Namespaces are defined in initializer. There are 2 ways to add blocks to the namespace.

Use already defined block:

    # ...
    # assume that there are H1 and Text blocks definitions
    # ...

    namespace :page do
      use :h1
      use :text
    end

Define a block inside the namespace:

    namespace :item do
      use :text
      # define new block as usual
      block :similar_items do
        type Array
        partial :similar_items
      end
    end

In the examples above blocks' views should be placed at `app/view/superb_text_constructor/page` and `app/view/superb_text_constructor/item` directories, respectively.

The first defined namespace is the default namespace. It means that if the partial could not be found in namespace directory, partial from the default namespace will be used.

## Usage

Follow the steps below to add WYSIWYG editor to your model.

### 1. Setup model

Include `SuperbTextConstructor::Concerns::Blockable` mixin:

      # app/models/post.rb
      class Post < ActiveRecord::Base
        include SuperbTextConstructor::Concerns::Blockable
        # ...
      end

### 2. Setup routes

Then add the following line to the `config/routes.rb`:

    superb_text_constructor_for :posts

It adds URL helpers for WYSIWYG editor. To add link to the WYSIWYG use the following one:

    = link_to 'Edit', post_superb_text_constructor_path(@post, namespace: :blog)

The namespace is required parameter and it should be defined in config.

### 3. Setup views

To render the blocks use this helper:

    # e.g. in /app/views/posts/show.html.erb file
    = render_blocks @post.blocks

It will render post's blocks using partials from default namespace. You can also specify the namespace:

    = render_blocks @post.blocks, namespace: :blog

## Customization

### Layout

There are 2 ways to customize WYSIWYG editor layout:

1. Override the whole `app/views/layouts/superb_text_constructor/application.html.erb` file. It is quite obvious.
2. Override its customizable parts.

Customizable parts are:

* `app/assets/stylesheets/superb_text_constructor/custom.css` Additional CSS
* `app/assets/javascripts/superb_text_constructor/custom.js` Additional Javascript
* `app/views/superb_text_constructor/partials/menu.html.erb` Layout menu. Add here Back button or something else.

These files are empty by default, so feel free to change them.

### Controller

Override `SuperbTextConstructor::BlocksController` to provide additional logic.

*Example*. How to add `CanCan` authorization?

Create `app/controllers/superb_text_constructor/blocks_controller.rb` file with the following code:

    class SuperbTextConstructor::BlocksController < SuperbTextConstructor::Concerns::Controllers::BlocksController
      before_filter { authorize! :update, @parent }
    end
