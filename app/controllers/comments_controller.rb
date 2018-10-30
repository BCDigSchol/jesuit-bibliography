class CommentsController < ApplicationController
    '''
    before_action :set_comment, only: [:show, :edit, :update, :destroy] 

    protect_from_forgery with: :exception
    #load_and_authorize_resource
 
    before_action :require_login
    before_action :authenticate_user!

    layout 'bibliography'

    def index
        @comments = Comment.all
    end

    def show
    end

    def new
        @comment = Comment.new
    end

    def edit
    end

    def create
        @comment = Comment.new(comment_params)

        if @comment.save
            respond_to do |format|
                format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
                format.json { render :show, status: :created, location: @comment }
            end
        else
            respond_to do |format|
                format.html { render :new }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        if @comment.update!(comment_params)
            respond_to do |format|
                format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
                format.json { render :show, status: :ok, location: @comment }
            end
        else
            respond_to do |format|
                format.html { render :edit }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @comment.destroy
        respond_to do |format|
            format.html { redirect_to comments_path, notice: 'Comment was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
        def set_comment
            @comment = Comment.find(params[:id])
        end
  
        def comment_params
            params.require(:comment).permit(:commenter, :body, :comment_type, :make_public, :bibliography_id)
        end
    '''
end
