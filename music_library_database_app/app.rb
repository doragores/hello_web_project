# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    # also_reload 'lib/album_repository'
    # also_reload 'lib/artist_repository'
    get '/albums' do
      repo = AlbumRepository.new
      albums = repo.all

      response = albums.map do |album|
        album.title
      end.join(', ')
      return response
    end
  end
end