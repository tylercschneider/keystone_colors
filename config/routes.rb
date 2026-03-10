KeystoneColors::Engine.routes.draw do
  resource :settings, only: %i[show update destroy]
end
