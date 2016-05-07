class VarnishTestContextManager
  @instance = nil

  VARNISHTEST_FILE = "generated.varnishtest"

  # Server level expectations
  attr_writer :expected_cache_hits
  attr_writer :expected_cache_misses
  attr_writer :expected_request_count
  attr_writer :expected_piped_requests
  attr_writer :expected_passed_requests

  attr_writer :vcl_file

  def self.instance()
    # Get instance from class
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

  def add_context(info)
    get_context << info
  end

  def request(path, method)
    @requests ||= []
    @requests << VarnishtestRequest.new(path, method)
  end

  def client_expect(attribute, value)
    @client_expectations ||= {}
    @client_expectations[attribute] = value
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
        (@requests || []).map{|req| req.to_varnishtest}.join("\n\n")
      }

      #{
        (@client_expectations || []).map do |attribute, value|
          "expect #{attribute} == #{value}"
        end.join("\n")
      }
    } -run

    #{@expected_cache_hits.nil? ? "" : "varnish v1 -expect cache_hit == #{@expected_cache_hits}"}
    #{@expected_cache_misses.nil? ? "" : "varnish v1 -expect cache_miss == #{@expected_cache_misses}"}
    #{@expected_request_count.nil? ? "" : "varnish v1 -expect client_req == #{@expected_request_count}"}
    #{@expected_piped_requests.nil? ? "" : "varnish v1 -expect s_pipe == #{@expected_piped_requests}"}
    #{@expected_passed_requests.nil? ? "" : "varnish v1 -expect s_pass == #{@expected_passed_requests}"}
    eos
  end

  def test!
    File.open(VARNISHTEST_FILE, 'w') do |file|
      file.write(varnishtest_conf)
    end
    output = `varnishtest #{VARNISHTEST_FILE}`
    result = $? == 0

    File.open('varnishtest.err', 'w') do |file|
      file.write(output)
    end

    raise [
      output.split("\n").select{|line| line.match("---- v1")},
      "See #{VARNISHTEST_FILE} and varnishtest.err debuggin'"
    ].join("\n\n\n\n") unless result
  end
end
