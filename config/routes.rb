SuperbTextConstructor::Engine.routes.draw do
  root 'blocks#index'
  resources :blocks, except: [:index, :show, :new, :edit] do
    post :create_nested, on: :member
    post :reorder, on: :collection
  end
end
