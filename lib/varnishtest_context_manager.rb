class VarnishTestContextManager
  @instance = nil

  VARNISHTEST_FILE = "generated.varnishtest"

  def self.instance()
    @instance ||= self.new()
  end

  def self.reset!
    # Clear out the instance, start fresh
    @instance = nil
  end

  def get_context
    @context ||= []
    return @context
  end

  def inspect
    @context.inspect
  end

  def add_context(info)
    get_context << info
  end

  def request(path)
    @requests ||= []
    @requests << path
  end

  def client_expect(attribute, value)
    @client_expectations ||= {}
    @client_expectations[attribute] = value
  end

  def expected_cache_hits(count)
    @expected_cache_hits = count
  end

  def expected_cache_misses(count)
    @expected_cache_misses = count
  end

  def desired_request_count(request_count)
    @request_count = request_count
  end

  def vcl_file filename
    @vcl_file ||=filename
  end

  def varnishtest_conf
    return <<-eos
    varnishtest "This is my first test"

    server s1 {
      #{@requests.map{"rxreq\ntxresp -body \"hello world\""}.join("\naccept\n\n")}
    } -start

    varnish v1 -vcl {
      #{File.read(@vcl_file)}
    } -start

    client c1 {
      #{
        (@requests || []).map{|path| "txreq -url \"#{path}\"\nrxresp\n"}.join("\n\n")
      }

      #{
        (@client_expectations || []).map do |attribute, value|
          "expect #{attribute} == #{value}"
        end.join("\n")
      }
    } -run

    #{@expected_cache_hits.nil? ? "" : "varnish v1 -expect cache_hit == #{@expected_cache_hits}"}
    #{@expected_cache_misses.nil? ? "" : "varnish v1 -expect cache_miss == #{@expected_cache_misses}"}
    eos
  end

  def test!
    File.open(VARNISHTEST_FILE, 'w') do |file|
      file.write(varnishtest_conf)
    end
    output = `varnishtest #{VARNISHTEST_FILE}`
    result = $? == 0

    raise [
      result,
      output,
      varnishtest_conf
    ].join("\n\n\n\n") unless result
  end
end
