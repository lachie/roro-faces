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
    
    raise "n0 h4XX0rz" if hash != params[:hash]
    
    from = User.find_by_stripped_irc_nick(params[:from]) or raise "unknown from user #{params[:from]}"
    to   = User.find_by_stripped_irc_nick(params[:to]  ) or raise "unknown to user #{params[:to]}"
    
    raise "no wanking" if from == to
    raise "gimme a reason" if params[:reason].blank?
    
    t = Thankyou.create(:from => from, :to => to, :reason => params[:reason])
    
    raise "couldn't owe #{params[:to]} for some reason" unless t
    
    render :text => "you owe a beer to #{to.irc_nick} for #{params[:reason]}"
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
    respond_to do |wants|
      wants.html
      wants.xml  { render :text => @thankyous.to_xml }
      wants.json { render_json @thankyous.to_json }
    end
  end
  
  def show
    @thankyou = Thankyou.find(params[:id])
    redirect_to thankyous_path(:to_id => @thankyou.to_id)
  end
  

  def beergraph
    @page_title = 'beer graph'
    png = File.join(RAILS_ROOT,'public','images','beergraph.png')
    if File.exist?(png)
      @built_ago  = Time.now-File.ctime(png)
    else
      @not_built = true
    end
  end
end