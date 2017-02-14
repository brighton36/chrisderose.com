ChrisderoseCom::Application.routes.draw do
  root "viewhandler#index"

  get '/images/video-thumbnails/:section/:title.jpg', to: 'videos#thumbnail', as: 'video_thumbnail'
  get '/video/:title', to: 'videos#show', as: 'video'
end
