require 'test_helper'

module ResourceMQ
  module Controller
    module Responder
      module Testing
        class ProductModel < Struct.new(:name, :description)
          def attributes
            {name: name, description: description}
          end
        end

        class Product
          include ResourceMQ::Message

          attribute :name, String
        end

        class Products
          include ResourceMQ::Message

          attribute :page, Integer
          attribute :total, Integer
        end

        class ProductsController < ResourceMQ::Controller::Base
          def index
            response.status = 200
          end
        end

        class ResponderTest < ActiveSupport::TestCase
          def setup
            @controller = ProductsController.new
          end

          def test_respond_with_attributes
            response = @controller.send(:respond_with, page: 1, total: 1)

            assert_equal response.message, {
                page:  1,
                total: 1
            }
          end

          def test_respond_with_model
            response = @controller.send(:respond_with, ProductModel.new('name', 'description'))
            assert_equal response.message, {
                name:        'name',
                description: 'description'
            }
          end

          def test_status
            response = @controller.send(:respond_with, status: :success)
            assert_equal response[:status], 200
            response = @controller.send(:respond_with, status: :unprocessable_entity)
            assert_equal response[:status], 422
          end
        end
      end
    end
  end
end
