module ButtonsHelper
  def notify_button(link)
    link_to 'Notify', link, method: 'POST', class: 'btn btn-warning btn-sm'
  end

  def destroy_button(link)
    link_to t('delete'), link, method: :delete, 'data-confirm' => 'Точно удалить?', class: 'btn btn-sm btn-danger'
  end

  def edit_button(link)
    link_to t('edit'), link, class: 'btn btn-sm btn-warning'
  end

  def show_button(link)
    link_to t('show'), link, class: 'btn btn-sm btn-info'
  end
end
