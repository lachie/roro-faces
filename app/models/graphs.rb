module Graphs
  def dottify(name='faces',&block)
    output = %{digraph #{name} \{
      ratio=auto;
      size="12,12";
      overlap=scale;
      splines=true;
      sep=.5;
      margin=".1,.1";
      bgcolor=white;

    	node [shape=circle, fixedsize=true, fontcolor="#86171d", fontname=Helvetica, fontsize=14, color=blue];
    	edge [arrowsize=0.5, color=gray];
    }
    yield(output)
    output << "}"
    output
    
  end
end