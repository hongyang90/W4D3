class SessionsController < ApplicationController

    def new
      render :new
    end 

    def create
      user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
      # debugger
      if user
        login!(user)

        render json: user 
      else
        #show_errors
      end 
    end 

    def destroy
      logout! 

      redirect_to cats_url
    end 

end 