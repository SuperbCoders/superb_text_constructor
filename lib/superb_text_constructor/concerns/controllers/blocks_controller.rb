module SuperbTextConstructor
  module Concerns
    module Controllers
      # All controller logic was moved to this concern.
      # It allows you to inherit from this class and override it if neccessary.
      # Run `rails g superb_text_contstructor:controller` to create a controller to override
      # @todo Create this generator :)
      class BlocksController < ActionController::Base
        layout 'superb_text_constructor/application'

        before_action :set_namespace
        before_action :set_parent
        before_action :set_block, only: [:edit, :update, :destroy]

        # GET /
        def index
          @blocks = @parent.blocks
        end

        # GET /blocks/new
        def new
          @block = @parent.blocks.build(type: block_class_name)
          if @block.auto?
            @block.save
            redirect_to root_url
          end
        end

        # POST /blocks/:id
        def create
          @block = @parent.blocks.build(block_params)
          if @block.save
            redirect_to root_url
          else
            render 'new'
          end
        end

        # GET /blocks/:id/edit
        def edit
        end

        # PATCH/PUT /blocks/:id
        def update
          if @block.update_attributes(block_params)
            redirect_to root_url
          else
            render 'edit'
          end
        end

        # DELETE /blocks/:id
        def destroy
          @block.destroy
          redirect_to root_url
        end

        # POST /blocks/reorder
        def reorder
          blocks = params[:blocks].map { |id| SuperbTextConstructor::Block.find(id) }
          blocks.each_with_index do |block, index|
            block.update_column(:position, index + 1)
          end
          render json: blocks
        end

        protected

          def set_namespace
            @namespace = params[:namespace]
          end

          def set_parent
            parent_param_name, parent_id = params.select { |param| param.to_s.end_with?('_id') }.first
            parent_class_name = parent_param_name.gsub(/_id\z/, '').camelize
            @parent = parent_class_name.constantize.find(parent_id)
          end

          def set_block
            @block = SuperbTextConstructor::Block.find(params[:id])
          end

          # Don't trust data from user. Allow only permitted attributes.
          def block_params
            params.require(required_params).permit(default_permitted_attributes)
          end

          # @return [Array<Symbol>] attributes that are always permitted for mass assignment
          def default_permitted_attributes
            permitted_attributes = block_class.fields.map(&:name).map(&:to_sym)
            block_class.fields.each do |field|
              (permitted_attributes << "remove_#{field.name}".to_sym) if field.uploader?
              if field.nested?
                permitted_attributes << { "#{field.name}_attributes" => [field.type.fields.map(&:name).map(&:to_sym), :id, :_destroy].flatten }
              end
            end
            permitted_attributes << :type
            permitted_attributes.uniq
          end

          def block_class_name_without_namespace
            params[:type].to_s.gsub('SuperbTextConstructor::', '')
          end

          def block_class_name
            "SuperbTextConstructor::#{block_class_name_without_namespace}"
          end

          def required_params
            block_class_name_without_namespace.underscore
          end

          def block_class
            block_class_name.constantize
          end
      end
    end
  end
end
