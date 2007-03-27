module UsersHelper
  def affiliation_to_sentence(a)
    out = []
    out << "is a regular at" if a.regular?
    out << "has presented at" if a.presenter?
    out << "has visited"   if a.visitor?

    if out.empty?
      "is a regular at #{link_to_group(a.group)}"
    else
      "#{out.to_sentence} #{link_to_group(a.group)}"
    end
  end
  
  def link_to_group(group)
    link_to group.name, group.url
  end
end