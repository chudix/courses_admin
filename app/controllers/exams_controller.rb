class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy]
  before_action :set_course, only: [:index]
  # GET /exams
  # GET /exams.json
  def index
    @exams = @course.exams
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
  end

  # GET /exams/new
  def new
    @course = Course.find(params[:course_id])
    @exam = Exam.new
  end

  # GET /exams/1/edit
  def edit
    
  end

  # POST /exams
  # POST /exams.json
  def create
    @exam = Exam.new(exam_params)
    @course = Course.find(params[:course_id])
    @exam.course = @course
    @exam.exam_date = to_datetime exam_params
    respond_to do |format|
      if @exam.save
        format.html { redirect_to course_exams_path(@exam.course), notice: 'La evaluacion fue creada exitosamente' }
        format.json { render :show, status: :created, location: @exam }
      else
        format.html { render :new }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exams/1
  # PATCH/PUT /exams/1.json
  def update
    respond_to do |format|
      if @exam.update(exam_params)
        format.html { redirect_to course_exams_path(@exam.course), notice: 'La evaluacion fue modificada exitosamente.' }
        format.json { render :show, status: :ok, location: @exam }
      else
        format.html { render :edit }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy
    course = @exam.course
    @exam.destroy
    respond_to do |format|
      format.html { redirect_to course_exams_path(course), notice: 'La evaluacion fue borrada exitosamente.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_exam
    @exam = Exam.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def exam_params
    params.require(:exam).permit(:title, :description, :min_grade, :exam_date)
  end

  def to_datetime request_params
    datetime_params = request_params.select do |k,v|
      k =~ /exam_date\(/
    end
                      .values.map do |e|
      e.to_i
    end
    puts datetime_params
    DateTime.new *datetime_params
  end
end
