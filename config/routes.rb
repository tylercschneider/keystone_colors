KeystoneColors::Engine.routes.draw do
  root "settings#show"
  patch "/", to: "settings#update"
  delete "/", to: "settings#destroy"
end
