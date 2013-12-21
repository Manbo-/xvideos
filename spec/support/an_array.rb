shared_examples_for "an array" do
  it do
    expect(array.size).to be_a_kind_of Integer
  end

  it do
    expect(array).to be_respond_to :each
  end
end
