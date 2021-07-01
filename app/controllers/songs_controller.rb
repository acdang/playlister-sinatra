require 'rack-flash'

class SongsController < ApplicationController
    enable :sessions
    use Rack::Flash

    get '/songs' do
        @songs = Song.all

        erb :'/songs/index'
    end

    # THIS HAS TO GO BEFORE :SLUG
    get '/songs/new' do       
        erb :'/songs/new'
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        erb :'/songs/show'
    end

    post '/songs' do
        @song = Song.create(params[:song])

        # add artist
        matching = Artist.where("lower(name) = ?", params[:artist_name].downcase).first
        @song.artist = matching ? matching : Artist.create(name: params[:artist_name])

        # add genres
        params[:genres].each {|genre_id| @song.genres << Genre.find(genre_id)}

        @song.save
        flash[:message] = "Successfully created song."

        redirect "/songs/#{@song.slug}"
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])

        erb :'songs/edit'
    end

    patch '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])

        # update artist
        matching = Artist.where("lower(name) = ?", params[:artist_name].downcase).first
        @song.artist = matching ? matching : Artist.create(name: params[:artist_name])

        # update genres
        params[:genres].each {|genre_id| @song.genres << Genre.find(genre_id)}

        @song.save
        flash[:message] = "Successfully updated song."

        redirect "/songs/#{@song.slug}"
    end
end
