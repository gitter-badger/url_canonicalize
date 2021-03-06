describe URLCanonicalize::HTTP do
  let(:host) { 'www.twitter.com' }
  let(:protocol) { 'http' }
  let(:url) { "#{protocol}://#{host}" }
  let(:http) { URLCanonicalize::HTTP.new(url) }
  let(:fetch_double) { double }
  let(:response) { URLCanonicalize::Response::Success.new(url, '', '') }

  it 'returns a Net::HTTPOK' do
    expect(URLCanonicalize::Request).to receive(:new).once.and_return(fetch_double)
    expect(fetch_double).to receive(:fetch).once.and_return(response)
    expect(http.fetch).to be_a(URLCanonicalize::Response::Success)
  end

  it 'fails on more than the maximum number of redirects' do
    responses = Array.new(11) { |i| URLCanonicalize::Response::Redirect.new("#{url}#{i}") }
    expect(URLCanonicalize::Request).to receive(:new).exactly(11).times.and_return(fetch_double)
    expect(fetch_double).to receive(:fetch).exactly(11).times.and_return(*responses)
    expect { http.fetch }.to raise_error(URLCanonicalize::Exception::Redirect, '11 redirects is too many')
  end

  it 'detects a redirect loop' do
    responses = [url, "#{url}xxx", url].map { |u| URLCanonicalize::Response::Redirect.new(u) }
    expect(URLCanonicalize::Request).to receive(:new).exactly(3).times.and_return(fetch_double)
    expect(fetch_double).to receive(:fetch).exactly(3).times.and_return(*responses)
    expect { http.fetch }.to raise_error(URLCanonicalize::Exception::Redirect, 'Redirect loop detected')
  end
end
