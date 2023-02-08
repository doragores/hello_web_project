require "spec_helper"
require "rack/test"
require_relative '../../app'


def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do

  before(:each) do
    reset_artists_table
  end

  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /albums" do
    it 'returns a list of albums' do
      # Assuming the post with id 1 exists.
      response = get('/albums')
      expected_response = 'Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_response)
    end
  end

  context "POST /albums" do
    it 'creates a new album' do
      response = post(
        '/albums', 
        title: 'OK Computer', 
        release_year: '1997', 
        artist_id: '1'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')

      expect(response.body).to include('OK Computer')
    end
  end

  context "POST /artists" do
    it 'creates a new artist' do
      response = post(
        '/artists', 
        name: 'Billie Eilish', 
        genre: 'Pop', 
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')

      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone, Billie Eilish')
    end
  end

  # context "GET /artists" do
  #   it 'returns a list of artists' do
  #     response = get('/artists')
  #     expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Billie Eilish'

  #     expect(response.status).to eq(200)
  #     expect(response.body).to eq(expected_response)
  #   end
  # end
end
