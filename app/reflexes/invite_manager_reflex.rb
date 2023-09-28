# frozen_string_literal: true

class InviteManagerReflex < ApplicationReflex
  def invite
    authorize! :edit, user_form.enterprise

    if user_form.save
      morph("#add_manager_modal", render_with_locale(new_user_form))
      success("admin.send_invoice_feedback", 1)
    else
      puts render_with_locale(user_form)
      puts "########################################################"
      morph("#add_manager_modal", render_with_locale(user_form))
    end
  end

  private

  def user_form
    @user_form ||= Admin::EnterpriseUnregisteredManagerForm.new(user_form_params)
  end

  def new_user_form
    Admin::EnterpriseUnregisteredManagerForm.new
  end

  def user_form_params
    params.require(:admin_enterprise_unregistered_manager_form).permit(
      :email,
      :locale,
      :enterprise_id
    )
  end

  def render_with_locale(user_form)
    with_locale do
      render(
        partial: "admin/enterprises/form/add_new_unregistered_manager",
        locals: { user: user_form }
      )
    end
  end

  def success(i18n_key, count)
    flash[:success] = with_locale { I18n.t(i18n_key, count: count) }
    cable_ready.dispatch_event(name: "modal:close")
    morph_admin_flashes
  end
end
