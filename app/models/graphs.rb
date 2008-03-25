module Graphs
  def dottify(name='faces',&block)
    output = %{digraph #{name} \{
      ratio=auto;
      size="12,12";
      overlap=scale;
      splines=true;
      sep=.5;
      margin=".1,.1";
      bgcolor="#d6bf94"

    	node [shape=circle, fixedsize=true, fontcolor=red, fontname=Helvetica, fontsize=14, color=blue];
    	edge [arrowsize=0.5, color="#a6803a"];
    }
    yield(output)
    output << "}"
    output
    
  end
end