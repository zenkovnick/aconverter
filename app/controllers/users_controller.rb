class UsersController < ApplicationController
  before_filter :require_login

  # GET /users
  # GET /users.json

  def index
    if user_signed_in?
      @user_info = {
          :forward_friendships => current_user.friendships.where(:is_active => true),
          :inverse_friendships => current_user.inverse_friendships.where(:is_active => true),
          :invited => current_user.friendships.where(:is_active => false),
          :invites => current_user.inverse_friendships.where(:is_active => false),
      }

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      if current_user.is_active_friend?(@user) || current_user === @user
        @files = @user.user_files.where(:status => 'available').order('created_at DESC')
        @user.user_files.update_all({:status => 'available'}, {:status => 'uploaded'})
        format.html # show.html.erb
        format.json { render json: @user }
      else
        format.html { redirect_to users_path, notice: 'This user is not your friend' }
        format.json { render json: 'This user is not your friend', status: :unprocessable_entity }
      end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /users/search
  def search
    @user = User.new
    if params.has_key?(:user)
      user = User.new(params[:user])
      if user.email.present? && user.username.present?
        @friends = User.where(:email => user.email, :username => user.username)
      elsif user.email.present?
        @friends = User.where(:email => user.email)
      elsif user.username.present?
        @friends = User.where(:username => user.username)
      end
    end
  end

  def ajax_get
    @user = User.find(params[:user_id])
    respond_to do |format|
      if @user.present?
        @files = @user.user_files.where(:status => 'uploaded')
        files_count = @files.count
        partial_content = ''
        @files.each do |file|
          partial_content += render_to_string :template => 'users/_audio_entry', :layout => false, :locals => {:file_entry => file}
        end
        if files_count
          @user.user_files.update_all({:status => 'available'}, {:status => 'uploaded'})
        end

        format.html # new.html.erb
        format.json { render json: {:result => 'OK', :content => partial_content, :new_files_count => files_count} }
      else
        format.html # new.html.erb
        format.json { render json: {:result => 'Failed'} }
      end
    end
  end

  protected

  def require_login
    unless user_signed_in?
      #flash[:error] = "You must be logged in to access this section"
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.json { head :no_content }
      end
    end
  end

end
