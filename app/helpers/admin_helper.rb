module AdminHelper
  def list_of_children(parent,kids,&block)
    kid_lis = parent.send(kids).collect do |kid|
      "<li>#{capture(kid,&block)}</li>"
    end
    
    "<ul>#{kid_lis * ''}</ul>"
  end
end