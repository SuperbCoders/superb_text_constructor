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
      type SuperbTextConstructor::DefaultUploader
      partial :image
      required
    end
  end

  block :separator

  namespace :default do
    group :headers do
      use :h2
      use :h3
    end
    use :text
    use :separator
    use :image
  end

end
