module NavbarHelper
  def navbar_link_to(title, href, active: nil)
    active = is_active_link? href, :inclusive if active.nil?
    active_link_to title, href,
      class: 'px-3 py-2 text-sm rounded-md',
      active_class: 'text-gray-900 font-medium',
      inactive_class: 'text-gray-600 hover:text-gray-900'
  end
end
