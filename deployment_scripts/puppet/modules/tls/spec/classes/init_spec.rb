require 'spec_helper'
describe 'https' do

  context 'with defaults for all parameters' do
    it { should contain_class('https') }
  end
end
