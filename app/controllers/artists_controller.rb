class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :edit, :update, :destroy]

  # GET /artists
  # GET /artists.json
  def index
    @artists = Artist.all
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
  end

  # GET /artists/new
  def new
    @artist = Artist.new
  end

  # GET /artists/1/edit
  def edit
  end

  # POST /artists
  # POST /artists.json
  def create
    @artist = Artist.new(artist_params)
    @artist.name = @artist.name.split.map(&:capitalize).join(' ')
    if @artist.name.include? " And "
      @artist.name.sub! " And ", " and "
    end

    respond_to do |format|
      if @artist.save
        @artist.artist_echo_info
        @artist.get_musicbrainz_albums_and_ids
        @artist.get_album_tracklist
        @artist.get_album_cover
        @artist.related_artists_echo
        @artist.save
        format.html { redirect_to @artist, notice: 'Artist was successfully created.' }
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
  def update
    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_params
      params.require(:artist).permit(:name, :biography, :photo, :genre, :related_artist, albums_attributes: [:name])
    end
end
