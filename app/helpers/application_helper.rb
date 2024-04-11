module ApplicationHelper

  def toast_class_for_flash(flash_type)
    case flash_type.to_sym
    when :notice
      'bg-success text-white'
    when :alert
      'bg-danger text-white'
    else
      'bg-info text-white'
    end
  end
end
