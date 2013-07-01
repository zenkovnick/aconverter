class UserFilesController < ApplicationController
  # GET /user_files
  # GET /user_files.json
  def index
    @user_files = UserFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_files }
    end
  end

  # GET /user_files/1
  # GET /user_files/1.json
  def show
    @user_file = UserFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_file }
    end
  end

  # GET /user_files/new
  # GET /user_files/new.json
  def new
    @user_file = UserFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_file }
    end
  end

  # GET /user_files/1/edit
  def edit
    @user_file = UserFile.find(params[:id])
  end

  # POST /user_files
  # POST /user_files.json
  def create
    uploaded_io = params[:user_file][:name]
    if uploaded_io.present?
      @user_file = UserFile.new
      upload_dir = Rails.root.join('public', 'uploads')
      Utils.check_folder(upload_dir)
      respond_to do |format|
        if Utils.check_content_type(uploaded_io.content_type)
          File.open(upload_dir.join(Utils.conver_file_name(uploaded_io.original_filename)), 'wb') do |file|
            if file.write(uploaded_io.read)
              @user_file.name = Utils.conver_file_name(uploaded_io.original_filename)
              @user_file.user = current_user
              @user_file.content_type = uploaded_io.content_type
              @user_file.status = 'queued'
              if @user_file.save()
                format.html { redirect_to current_user, notice: 'File was successful uploaded' }
                format.json { render json: @user_file, status: :created, location: users_path }
              else
                format.html { render action: 'new' }
                format.json { render json: @user_file.errors, status: :unprocessable_entity }
              end
            else
              format.html { render action: 'new' }
              format.json { render json: @user_file.errors, status: :unprocessable_entity }
            end
          end
        else
          flash[:notice] = 'File type is not supproted'
          format.html { render action: 'new' }
          format.json { render json: @user_file.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /user_files/1
  # PUT /user_files/1.json
  def update
    @user_file = UserFile.find(params[:id])

    respond_to do |format|
      if @user_file.update_attributes(params[:user_file])
        format.html { redirect_to @user_file, notice: 'User file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_files/1
  # DELETE /user_files/1.json
  def destroy
    @user_file = UserFile.find(params[:id])
    @user_file.destroy

    respond_to do |format|
      format.html { redirect_to user_files_url }
      format.json { head :no_content }
    end
  end

  def check_status
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: {:status => session[:status].present?} }
    end
  end

  def send_to_save
    if params[:file_id].present?
      file_obj = UserFile.find(params[:file_id])
      @user = file_obj.user
      file_path = Rails.root.join('public', 'uploads',  file_obj.file_name+file_obj.output_format)
      if File.file?(file_path)
        File.open(file_path, 'rb') do |file|
          send_file(file, :filename =>  file_obj.name+file_obj.output_format, :stream => true, :buffer_size => 4096)
        end
      else
        respond_to do |format|
          format.html { redirect_to @user }
        end
      end
    end

  end
end
