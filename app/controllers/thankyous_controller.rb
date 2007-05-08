class ThankyousController < ApplicationController
  
  def new
    @thankyou = Thankyou.new(:from_id => current_user.id, :to_id => params[:to_id])
    
    render(:update) do |p|
      p.replace_html :thankyous, :partial => 'users/thankyou_reason'
    end
  end
  
  def create
    return create_with_secret if params[:hash]
    
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
  
  def create_with_secret
    args = {
      :reason => params[:reason],
      :to     => params[:to],
      :from   => params[:from]
    }
    
    hash = HashHasher.mk_hash(SHARED_SECRET,args)
    
    #logger.debug "h1: #{hash}"
    #logger.debug "h2: #{params[:hash]}"
    
    raise "shared secrets didn't match" if hash != params[:hash]
    
    from = User.find_by_irc_nick(params[:from]) or raise "unknown from user #{params[:from]}"
    to   = User.find_by_irc_nick(params[:to]  ) or raise "unknown to user #{params[:to]}"
    
    raise "wanking not allowed" if from == to
    raise "you need a reason" if params[:reason].blank?
    
    t = Thankyou.create(:from => from, :to => to, :reason => params[:reason])
    
    raise "failed to owe #{params[:to]}" unless t
    
    render :text => "#{from.irc_nick} thanked #{to.irc_nick} for #{params[:reason]}"
  rescue
    logger.warn $!
    logger.warn $!.backtrace * $/
    render :text => $!.to_s, :status => 500
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