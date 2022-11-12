ActiveAdmin.register Purchase do
  actions :all, except: [:edit]

  permit_params :status, :qualification, :code, :total, :customer_id, :restaurant_id,
                purchase_packs_attributes: [:id, :quantity, :purchase_id, :pack_id, :_destroy]

  filter :status, as: :select, collection: Purchase.statuses
  filter :qualification
  filter :code
  filter :total
  filter :customer
  filter :restaurant

  index do
    selectable_column
    id_column
    column :status
    column :qualification
    column :code
    column :total
    column :customer
    column :restaurant
    actions
  end

  show do
    attributes_table do
      row :status
      row :qualification
      row :code
      row :total
      row :customer
      row :restaurant

      panel 'Packs' do
        table_for purchase.purchase_packs do
          column :pack
          column :quantity
        end
      end
    end
  end

  form html: { enctype: 'multipart/form-data', data: { turbo: false } } do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :customer
      f.input :restaurant
      f.has_many :purchase_packs,
                 heading: 'Packs',
                 new_record: 'Añadir Pack',
                 remove_record: 'Quitar',
                 allow_destroy: true do |c|
        c.input :pack, as: :select,
                       collection: Pack.all.map { |pack|
                         [pack.select_string_for_purchase, pack.id]
                       }
        c.input :quantity
      end
    end
    f.actions
  end

  controller do
    def packs_from_same_restaurant?
      @purchase_packs_attributes.values.none? do |purchase_pack|
        pack = Pack.find_by(id: purchase_pack[:pack_id])

        pack.blank? || pack.restaurant != @restaurant
      end
    end

    def correct_stock?
      @purchase_packs_attributes.values.none? do |purchase_pack|
        pack = Pack.find_by(id: purchase_pack[:pack_id])

        pack.blank? || pack.stock < purchase_pack[:quantity].to_i
      end
    end

    def get_error(purchase)
      return purchase.errors.to_a.to_sentence unless purchase.valid?

      return 'Tiene que agregar packs' if @purchase_packs_attributes.blank?

      return 'Los packs tienen que ser del mismo restaurante' unless packs_from_same_restaurant?

      return 'No hay stock en los packs' unless correct_stock?
    end

    def create
      purchase = Purchase.new(permitted_params[:purchase].except(:purchase_packs_attributes))

      @purchase_packs_attributes = permitted_params[:purchase][:purchase_packs_attributes]
      @restaurant = purchase.restaurant

      @error = get_error(purchase)

      if @error.blank?
        purchase.save

        @purchase_packs_attributes.each_value do |purchase_pack|
          PurchasePack.create(purchase_pack.merge(purchase_id: purchase.id))
        end

        redirect_to admin_purchases_path, notice: 'Pedido creado correctamente'
      else
        redirect_to new_admin_purchase_path, alert: @error
      end
    end
  end
end
