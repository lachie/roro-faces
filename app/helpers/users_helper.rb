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
  

end