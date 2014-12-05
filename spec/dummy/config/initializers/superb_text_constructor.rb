SuperbTextConstructor.configure do

  block :h2 do
    field :text do
      type String
      partial :string
      required
    end
  end

  block :h3 do
    field :text do
      type String
      partial :string
      required
    end
  end

  block :text do
    field :text do
      type String
      partial :text
      required
    end
  end

  block :image do
    field :image do
      type SuperbTextConstructor::ImageUploader
      partial :image
      required
    end
  end

  block :gallery do
    nested_blocks :images do
      field :image do
        type SuperbTextConstructor::ImageUploader
        partial :image
        required
      end
    end
  end

  block :separator

  namespace :default do
    group :headers do
      use :h2
      use :h3
      block :h4 do
        field :text
      end
    end
    group :images do
      use :image
      use :gallery
    end
    use :text
    use :separator
  end

  namespace :no_headers do
    use :text
    use :separator
    use :image
    use :gallery
  end

end
