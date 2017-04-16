shared_examples_for 'correct response' do
  it { expect(response.content_type).to eq 'application/json' }
  it { expect(response.status).to eq http_code }
  it { expect(response.body).to eq response_body }
end
