class ThankyousController < ApplicationController
  def new
    @thankyou = Thankyou.new(:from_id => current_user.id, :to_id => params[:to_id])
    
    render(:update) do |p|
      p.replace_html :thankyous, :partial => 'users/thankyou_reason'
    end
  end
  
  def create
    @thankyou = Thankyou.new(params[:thankyou])
    @thankyou.save!
    
    @user = @thankyou.to
    
    respond_to do |wants|
      wants.js {
      render(:update) do |p|
        p.replace_html :thankyous, :partial => 'users/thankyous'
      end
      }
    end
  rescue
    respond_to do |wants|
      wants.js {
      render(:update) do |p|
        p.replace_html :thankyous, :partial => 'users/thankyou_reason'
      end
      }
    end
  end
  
  def index
    if params[:to_id]
      @to = User.find(params[:to_id])
      @thankyous = @to.thankyous_to
    else
      @thankyous = Thankyou.find(:all,:order => 'updated_at desc')
    end
  end
  
  def show
    @thankyou = Thankyou.find(params[:id])
    redirect_to thankyous_path(:to_id => @thankyou.to_id)
  end
end