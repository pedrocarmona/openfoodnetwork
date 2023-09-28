# frozen_string_literal: true

class Admin::EnterpriseUnregisteredManagerForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ManagerInvitations

  validate :user_does_not_exit

  attr_accessor :email, :locale, :enterprise_id

  def save
    return false if invalid?

    new_manager = create_new_manager(email, enterprise, locale)

    return true if new_manager.errors.empty?

    errors = new_manager.errors

    new_manager
  end

  def enterprise
    @enterprise ||= Enterprise.find(enterprise_id)
  end

  def enterprise
    @enterprise ||= Enterprise.find(enterprise_id)
  end

  private

  def user_does_not_exit
    return unless Spree::User.find_by(email: email)

    errors.add(:base, I18n.t('admin.enterprises.invite_manager.user_already_exists'))
  end
end
