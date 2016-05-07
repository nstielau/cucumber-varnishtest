class VarnishtestRequest
  def initialize(path, method)
    @path = path
    @method = method
  end

  def to_varnishtest
    return <<-eos
    txreq -url "#{@path}" -req #{@method}
    rxresp

    eos
  end
end
