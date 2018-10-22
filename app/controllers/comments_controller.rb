class CommentsController < ApplicationController     
    private
        def comment_params
            params.require(:comment).permit(:commenter, :body, :comment_type, :make_public, :bibliography_id)
        end
end
