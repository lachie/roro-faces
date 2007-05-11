module UsersHelper
  def affiliation_to_sentence(a)
    out = []
    
    out << (a.regular? ? "is a regular at" : "has visited")
    out << "has presented at" if a.presenter?
    

    if out.empty?
      "is a regular at #{link_to_group(a.group)}"
    else
      "#{out.to_sentence} #{link_to_group(a.group)}"
    end
  end
  
  def link_to_group(group)
    link_to group.name, group_path(group)
  end
  

end