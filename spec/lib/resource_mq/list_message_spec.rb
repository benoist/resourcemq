require 'spec_helper'

class Post < Struct.new(:title, :body)
  def id
    @id ||= rand(100)
  end
end

class PostMessage < ResourceMQ::Message
  serializes Post

  required :title, :string
  required :body, :string
end

class PostList < ResourceMQ::ListMessage
  lists PostMessage
end

describe PostList do
  let(:posts) { [Post.new('post1', 'body1'), Post.new('post2', 'body2')] }
  let(:items) do
    posts.collect do |p|
      PostMessage.new.tap { |pm| pm.object = p }
    end
  end
  subject { described_class.new.tap { |s| s.object = posts } }

  describe '.lists' do
    it 'registers the class for listing' do
      expect(described_class.lists).to be == PostMessage
    end

    it 'adds the repeated field' do
      expect(described_class.fields[1]).to be == Beefcake::Message::Field.new(:repeated, :items, PostMessage, 1, {})
    end
  end

  describe '#object=' do
    it 'sets the object' do
      expect(subject.object).to be == posts
    end

    it 'raises an error if object is not an array' do
      expect {
        subject.object = {}
      }.to raise_error(described_class::InvalidListObjectClass)
    end

    it 'raises an error if the list contains invalid objects' do
      expect {
        subject.object = [Post.new('title', 'body'), Object.new]
      }.to raise_error(described_class::InvalidObjectClass)
    end

    it 'sets the items' do
      expect(subject.items).to be == items
    end
  end

  describe 'encoding and decoding' do
    it 'encodes and decodes the message' do
      subject.encode(buffer = '')
      expect(PostList.decode(buffer).items).to be == items
    end
  end
end
