module SuperbTextConstructor
  class Engine < ::Rails::Engine
    isolate_namespace SuperbTextConstructor

    initializer 'superb_text_constructor.view_helpers' do |app|
      ActionView::Base.send :include, SuperbTextConstructor::ViewHelpers::RenderBlocksHelper
      ActionView::Base.send :include, SuperbTextConstructor::ViewHelpers::EditorHelper
      ActionView::Base.send :include, SuperbTextConstructor::ViewHelpers::SanitizeBlockHelper
    end

    initializer 'superb_text_constructor.assets.precompile' do |app|
      app.config.assets.precompile += %w( superb_text_constructor/custom.js superb_text_constructor/custom.css )
    end

  end
end
