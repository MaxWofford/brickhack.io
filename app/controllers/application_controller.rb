class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
    stored_location = stored_location_for(resource)
    if stored_location
      stored_location
    elsif current_user.admin?
      manage_root_path
    elsif current_user.questionnaire === nil
      new_questionnaires_path
    else
      @questionnaire = current_user.questionnaire
      @questionnaire.can_rsvp? ? rsvp_path : questionnaires_path
    end
  end
end
