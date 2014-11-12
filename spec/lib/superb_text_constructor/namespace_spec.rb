RSpec.describe SuperbTextConstructor::Namespace do
  subject { SuperbTextConstructor::Namespace.new(:default) }

  describe '.use' do
    context 'block class was defines' do
      it 'returns its class' do
        expect(subject.use(:h2)).to eq(SuperbTextConstructor::H2)
      end

      it 'adds its class to @blocks variable' do
        expect { subject.use(:h3) }.to change { subject.instance_variable_get(:@blocks).count }.by(1)
        expect(subject.instance_variable_get(:@blocks).last).to eq(SuperbTextConstructor::H3)
      end
    end

    context 'block class was not defines' do
      it 'raises NameError' do
        expect { subject.use(:unknown_block) }.to raise_error(NameError)
      end
    end
  end

  describe '.group' do
    it 'adds another namespace into @blocks' do
      expect { subject.group(:inner) }.to change { subject.instance_variable_get(:@blocks).count }.by(1)
      added_namespace = subject.instance_variable_get(:@blocks).last
      expect(added_namespace).to be_kind_of(SuperbTextConstructor::Namespace)
      expect(added_namespace.name).to eq(:inner)
    end
  end
end
