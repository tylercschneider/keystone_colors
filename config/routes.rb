KeystoneColors::Engine.routes.draw do
  root "keystone_colors/settings#show", as: :keystone_colors_root
  patch "/", to: "keystone_colors/settings#update"
  delete "/", to: "keystone_colors/settings#destroy"
end
