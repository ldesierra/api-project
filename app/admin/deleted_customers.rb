ActiveAdmin.register Customer, as: 'Deleted Customers' do
  menu parent: I18n.t('activerecord.models.customer.other'),
       priority: 2, url: -> { admin_deleted_customers_url(locale: I18n.locale) }

  controller { actions :show, :index, :destroy }
  scope :only_deleted, default: true

  after_destroy(&:really_destroy!)

  controller do
    def scoped_collection
      Customer.only_deleted
    end
  end

  action_item :restore, only: :show do
    link_to 'Restore Customer', restore_admin_deleted_customer_path(resource.id),
            method: :post
  end

  member_action :restore, method: :post do
    if resource.restore && !resource.deleted?
      redirect_to admin_deleted_customers_path, notice: 'Customer restaurado'
    else
      redirect_to admin_deleted_customers_path, alert: resource.errors.full_messages.to_sentence
    end
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :username

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :phone
    column :username
    actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :phone
      row :username
    end
  end
end
