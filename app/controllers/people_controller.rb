class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
    #if we are coming from the seed page, seed stuff
    if params[:seed].nil?
    else 
      SeedTrainingData.new()
    end
    #if we are coming from the reset page, delete all trained data
    if params[:reset].nil?
    else
      Person.all.each do |record|
        record.destroy
      end
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def guess
    @notice = params[:notice]
  end

  def gender
  #this controller takes input from the guess form, 
  #and sets an instance variable based on input in order
  #for our view to render an answer
  #do not allow functionality if we don't have at least one male and 1 female trained
    @height = params[:height].to_f
    @weight = params[:weight].to_f
    if Person.where(sex: 'Female').length < 3
      redirect_to controller: 'people', action: 'guess', notice: 'You must train at least 3 females!' 
    elsif Person.where(sex:'Male').length < 3
      redirect_to controller: 'people', action: 'guess', notice: 'You must train at least 3 males!' 
    else
      #initiate the classifier
      classifier = ClassifySex.new()
      #perform a classification based on values set up for our model
      @classification = classifier.classify(@height,@weight)
    end

  end

  def reset
  end

  def seed
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:sex, :height, :weight)
    end
end
