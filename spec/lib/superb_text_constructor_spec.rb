RSpec.describe SuperbTextConstructor do
  it 'has a version' do
    expect(SuperbTextConstructor::VERSION).not_to be_nil
  end

  describe '.namespace' do
    before { SuperbTextConstructor.instance_variable_set(:@namespaces, nil) }

    it 'creates new namespace' do
      expect { SuperbTextConstructor.namespace(:first) }.to change { SuperbTextConstructor.namespaces.count }.from(0).to(1)
      expect { SuperbTextConstructor.namespace(:second) { 1 + 1 } }.to change { SuperbTextConstructor.namespaces.count }.from(1).to(2)
    end

    it 'returns Namespace object' do
      result = SuperbTextConstructor.namespace(:default)
      expect(result).to be_kind_of(SuperbTextConstructor::Namespace)
      expect(result.name).to eq(:default)
    end
  end

end
