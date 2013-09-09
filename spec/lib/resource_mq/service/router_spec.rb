require 'spec_helper'

describe ResourceMQ::Service::Router do
  before :each do
    described_class.route do
      service :accounts do
        action :index, returns: :list
        action :show, returns: :account
      end

      service :blogs do
        action :index, returns: :list
        action :show, returns: :blog
        service :posts do
          action :index, returns: :list
        end
      end

      namespace :admin do
        service :accounts do
          action :block, returns: :account
        end
      end
    end
  end

  describe '.routes' do

    subject { described_class.routes }

    context 'normal service' do
      it 'registers the service' do
        expect(subject).to include('accounts')
      end

      it 'registers the actions' do
        expect(subject['accounts']).to be == {'index' => :list, 'show' => :account}
      end
    end

    context 'nested services' do
      it 'registers the outer service' do
        expect(subject).to include('blogs')
      end

      it 'registers the nested service' do
        expect(subject).to include('blogs/posts')
      end
    end

    context 'namespaced services' do
      it 'does not register the namespace' do
        expect(subject).not_to include('admin')
      end

      it 'registered the nested service' do
        expect(subject).to include('admin/accounts')
      end
    end
  end

  describe '.action_return_type' do
    it 'returns the return type' do
      expect(described_class.action_return_type('accounts', 'index')).to be == 'List'
    end
  end

  describe '.clear' do
    it 'clears the routes' do
      described_class.routes
      expect {
        described_class.clear
      }.to change { described_class.instance_variable_get(:@routes) }
    end
  end
end
