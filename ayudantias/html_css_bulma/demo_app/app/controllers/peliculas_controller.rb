class PeliculasController < ApplicationController
  

  def index
    @peliculas = Pelicula.all
  end


  def show
    @pelicula = Pelicula.find(params[:id])
  end


  def new
    @pelicula = Pelicula.new
  end


  def create
    pelicula_params = params.require(:pelicula).permit(:titulo, :ano, :director, :descripcion, :photo_url)
    @pelicula = Pelicula.create(pelicula_params)

    if @pelicula.save
      redirect_to pelicula_path(@pelicula.id), notice: 'Película creada con éxito'
    else
      redirect_to peliculas_new_path, notice: 'Ocurrió un error al crear la película.'
    end

  end


  def edit
    @pelicula = Pelicula.find(params[:id])
  end


  def update
    pelicula_params = params.require(:pelicula).permit(:titulo, :ano, :director, :descripcion, :photo_url)
    @pelicula = Pelicula.find(params[:id])

    if @pelicula.update(pelicula_params)
      redirect_to pelicula_path(@pelicula.id), notice: 'Película editada con éxito'
    else
      redirect_to peliculas_new_path, notice: 'Ocurrió un error al editar la película.'
    end
  end


  def destroy
    @pelicula = Pelicula.find(params[:id])
    @pelicula.destroy
    redirect_to peliculas_path, notice: 'Película eliminada con éxito'
  end

  
end
