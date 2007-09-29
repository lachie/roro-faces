module UsersHelper
  def affiliation_to_sentence(a)
    return once_off_affiliation_sentence(a) if a.group.once_off?
    
    out = []
    
    out << (a.regular? ? "is a regular at" : "has visited")
    out << "has presented at" if a.presenter?
    

    if out.empty?
      "is a regular at #{link_to_group(a.group)}"
    else
      "#{out.to_sentence} #{link_to_group(a.group)}"
    end
  end
  
  def once_off_affiliation_sentence(a)
    presented = a.presenter? ? "and presented at " : ''
    "attended #{presented}#{link_to_group(a.group)}"
  end
  
  def link_to_group(group)
    link_to group.name, group_path(group)
  end
  
  def beerating(user,score)
    rscore = "%.2f" % score

    out = '<li>' +
    link_to(user.nick, user_path(user)) +
    '<br/>'
    
    score.to_i.times do |t|
      out << image_tag('lilbeer.gif', :class => 'beer', :title => rscore)
    end

    out << image_tag('lilbeer_half.png', :class => 'beer', :title => rscore) if score > score.to_i
    out << '</li>'
    
    out
  end
end