class WelcomeController < ApplicationController
  
  def index
    redirect_to :controller => 'user', :action => 'dashboard' if current_user
  end

  def letsencrypt
  	render text: "z2A7ewjHt0xrM80o8hY1_dA9sOr44VM__wxivj6RYOw.VZocXYzD5wDrlngmn-gXmqEsnSgFjps0s9qPEdPp4f4"
  end
end
