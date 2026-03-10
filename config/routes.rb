KeystoneColors::Engine.routes.draw do
  root "settings#show", as: :keystone_colors_root
  patch "/", to: "settings#update"
  delete "/", to: "settings#destroy"
end
